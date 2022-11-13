//
//  TrafficInfo+Network.swift
//  
//
//  Created by Jinyu Meng on 2022/07/29.
//

import Foundation
import Network

// See https://stackoverflow.com/questions/25888272/
extension TrafficInfo {
    struct DataUsageInfo {
        var wifiReceived: UInt64 = 0
        var wifiSent: UInt64 = 0
        var wirelessWanDataReceived: UInt64 = 0
        var wirelessWanDataSent: UInt64 = 0

        mutating func updateInfoByAdding(info: DataUsageInfo) {
            wifiSent += info.wifiSent
            wifiReceived += info.wifiReceived
            wirelessWanDataSent += info.wirelessWanDataSent
            wirelessWanDataReceived += info.wirelessWanDataReceived
        }
    }

    static private let wwanInterfacePrefix = "pdp_ip"
    static private let wifiInterfacePrefix = "en"
    
    static func getDataUsage() -> DataUsageInfo {
        var interfaceAddresses: UnsafeMutablePointer<ifaddrs>? = nil

        var dataUsageInfo = DataUsageInfo()

        guard getifaddrs(&interfaceAddresses) == 0 else { return dataUsageInfo }

        var pointer = interfaceAddresses
        while pointer != nil {
            guard let info = getDataUsageInfo(from: pointer!) else {
                pointer = pointer!.pointee.ifa_next
                continue
            }
            dataUsageInfo.updateInfoByAdding(info: info)
            pointer = pointer!.pointee.ifa_next
        }

        freeifaddrs(interfaceAddresses)

        return dataUsageInfo
    }

    private static func getDataUsageInfo(from infoPointer: UnsafeMutablePointer<ifaddrs>) -> DataUsageInfo? {
        let pointer = infoPointer

        let name: String! = String(cString: infoPointer.pointee.ifa_name)
        let addr = pointer.pointee.ifa_addr.pointee
        guard addr.sa_family == UInt8(AF_LINK) else { return nil }

        return dataUsageInfo(from: pointer, name: name)
    }

    private static func dataUsageInfo(from pointer: UnsafeMutablePointer<ifaddrs>, name: String) -> DataUsageInfo {
        var networkData: UnsafeMutablePointer<if_data>? = nil
        var dataUsageInfo = DataUsageInfo()

        if name.hasPrefix(wifiInterfacePrefix) {
            networkData = unsafeBitCast(pointer.pointee.ifa_data, to: UnsafeMutablePointer<if_data>.self)
            dataUsageInfo.wifiSent += UInt64(networkData?.pointee.ifi_obytes ?? 0)
            dataUsageInfo.wifiReceived += UInt64(networkData?.pointee.ifi_ibytes ?? 0)
        } else if name.hasPrefix(wwanInterfacePrefix) {
            networkData = unsafeBitCast(pointer.pointee.ifa_data, to: UnsafeMutablePointer<if_data>.self)
            dataUsageInfo.wirelessWanDataSent += UInt64(networkData?.pointee.ifi_obytes ?? 0)
            dataUsageInfo.wirelessWanDataReceived += UInt64(networkData?.pointee.ifi_ibytes ?? 0)
        }

        return dataUsageInfo
    }
}

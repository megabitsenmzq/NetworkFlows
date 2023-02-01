//
//  TrafficInfo.swift
//  
//
//  Created by Jinyu Meng on 2022/07/29.
//

import Foundation
import Network

/// An item inside a traffic info pack.
public struct TrafficInfoItem {
    public var byteCount: Int /// Number count in bytes.
    public var humanReadableNumber: String /// Number part of the formatted string. "100.5"
    public var humanReadableNumberUnit: String /// Unit part of the formatted string. "MB"
}

/// A pack of traffic info. Represents total or traffic per second.
public struct TrafficInfoPack {
    public var cellularUp: TrafficInfoItem /// Cellular upload.
    public var cellularDown: TrafficInfoItem /// Cellular download.
    public var cellularTotal: TrafficInfoItem /// Cellular uploads + downloads.
    public var wifiUp: TrafficInfoItem /// Wifi upload.
    public var wifiDown: TrafficInfoItem /// Wifi download.
    public var wifiTotal: TrafficInfoItem /// Wifi uploads + downloads.
    public var upTotal: TrafficInfoItem /// Cellular + wifi upload.
    public var downTotal: TrafficInfoItem /// Cellular + wifi download.
}

/// Provides current total traffic info.
public class TotalTraffic {
    
    static let formatter = ByteFormatter.shared
    
    /// Static total traffic info.
    public static func getTotalTraffic() -> TrafficInfoPack {
        let info = getDataUsage()
        
        let cellularUp = TrafficInfoItem(
            byteCount: Int(info.wirelessWanDataSent),
            humanReadableNumber: formatter.humanReadableNumber(Int64(info.wirelessWanDataSent)),
            humanReadableNumberUnit: formatter.humanReadableNumberUnit(Int64(info.wirelessWanDataSent))
        )
        
        let cellularDown = TrafficInfoItem(
            byteCount: Int(info.wirelessWanDataReceived),
            humanReadableNumber: formatter.humanReadableNumber(Int64(info.wirelessWanDataReceived)),
            humanReadableNumberUnit: formatter.humanReadableNumberUnit(Int64(info.wirelessWanDataReceived))
        )
        
        let cellularTotal = TrafficInfoItem(
            byteCount: cellularUp.byteCount + cellularDown.byteCount,
            humanReadableNumber: formatter.humanReadableNumber(Int64(cellularUp.byteCount + cellularDown.byteCount)),
            humanReadableNumberUnit: formatter.humanReadableNumberUnit(Int64(cellularUp.byteCount + cellularDown.byteCount))
        )
        
        let wifiUp = TrafficInfoItem(
            byteCount: Int(info.wifiSent),
            humanReadableNumber: formatter.humanReadableNumber(Int64(info.wifiSent)),
            humanReadableNumberUnit: formatter.humanReadableNumberUnit(Int64(info.wifiSent))
        )
        
        let wifiDown = TrafficInfoItem(
            byteCount: Int(info.wifiReceived),
            humanReadableNumber: formatter.humanReadableNumber(Int64(info.wifiReceived)),
            humanReadableNumberUnit: formatter.humanReadableNumberUnit(Int64(info.wifiReceived))
        )
        
        let wifiTotal = TrafficInfoItem(
            byteCount: wifiUp.byteCount + wifiDown.byteCount,
            humanReadableNumber: formatter.humanReadableNumber(Int64(wifiUp.byteCount + wifiDown.byteCount)),
            humanReadableNumberUnit: formatter.humanReadableNumberUnit(Int64(wifiUp.byteCount + wifiDown.byteCount))
        )
        
        let upTotal = TrafficInfoItem(
            byteCount: cellularUp.byteCount + wifiUp.byteCount,
            humanReadableNumber: formatter.humanReadableNumber(Int64(cellularUp.byteCount + wifiUp.byteCount)),
            humanReadableNumberUnit: formatter.humanReadableNumberUnit(Int64(cellularUp.byteCount + wifiUp.byteCount))
        )
        
        let downTotal = TrafficInfoItem(
            byteCount: cellularDown.byteCount + wifiDown.byteCount,
            humanReadableNumber: formatter.humanReadableNumber(Int64(cellularDown.byteCount + wifiDown.byteCount)),
            humanReadableNumberUnit: formatter.humanReadableNumberUnit(Int64(cellularDown.byteCount + wifiDown.byteCount))
        )
        
        return TrafficInfoPack(
            cellularUp: cellularUp,
            cellularDown: cellularDown,
            cellularTotal: cellularTotal,
            wifiUp: wifiUp,
            wifiDown: wifiDown,
            wifiTotal: wifiTotal,
            upTotal: upTotal,
            downTotal: downTotal
        )
    }
}

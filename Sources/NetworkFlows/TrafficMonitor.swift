//
//  TrafficMonitor.swift
//  
//
//  Created by Jinyu Meng on 2022/07/29.
//

import Foundation

enum TrafficMonitorError: Error {
    case internalError(String)
}


public struct TrafficInfo {
    public var totalTrafficInfo: TotalTrafficInfo
    public var cellularTrafficUp: TrafficInfoItem
    public var cellularTrafficDown: TrafficInfoItem
    public var cellularTrafficTotal: TrafficInfoItem
    public var wifiTrafficUp: TrafficInfoItem
    public var wifiTrafficDown: TrafficInfoItem
    public var wifiTrafficTotal: TrafficInfoItem
    public var upTrafficTotal: TrafficInfoItem
    public var downTrafficTotal: TrafficInfoItem
}

/// A delegate for TrafficMonitor class. Call you if new info arrived.
public protocol TrafficMonitorDelegate: AnyObject {
    func trafficMonitor(updatedInfo: TrafficInfo) /// Call you if new info arrived.
}

public class TrafficMonitor: NSObject {
    public static let shared = TrafficMonitor() /// A singleton of the TrafficMonitor class.
    public weak var delegate: TrafficMonitorDelegate? /// Call you if new info arrived.
    
    let formatter = ByteFormatter.shared
    var timer: Timer?
    
    var historyTotal: TotalTrafficInfo?
    var newTrafficInfo: TrafficInfo?
    
    override init() {
        super.init()
        timer = Timer(timeInterval: 1, target: self, selector: #selector(timerUpdated), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        timerUpdated()
    }
    
    @objc func timerUpdated() {
        guard let info = calcTrafficInfo() else { return }
        newTrafficInfo = info
        delegate?.trafficMonitor(updatedInfo: info)
    }
    
    /// Get latest traffic per second for one time. Non-async version of this function also available.
    /// - Returns: Latest traffic per second info.
    @available(macOS 10.15, *)
    @available(iOS 13.0, *)
    public func getTrafficInfo() async throws -> TrafficInfo {
        if let newTrafficInfo = newTrafficInfo {
            return newTrafficInfo
        } else {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            guard let newTrafficInfo = newTrafficInfo else {
                throw TrafficMonitorError.internalError("Timer not running.")
            }
            return newTrafficInfo
        }
    }
    
    /// Get latest traffic per second for one time. Async version of this function also available.
    /// - Parameter completion: Callback to give you latest traffic per second info.
    public func getTrafficInfo(completion: @escaping (TrafficInfo)->()) {
        if let newTrafficInfo = newTrafficInfo {
            completion(newTrafficInfo)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                guard let newTrafficInfo = self.newTrafficInfo else { return }
                completion(newTrafficInfo)
            }
        }
    }
    
    func calcTrafficInfo() -> TrafficInfo? {
        let trafficInfo = TotalTraffic.getTotalTrafficInfo()
        
        guard let historyTraffic = historyTotal else {
            historyTotal = trafficInfo
            return nil
        }
        
        let cellularUp = TrafficInfoItem(
            byteCount: trafficInfo.cellularUp.byteCount - historyTraffic.cellularUp.byteCount,
            humanReadableNumber: formatter.humanReadableNumber(Int64(trafficInfo.cellularUp.byteCount - historyTraffic.cellularUp.byteCount)),
            humanReadableNumberUnit: formatter.humanReadableNumberUnit(Int64(trafficInfo.cellularUp.byteCount - historyTraffic.cellularUp.byteCount)) + "/s"
        )
        
        let cellularDown = TrafficInfoItem(
            byteCount: trafficInfo.cellularDown.byteCount - historyTraffic.cellularDown.byteCount,
            humanReadableNumber: formatter.humanReadableNumber(Int64(trafficInfo.cellularDown.byteCount - historyTraffic.cellularDown.byteCount)),
            humanReadableNumberUnit: formatter.humanReadableNumberUnit(Int64(trafficInfo.cellularDown.byteCount - historyTraffic.cellularDown.byteCount)) + "/s"
        )
        
        let cellularTotal = TrafficInfoItem(
            byteCount: cellularUp.byteCount + cellularDown.byteCount,
            humanReadableNumber: formatter.humanReadableNumber(Int64(cellularUp.byteCount + cellularDown.byteCount)),
            humanReadableNumberUnit: formatter.humanReadableNumberUnit(Int64(cellularUp.byteCount + cellularDown.byteCount)) + "/s"
        )
        
        let wifiUp = TrafficInfoItem(
            byteCount: trafficInfo.wifiUp.byteCount - historyTraffic.wifiUp.byteCount,
            humanReadableNumber: formatter.humanReadableNumber(Int64(trafficInfo.wifiUp.byteCount - historyTraffic.wifiUp.byteCount)),
            humanReadableNumberUnit: formatter.humanReadableNumberUnit(Int64(trafficInfo.wifiUp.byteCount - historyTraffic.wifiUp.byteCount)) + "/s"
        )
        
        let wifiDown = TrafficInfoItem(
            byteCount: trafficInfo.wifiDown.byteCount - historyTraffic.wifiDown.byteCount,
            humanReadableNumber: formatter.humanReadableNumber(Int64(trafficInfo.wifiDown.byteCount - historyTraffic.wifiDown.byteCount)),
            humanReadableNumberUnit: formatter.humanReadableNumberUnit(Int64(trafficInfo.wifiDown.byteCount - historyTraffic.wifiDown.byteCount)) + "/s"
        )
        
        let wifiTotal = TrafficInfoItem(
            byteCount: wifiUp.byteCount + wifiDown.byteCount,
            humanReadableNumber: formatter.humanReadableNumber(Int64(wifiUp.byteCount + wifiDown.byteCount)),
            humanReadableNumberUnit: formatter.humanReadableNumberUnit(Int64(wifiUp.byteCount + wifiDown.byteCount)) + "/s"
        )
        
        let upTotal = TrafficInfoItem(
            byteCount: cellularUp.byteCount + wifiUp.byteCount,
            humanReadableNumber: formatter.humanReadableNumber(Int64(cellularUp.byteCount + wifiUp.byteCount)),
            humanReadableNumberUnit: formatter.humanReadableNumberUnit(Int64(cellularUp.byteCount + wifiUp.byteCount)) + "/s"
        )
        
        let downTotal = TrafficInfoItem(
            byteCount: cellularDown.byteCount + wifiDown.byteCount,
            humanReadableNumber: formatter.humanReadableNumber(Int64(cellularDown.byteCount + wifiDown.byteCount)),
            humanReadableNumberUnit: formatter.humanReadableNumberUnit(Int64(cellularDown.byteCount + wifiDown.byteCount)) + "/s"
        )
        
        let info = TrafficInfo(
            totalTrafficInfo: trafficInfo,
            cellularTrafficUp: cellularUp,
            cellularTrafficDown: cellularDown,
            cellularTrafficTotal: cellularTotal,
            wifiTrafficUp: wifiUp,
            wifiTrafficDown: wifiDown,
            wifiTrafficTotal: wifiTotal,
            upTrafficTotal: upTotal,
            downTrafficTotal: downTotal
        )
        
        self.historyTotal = trafficInfo
        
        return info
    }
}

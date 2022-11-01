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


public struct TrafficPerSecondInfo {
    public var totalTrafficInfo: TotalCountInfo
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
    func trafficMonitor(updatedInfo: TrafficPerSecondInfo) /// Call you if new info arrived.
}

public class TrafficMonitor: NSObject {
    public static let shared = TrafficMonitor() /// A singleton of the TrafficMonitor class.
    public weak var delegate: TrafficMonitorDelegate? /// Call you if new info arrived.
    
    let formatter = ByteFomatter.shared
    var timer: Timer?
    
    var oldTraffic: TotalCountInfo?
    var oldTrafficPerSecond: TrafficPerSecondInfo?
    
    override init() {
        super.init()
        timer = Timer(timeInterval: 1, target: self, selector: #selector(timerUpdated), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        timerUpdated()
    }
    
    @objc func timerUpdated() {
        guard let info = calcTrafficPerSecondInfo() else { return }
        oldTrafficPerSecond = info
        delegate?.trafficMonitor(updatedInfo: info)
    }
    
    /// Get latest traffic per second for one time. Non-async version of this function also avaliable.
    /// - Returns: Latest traffic per second info.
    @available(iOS 13.0, *)
    public func getTrafficPerSecondInfo() async throws -> TrafficPerSecondInfo {
        if let oldTrafficPerSecond = oldTrafficPerSecond {
            return oldTrafficPerSecond
        } else {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            guard let oldTrafficPerSecond = oldTrafficPerSecond else {
                throw TrafficMonitorError.internalError("Timer not running.")
            }
            return oldTrafficPerSecond
        }
    }
    
    /// Get latest traffic per second for one time. Async version of this function also avaliable.
    /// - Parameter completion: Callback to give you latest traffic per second info.
    public func getTrafficPerSecondInfo(completion: @escaping (TrafficPerSecondInfo)->()) {
        if let oldTrafficPerSecond = oldTrafficPerSecond {
            completion(oldTrafficPerSecond)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                guard let oldTrafficPerSecond = self.oldTrafficPerSecond else { return }
                completion(oldTrafficPerSecond)
            }
        }
    }
    
    func calcTrafficPerSecondInfo() -> TrafficPerSecondInfo? {
        let trafficInfo = TrafficInfo.getTotalCountInfo()
        
        guard let oldTraffic = oldTraffic else {
            oldTraffic = trafficInfo
            return nil
        }
        
        let cellularUp = TrafficInfoItem(
            byteCount: trafficInfo.cellularUp.byteCount - oldTraffic.cellularUp.byteCount,
            humanReadableNumber: formatter.humanReadableNumber(Int64(trafficInfo.cellularUp.byteCount - oldTraffic.cellularUp.byteCount)),
            humanReadableNumberUnit: formatter.humanReadableNumberUnit(Int64(trafficInfo.cellularUp.byteCount - oldTraffic.cellularUp.byteCount)) + "/s"
        )
        
        let cellularDown = TrafficInfoItem(
            byteCount: trafficInfo.cellularDown.byteCount - oldTraffic.cellularDown.byteCount,
            humanReadableNumber: formatter.humanReadableNumber(Int64(trafficInfo.cellularDown.byteCount - oldTraffic.cellularDown.byteCount)),
            humanReadableNumberUnit: formatter.humanReadableNumberUnit(Int64(trafficInfo.cellularDown.byteCount - oldTraffic.cellularDown.byteCount)) + "/s"
        )
        
        let cellularTotal = TrafficInfoItem(
            byteCount: cellularUp.byteCount + cellularDown.byteCount,
            humanReadableNumber: formatter.humanReadableNumber(Int64(cellularUp.byteCount + cellularDown.byteCount)),
            humanReadableNumberUnit: formatter.humanReadableNumberUnit(Int64(cellularUp.byteCount + cellularDown.byteCount)) + "/s"
        )
        
        let wifiUp = TrafficInfoItem(
            byteCount: trafficInfo.wifiUp.byteCount - oldTraffic.wifiUp.byteCount,
            humanReadableNumber: formatter.humanReadableNumber(Int64(trafficInfo.wifiUp.byteCount - oldTraffic.wifiUp.byteCount)),
            humanReadableNumberUnit: formatter.humanReadableNumberUnit(Int64(trafficInfo.wifiUp.byteCount - oldTraffic.wifiUp.byteCount)) + "/s"
        )
        
        let wifiDown = TrafficInfoItem(
            byteCount: trafficInfo.wifiDown.byteCount - oldTraffic.wifiDown.byteCount,
            humanReadableNumber: formatter.humanReadableNumber(Int64(trafficInfo.wifiDown.byteCount - oldTraffic.wifiDown.byteCount)),
            humanReadableNumberUnit: formatter.humanReadableNumberUnit(Int64(trafficInfo.wifiDown.byteCount - oldTraffic.wifiDown.byteCount)) + "/s"
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
        
        let info = TrafficPerSecondInfo(
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
        
        self.oldTraffic = trafficInfo
        
        return info
    }
}

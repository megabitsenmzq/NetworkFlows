//
//  TrafficMonitor.swift
//  
//
//  Created by Jinyu Meng on 2022/07/29.
//

import Foundation
/// Result struct.
public struct TrafficInfo {
    public var totalTraffic: TrafficInfoPack
    public var trafficPerSecond: TrafficInfoPack
}

/// A delegate for the TrafficMonitor class. Implement to receive new traffic info.
public protocol TrafficMonitorDelegate: AnyObject {
    func trafficMonitor(updatedInfo: TrafficInfo) /// Call you if new info arrived.
}

/// Main class, monitor total traffic every second.
public class TrafficMonitor: NSObject {
    public static let shared = TrafficMonitor()
    public weak var delegate: TrafficMonitorDelegate?
    
    let formatter = ByteFormatter.shared
    var timer: Timer?
    
    var historyTotal: TrafficInfoPack?
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
    
    func calcTrafficInfo() -> TrafficInfo? {
        let totalTraffic = TotalTraffic.getTotalTraffic()
        
        guard let historyTraffic = historyTotal else {
            historyTotal = totalTraffic
            return nil
        }
        
        let cellularUp = TrafficInfoItem(
            byteCount: totalTraffic.cellularUp.byteCount - historyTraffic.cellularUp.byteCount,
            humanReadableNumber: formatter.humanReadableNumber(Int64(totalTraffic.cellularUp.byteCount - historyTraffic.cellularUp.byteCount)),
            humanReadableNumberUnit: formatter.humanReadableNumberUnit(Int64(totalTraffic.cellularUp.byteCount - historyTraffic.cellularUp.byteCount)) + "/s"
        )
        
        let cellularDown = TrafficInfoItem(
            byteCount: totalTraffic.cellularDown.byteCount - historyTraffic.cellularDown.byteCount,
            humanReadableNumber: formatter.humanReadableNumber(Int64(totalTraffic.cellularDown.byteCount - historyTraffic.cellularDown.byteCount)),
            humanReadableNumberUnit: formatter.humanReadableNumberUnit(Int64(totalTraffic.cellularDown.byteCount - historyTraffic.cellularDown.byteCount)) + "/s"
        )
        
        let cellularTotal = TrafficInfoItem(
            byteCount: cellularUp.byteCount + cellularDown.byteCount,
            humanReadableNumber: formatter.humanReadableNumber(Int64(cellularUp.byteCount + cellularDown.byteCount)),
            humanReadableNumberUnit: formatter.humanReadableNumberUnit(Int64(cellularUp.byteCount + cellularDown.byteCount)) + "/s"
        )
        
        let wifiUp = TrafficInfoItem(
            byteCount: totalTraffic.wifiUp.byteCount - historyTraffic.wifiUp.byteCount,
            humanReadableNumber: formatter.humanReadableNumber(Int64(totalTraffic.wifiUp.byteCount - historyTraffic.wifiUp.byteCount)),
            humanReadableNumberUnit: formatter.humanReadableNumberUnit(Int64(totalTraffic.wifiUp.byteCount - historyTraffic.wifiUp.byteCount)) + "/s"
        )
        
        let wifiDown = TrafficInfoItem(
            byteCount: totalTraffic.wifiDown.byteCount - historyTraffic.wifiDown.byteCount,
            humanReadableNumber: formatter.humanReadableNumber(Int64(totalTraffic.wifiDown.byteCount - historyTraffic.wifiDown.byteCount)),
            humanReadableNumberUnit: formatter.humanReadableNumberUnit(Int64(totalTraffic.wifiDown.byteCount - historyTraffic.wifiDown.byteCount)) + "/s"
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
        
        let perSecond = TrafficInfoPack(
            cellularUp: cellularUp,
            cellularDown: cellularDown,
            cellularTotal: cellularTotal,
            wifiUp: wifiUp,
            wifiDown: wifiDown,
            wifiTotal: wifiTotal,
            upTotal: upTotal,
            downTotal: downTotal
        )
        
        let info = TrafficInfo(
            totalTraffic: totalTraffic,
            trafficPerSecond: perSecond
        )
        
        self.historyTotal = totalTraffic
        
        return info
    }
}

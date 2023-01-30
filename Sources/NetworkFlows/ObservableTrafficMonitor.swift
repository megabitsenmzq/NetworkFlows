//
//  ObservableTrafficMonitor.swift
//  
//
//  Created by Jinyu Meng on 2023/01/31.
//

import Foundation

@available(iOS 13.0, *)
public class ObservableTrafficMonitor: TrafficMonitor, ObservableObject {
    
    public override init() {
        super.init()
    }
    
    public override var historyTraffic: TotalCountInfo? {
        willSet { objectWillChange.send() }
    }
    public override var historyTrafficPerSecond: TrafficPerSecondInfo? {
        willSet { objectWillChange.send() }
    }
}

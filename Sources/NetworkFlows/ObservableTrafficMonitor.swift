//
//  ObservableTrafficMonitor.swift
//  
//
//  Created by Jinyu Meng on 2023/01/31.
//

import Foundation

/// Observable version of the main class.
@available(macOS 10.15, *)
@available(iOS 13.0, *)
public class ObservableTrafficMonitor: TrafficMonitor, ObservableObject {
    public static let observableShared = ObservableTrafficMonitor()
    
    public override init() {
        super.init()
    }
    
    /// Observe this variable to get new traffic info.
    public override var newTrafficInfo: TrafficInfo? {
        willSet { objectWillChange.send() }
    }
}

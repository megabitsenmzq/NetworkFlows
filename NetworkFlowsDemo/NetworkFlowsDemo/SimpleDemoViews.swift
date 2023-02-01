//
//  SimpleDemoViews.swift
//  NetworkFlowsDemo
//
//  Created by Jinyu Meng on 2023/02/01.
//

import Foundation
import SwiftUI
import NetworkFlows

struct ObservedDemoView: View {
    @ObservedObject var traffic = ObservableTrafficMonitor.observableShared
    var body: some View {
        VStack {
            Text("ObservedDemoView")
            Text(traffic.newTrafficInfo?.trafficPerSecond.downTotal.humanReadableNumber ?? "--")
            +
            Text(" ")
            +
            Text(traffic.newTrafficInfo?.trafficPerSecond.downTotal.humanReadableNumberUnit ?? "--")
        }
        .padding()
    }
}

class DelegateDemoViewModal: ObservableObject, TrafficMonitorDelegate {
    
    @Published var downTotalPerSecond = "-- --"
    init() {
        TrafficMonitor.shared.delegate = self
    }
    
    func trafficMonitor(updatedInfo: TrafficInfo) {
        let number = updatedInfo.trafficPerSecond.downTotal.humanReadableNumber
        let unit = updatedInfo.trafficPerSecond.downTotal.humanReadableNumberUnit
        downTotalPerSecond = number + " " + unit
    }
}

struct DelegateDemoView: View {
    @ObservedObject var modal = DelegateDemoViewModal()
    var body: some View {
        VStack {
            Text("DelegateDemoView")
            Text(modal.downTotalPerSecond)
        }
        .padding()
    }
}

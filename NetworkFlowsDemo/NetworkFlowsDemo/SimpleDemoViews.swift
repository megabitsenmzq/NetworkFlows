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
            Text(traffic.newTrafficInfo?.downTrafficTotal.humanReadableNumber ?? "--")
            +
            Text(" ")
            +
            Text(traffic.newTrafficInfo?.downTrafficTotal.humanReadableNumberUnit ?? "--")
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
        let number = updatedInfo.totalTrafficInfo.downTotal.humanReadableNumber
        let unit = updatedInfo.totalTrafficInfo.downTotal.humanReadableNumberUnit
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

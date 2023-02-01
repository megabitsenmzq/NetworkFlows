//
//  ComplexDemoView.swift
//  NetworkFlowsDemo
//
//  Created by Jinyu Meng on 2023/02/01.
//

import SwiftUI
import NetworkFlows

struct ComplexDemoView: View {
    @ObservedObject var traffic = ObservableTrafficMonitor.observableShared
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Image(systemName: "wifi")
                        .opacity(0.5)
                    Spacer()
                    Text(traffic.newTrafficInfo?.totalTraffic.wifiTotal.humanReadableNumber ?? "--")
                    +
                    Text(" ")
                    +
                    Text(traffic.newTrafficInfo?.totalTraffic.wifiTotal.humanReadableNumberUnit ?? "--")
                }
                HStack {
                    Image(systemName: "antenna.radiowaves.left.and.right")
                        .opacity(0.5)
                    Spacer()
                    Text(traffic.newTrafficInfo?.totalTraffic.cellularTotal.humanReadableNumber ?? "--")
                    +
                    Text(" ")
                    +
                    Text(traffic.newTrafficInfo?.totalTraffic.cellularTotal.humanReadableNumberUnit ?? "--")
                }
            }
            VStack {
                HStack {
                    Image(systemName: "chevron.up")
                        .opacity(0.5)
                    Spacer()
                    Text(traffic.newTrafficInfo?.trafficPerSecond.upTotal.humanReadableNumber ?? "--")
                    +
                    Text(" ")
                    +
                    Text(traffic.newTrafficInfo?.trafficPerSecond.upTotal.humanReadableNumberUnit ?? "--")
                }
                HStack {
                    Image(systemName: "chevron.down")
                        .opacity(0.5)
                    Spacer()
                    Text(traffic.newTrafficInfo?.trafficPerSecond.downTotal.humanReadableNumber ?? "--")
                    +
                    Text(" ")
                    +
                    Text(traffic.newTrafficInfo?.trafficPerSecond.downTotal.humanReadableNumberUnit ?? "--")
                }
            }
        }
        .padding(50)
    }
}

struct ComplexDemoView_Previews: PreviewProvider {
    static var previews: some View {
        ComplexDemoView()
    }
}

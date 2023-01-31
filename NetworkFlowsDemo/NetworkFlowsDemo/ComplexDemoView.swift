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
                    Text(traffic.newTrafficInfo?.totalTrafficInfo.wifiTotal.humanReadableNumber ?? "--")
                    +
                    Text(" ")
                    +
                    Text(traffic.newTrafficInfo?.totalTrafficInfo.wifiTotal.humanReadableNumberUnit ?? "--")
                }
                HStack {
                    Image(systemName: "antenna.radiowaves.left.and.right")
                        .opacity(0.5)
                    Spacer()
                    Text(traffic.newTrafficInfo?.totalTrafficInfo.cellularTotal.humanReadableNumber ?? "--")
                    +
                    Text(" ")
                    +
                    Text(traffic.newTrafficInfo?.totalTrafficInfo.cellularTotal.humanReadableNumberUnit ?? "--")
                }
            }
            VStack {
                HStack {
                    Image(systemName: "chevron.up")
                        .opacity(0.5)
                    Spacer()
                    Text(traffic.newTrafficInfo?.upTrafficTotal.humanReadableNumber ?? "--")
                    +
                    Text(" ")
                    +
                    Text(traffic.newTrafficInfo?.upTrafficTotal.humanReadableNumberUnit ?? "--")
                }
                HStack {
                    Image(systemName: "chevron.down")
                        .opacity(0.5)
                    Spacer()
                    Text(traffic.newTrafficInfo?.downTrafficTotal.humanReadableNumber ?? "--")
                    +
                    Text(" ")
                    +
                    Text(traffic.newTrafficInfo?.downTrafficTotal.humanReadableNumberUnit ?? "--")
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

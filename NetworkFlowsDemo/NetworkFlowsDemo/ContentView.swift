//
//  ContentView.swift
//  NetworkFlowsDemo
//
//  Created by Jinyu Meng on 2023/01/31.
//

import SwiftUI
import NetworkFlows

struct ContentView: View {
    @ObservedObject var traffic = ObservableTrafficMonitor()
    var body: some View {
        VStack {
            Text("123")
            Text(traffic.historyTraffic?.upTotal.humanReadableNumber ?? "")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

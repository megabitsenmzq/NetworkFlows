//
//  ContentView.swift
//  NetworkFlowsDemo
//
//  Created by Jinyu Meng on 2023/01/31.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ObservedDemoView()
            DelegateDemoView()
            ComplexDemoView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

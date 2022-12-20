//
//  ContentView.swift
//  timeseries-explorer
//
//  Created by Blaine Rothrock on 12/19/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            NavigationLink(
                "Signal Explorer",
                destination: SignalExplorerView()
            )

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

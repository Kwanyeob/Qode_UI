//
//  ContentView.swift
//  feature_ky
//
//  Created by Kwan Yeob Jung on 2025-04-04.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView().previewDevice("iphone15")
}

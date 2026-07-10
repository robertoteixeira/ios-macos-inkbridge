//
//  ContentView.swift
//  InkBridgeMac
//
//  Created by Roberto Teixeira on 06/07/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var isOverlayVisible = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("InkBridge Mac")
                .font(.title)

            Text(isOverlayVisible ? "Overlay visible" : "Overlay hidden")
                .foregroundStyle(.secondary)

            Button {
                isOverlayVisible.toggle()
            } label: {
                Label(
                    isOverlayVisible ? "Hide Overlay" : "Show Overlay",
                    systemImage: isOverlayVisible ? "eye.slash" : "eye"
                )
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(minWidth: 320, minHeight: 180)
    }
}

#Preview {
    ContentView()
}

//
//  ContentView.swift
//  InkBridgeMac
//
//  Created by Roberto Teixeira on 06/07/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var isOverlayVisible = false
    @State private var overlayWindowController = OverlayWindowController()

    var body: some View {
        MacControlPanelView(
            isOverlayVisible: isOverlayVisible,
            onToggleOverlay: toggleOverlay,
            onClearOverlay: {
                overlayWindowController.clear()
            },
            onAddTestStroke: {
                overlayWindowController.addTestStroke()
            }
        )
        .padding()
        .frame(minWidth: 320, minHeight: 180)
    }
    
    private func toggleOverlay() {
        isOverlayVisible.toggle()

        if isOverlayVisible {
            overlayWindowController.showOverlay()
        } else {
            overlayWindowController.hideOverlay()
        }
    }
}

#Preview {
    ContentView()
}

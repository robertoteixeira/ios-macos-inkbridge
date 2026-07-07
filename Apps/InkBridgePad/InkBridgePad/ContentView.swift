//
//  ContentView.swift
//  InkBridgePad
//
//  Created by Roberto Teixeira on 06/07/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        DrawingCanvasView()
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}

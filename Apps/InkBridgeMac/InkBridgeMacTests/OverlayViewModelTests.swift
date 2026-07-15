//
//  OverlayViewModelTests.swift
//  InkBridgeMac
//
//  Created by Roberto Teixeira on 11/07/2026.
//

import Testing
@testable import InkBridgeMac
import InkBridgeProtocol

@Test func handleStrokeEventsCreatesCompletedStroke() {
    let viewModel = OverlayViewModel()

    viewModel.clear()

    let style = InkBridgeProtocol.StrokeStyle(
        colorHex: "#00AAFF",
        width: 8,
        opacity: 1.0,
        tool: .pen
    )

    viewModel.handle(
        .strokeBegan(
            StrokePoint(x: 0.1, y: 0.2, pressure: 1.0, timestamp: 1),
            style
        )
    )

    #expect(viewModel.strokes.isEmpty)
    #expect(viewModel.activeStroke?.points.count == 1)

    viewModel.handle(
        .strokeMoved([
            StrokePoint(x: 0.3, y: 0.4, pressure: 1.0, timestamp: 2)
        ])
    )

    #expect(viewModel.activeStroke?.points.count == 2)

    viewModel.handle(
        .strokeEnded(
            StrokePoint(x: 0.5, y: 0.6, pressure: 1.0, timestamp: 3)
        )
    )

    #expect(viewModel.activeStroke == nil)
    #expect(viewModel.strokes.count == 1)
    #expect(viewModel.strokes[0].points.count == 3)
    #expect(viewModel.strokes[0].style == style)
}

@Test func handleClearCanvasRemovesStrokes() {
    let viewModel = OverlayViewModel()

    let style = InkBridgeProtocol.StrokeStyle(
        colorHex: "#00AAFF",
        width: 8,
        opacity: 1.0,
        tool: .pen
    )

    viewModel.handle(.strokeBegan(StrokePoint(x: 0.1, y: 0.2, pressure: 1.0, timestamp: 1), style))
    viewModel.handle(.strokeEnded(StrokePoint(x: 0.3, y: 0.4, pressure: 1.0, timestamp: 2)))

    #expect(!viewModel.strokes.isEmpty)

    viewModel.handle(.clearCanvas)

    #expect(viewModel.strokes.isEmpty)
    #expect(viewModel.activeStroke == nil)
}

@Test func handleEmptyUndoRedoAndModeChangedDoesNotChangeStrokeState() {
    let viewModel = OverlayViewModel()

    viewModel.handle(.undo)
    viewModel.handle(.redo)
    viewModel.handle(.modeChanged(.overlay))

    #expect(viewModel.strokes.isEmpty)
    #expect(viewModel.activeStroke == nil)
}

@Test func handleUndoAndRedoUpdatesCompletedStrokes() {
    let viewModel = OverlayViewModel()

    let style = InkBridgeProtocol.StrokeStyle(
        colorHex: "#00AAFF",
        width: 8,
        opacity: 1.0,
        tool: .pen
    )

    viewModel.handle(.strokeBegan(StrokePoint(x: 0.1, y: 0.2, pressure: 1.0, timestamp: 1), style))
    viewModel.handle(.strokeEnded(StrokePoint(x: 0.3, y: 0.4, pressure: 1.0, timestamp: 2)))

    #expect(viewModel.strokes.count == 1)

    viewModel.handle(.undo)
    #expect(viewModel.strokes.isEmpty)

    viewModel.handle(.redo)
    #expect(viewModel.strokes.count == 1)
}

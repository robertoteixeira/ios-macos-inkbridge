# InkBridge

InkBridge lets an iPad act as a drawing remote for a Mac overlay.

## Current Demo Flow

1. Open `InkBridge.xcworkspace`.
2. Run `InkBridgeMac`.
3. Click **Start Overlay**. This shows the transparent overlay and starts the remote input listener on port `9876`.
4. Run `InkBridgePad` on an iPad, iPhone, or simulator.
5. Wait for `InkBridge Mac` to appear under discovery.
6. Tap the discovered Mac.
7. Draw on the Pad. Strokes appear on the Mac overlay.
8. Use the Pad controls to change pen, marker, highlighter, color, and width.
9. Use undo, redo, and clear from the Pad.

Manual IP connection is still available with port `9876`.

## Finding The Mac IP

On the Mac:

    ipconfig getifaddr en0

## Verifying The Mac Listener

After showing the overlay:

    lsof -nP -iTCP:9876 -sTCP:LISTEN

## Build Checks

Protocol package:

    swift test --package-path Packages/InkBridgeProtocol

Rendering package:

    swift test --package-path Packages/InkBridgeRendering

Networking package:

    swift test --package-path Packages/InkBridgeNetworking

Mac build:

    xcodebuild build -workspace InkBridge.xcworkspace -scheme InkBridgeMac -destination 'platform=macOS'

Pad build:

    xcodebuild build -workspace InkBridge.xcworkspace -scheme InkBridgePad -destination 'generic/platform=iOS Simulator'

## Notes

Bonjour discovery is implemented for the local network flow. Manual IP connection remains available as a fallback.

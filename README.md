# InkBridge

InkBridge lets an iPad act as a drawing remote for a Mac overlay.

## Current Demo Flow

1. Open `InkBridge.xcworkspace`.
2. Run `InkBridgeMac`.
3. In the Mac app, show the overlay. This starts the remote input listener on port `9876`.
4. Run `InkBridgePad`.
5. Enter the Mac IP address in the Pad controls.
6. Tap Connect.
7. Draw on the Pad. Strokes should appear on the Mac overlay.

## Finding The Mac IP

On the Mac:

    ipconfig getifaddr en0

## Verifying The Mac Listener

After showing the overlay:

    lsof -nP -iTCP:9876 -sTCP:LISTEN

## Test Commands

Networking package:

    swift test --package-path Packages/InkBridgeNetworking

Protocol package:

    swift test --package-path Packages/InkBridgeProtocol

Rendering package:

    swift test --package-path Packages/InkBridgeRendering

Mac build:

    xcodebuild build -workspace InkBridge.xcworkspace -scheme InkBridgeMac -destination 'platform=macOS'

Pad build:

    xcodebuild build -workspace InkBridge.xcworkspace -scheme InkBridgePad -destination 'generic/platform=iOS Simulator'

## Notes

The current connection flow is manual. Bonjour/device discovery is not implemented yet.
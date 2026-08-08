//
//  NetworkRemoteInputServiceBrowser.swift
//  InkBridgeNetworking
//
//  Created by Roberto Teixeira on 07/08/2026.
//

import Foundation
import Network

@available(macOS 10.15, iOS 13.0, *)
public final class NetworkRemoteInputServiceBrowser: @unchecked Sendable {
    private let browser: NWBrowser
    private let onServicesChanged: ([RemoteInputDiscoveredService]) -> Void
    private let onStateChanged: (RemoteInputConnectionState) -> Void
    
    public private(set) var services: [RemoteInputDiscoveredService] = []
    public private(set) var state: RemoteInputConnectionState = .disconnected
    
    public init(
        serviceType: String = RemoteInputServiceDefaults.type,
        onServicesChanged: @escaping ([RemoteInputDiscoveredService]) -> Void,
        onStateChanged: @escaping (RemoteInputConnectionState) -> Void
    ) {
        self.browser = NWBrowser(
            for: .bonjour(
                type: serviceType,
                domain: nil
            ),
            using: .tcp
        )
        self.onServicesChanged = onServicesChanged
        self.onStateChanged = onStateChanged
        
    }
    
    public func start() {
        updateState(.connecting)

        browser.stateUpdateHandler = { [weak self] state in
            self?.handle(state)
        }

        browser.browseResultsChangedHandler = { [weak self] results, _ in
            self?.updateServices(from: results)
        }

        browser.start(queue: .main)
    }
    
    public func stop() {
        browser.cancel()
        updateState(.disconnected)
        services = []
        onServicesChanged([])
    }

    private func handle(_ browserState: NWBrowser.State) {
        switch browserState {
        case .setup:
            updateState(.disconnected)
        case .ready:
            updateState(.connected)
        case .failed(let error):
            updateState(.failed(error.localizedDescription))
        case .cancelled:
            updateState(.disconnected)
        case .waiting(let error):
            updateState(.failed(error.localizedDescription))
        @unknown default:
            updateState(.failed("Unknown browser state"))
        }
    }
    
    private func updateServices(from results: Set<NWBrowser.Result>) {
        var servicesByName: [String: RemoteInputDiscoveredService] = [:]

        for result in results {
            guard case .service(let name, _, _, _) = result.endpoint else {
                continue
            }

            if servicesByName[name] == nil {
                servicesByName[name] = RemoteInputDiscoveredService(
                    endpoint: result.endpoint,
                    name: name
                )
            }
        }

        services = servicesByName.values.sorted { first, second in
            first.name < second.name
        }

        onServicesChanged(services)
    }
    
    private func updateState(_ state: RemoteInputConnectionState) {
        self.state = state
        onStateChanged(state)
    }
}

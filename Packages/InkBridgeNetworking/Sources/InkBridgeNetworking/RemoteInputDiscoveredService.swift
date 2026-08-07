//
//  RemoteInputDiscoveredService.swift
//  InkBridgeNetworking
//
//  Created by Roberto Teixeira on 07/08/2026.
//

import Foundation
import Network

@available(macOS 10.15, iOS 13.0, *)
public struct RemoteInputDiscoveredService: Identifiable {
    let endpoint: NWEndpoint

    public let id: String
    public let name: String

    init(endpoint: NWEndpoint, name: String) {
        self.endpoint = endpoint
        self.id = name
        self.name = name
    }
}

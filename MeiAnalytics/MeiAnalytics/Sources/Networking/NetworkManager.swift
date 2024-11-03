//
//  NetworkManager.swift
//  MeiAnalytics
//
//  Created by Mei Yu on 11/3/24.
//

import Network

/// This class monitors network connectivity status.
///
/// It uses the `Network` framework to check if the device is connected to the internet.
/// It observes changes in network availability and updates`isConnected`.
///
class NetworkManager: ObservableObject {
    
    /// The shared singleton instance of `NetworkManager`.
    ///
    /// This shared instance provides a single source of truth for network status
    /// and avoids multiple `NWPathMonitor` instances.
    ///
    /// - Note: This instance is created once and shared across the entire app lifecycle.
    static let shared = NetworkManager()

    /// A boolean indicating whether the device is connected to the internet.
    /// This property is updated reactively whenever network status changes.
    @Published var isConnected: Bool = false
    
    private var monitor: NWPathMonitor
    private let monitorQueue = DispatchQueue.global(qos: .background)
    
    init() {
        monitor = NWPathMonitor()
        startMonitoring()
    }
    
    /// Starts network monitoring and updates `isConnected` based on network status.
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = (path.status == .satisfied)
        }
        monitor.start(queue: monitorQueue)
    }
    
    /// Stops network monitoring.
    func stopMonitoring() {
        monitor.cancel()
    }
}

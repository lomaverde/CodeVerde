//
//  EventCoreService.swift
//  MeiAnalytics
//
//  Created by Mei Yu on 11/1/24.
//

import Foundation

protocol EventCoreServiceContext {
    var localService: EventLocalServicing { get }
    var networkService: EventNetworkService { get }
    var networkManager: NetworkManager { get }
}

protocol EventCoreServicing {
    var context: EventCoreServiceContext { get }
    var isEnabled: Bool { get set }
    func add(event: EventLoggable)
}

/// A core service responsible for managing and uploading Analytics events.
/// It provides a central point for asynchronously adding, storing, and uploading events.
public class EventCoreService: EventCoreServicing {
    
    let context: any EventCoreServiceContext
    
    struct Context: EventCoreServiceContext {
        let localService: any EventLocalServicing
        let networkService: EventNetworkService
        let networkManager: NetworkManager
        
        init(localService: any EventLocalServicing = EventLocalServiceV3(),
             networkManager: NetworkManager = NetworkManager.shared,
             networkService: EventNetworkService = EventNetworkService()
        ) {
            self.localService = localService
            self.networkManager = networkManager
            self.networkService = networkService
        }
    }
        
    /// A struct to keep track of different counts.
    struct EventCounts {
        var total: Int = 0
        var sent: Int = 0
    }
    
    /// counts of events for local debugging
    private var counts = EventCounts()
    
    /// A Boolean value indicating whether `EventCoreService` is enabled.
    ///
    /// - `true`: The service is active and available for use.
    /// - `false`: The service is disabled and will ignore any request.
    public var isEnabled = false {
        didSet {
            if isEnabled {
                timer?.invalidate()
                startUploadTimer()
            } else {
                timer?.invalidate()
            }
        }
    }
    
    /// The timer for triggering periodic uploads.
    private var timer: Timer?
    
    /// The time interval, in seconds, for the upload timer.
    private let timerInterval = 20.0

    init(context: EventCoreServiceContext = Context()) {
        self.context = context
        startUploadTimer()
    }

    deinit {
        timer?.invalidate()
    }
    
    func add(event: EventLoggable)  {
        guard isEnabled else { return }
        counts.total += 1
        context.localService.add(event: event)
    }
}

private extension EventCoreService {
    
    /// Starts a timer to periodically trigger upload tasks.
    func startUploadTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { [weak self] _ in
            self?.uploadNextBatch()
        }
    }

    /// Upload next batch of logs to the server if connected to the internet.  Any logs are failed
    /// to be uploaded will be put back to the localRepo for retry later.
    
    /// Uploads the next batch of events to the server.
    ///
    /// It handles uploading the next available set of events to the server.
    /// This function is typically called periodically, when the previous batch has completed or
    /// when initiating a series of uploads. It manages the upload process, error handling,
    /// and any required retries.
    ///
    func uploadNextBatch() {
        let logger = analyticsLog
        guard context.networkManager.isConnected else {
            debug("Did not start: isConnected = false", logger)
            return
        }
        
        debug("Old counts: total:\(counts.total), sent:\(counts.sent)", logger)
        
        let events = context.localService.dequeueNextBatch
        debug("Processing new batch of event: \(events.count)", logger)
        
        for event in events {
            Task {
                debug("submitting to server: \(event.timestamp)", logger)
                do {
                    try await context.networkService.sendEventLog(event)
                } catch {
                    debug("failed to submit to server: \(event.timestamp)", logger)
                    // Add the failed event back for retry later.
                    context.localService.add(event: event)
                }
            }
        }
        
//        in events {
//            let event = codableEvent.event
//            Task {
//                do {
//                    debug("\(logPrefix) submitting to server: \(event.timestamp)", logger)
//                    try await serverRepo.sendEventLog(event)
//                    counts.sent += 1
//                    debug("\(logPrefix) successfully submitted to server: \(event.timestamp)", logger)
//                } catch {
//                    debug("\(logPrefix) failed to submit to server: \(event.timestamp)", logger)
//                    // Add the failed event back for retry later.
//                    localRepo.add(event: codableEvent)
//                }
//            }
//        }
    }
}

//
//  EventCoreService.swift
//  MeiAnalytics
//
//  Created by Mei Yu on 11/1/24.
//

import Foundation

/// A core service responsible for managing and uploading Analytics events.
/// It provides a central point for asynchronously adding, storing, and uploading events.
public class EventCoreService {
    
    /// A struct to keep track of different counts.
    struct EventCounts {
        var total: Int = 0
        var sent: Int = 0
    }
    
    /// The shared singleton instance of `EventService`.
    public static let shared = EventCoreService()
    
    private let localRepo = EventLocalServiceV2.shared
    private let serverRepo = EventNetworkService()
    private let networkManager = NetworkManager.shared
    
    /// counts of events for logging
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

    private init() {
        startUploadTimer()
    }

    deinit {
        timer?.invalidate()
    }
    
    func add(eventWrapper: EventCodableWrapper) {
        guard isEnabled else { return }
        counts.total += 1
        localRepo.add(event: eventWrapper)
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
        let logPrefix = "EventService.uploadEvents"
        let logger = analyticsLog
        guard networkManager.isConnected else {
            debug("\(logPrefix) did not start: isConnected = false", logger)
            return
        }
        
        debug("\(logPrefix) old counts: total:\(counts.total), sent:\(counts.sent)", logger)
        
        let events = localRepo.dequeueNextBatch
        debug("\(logPrefix) processing new batch of event: \(events.count)", logger)
        
        for codableEvent in events {
            let event = codableEvent.event
            Task {
                do {
                    debug("\(logPrefix) submitting to server: \(event.timestamp)", logger)
                    try await serverRepo.sendEventLog(event)
                    counts.sent += 1
                    debug("\(logPrefix) successfully submitted to server: \(event.timestamp)", logger)
                } catch {
                    debug("\(logPrefix) failed to submit to server: \(event.timestamp)", logger)
                    // Add the failed event back for retry later.
                    localRepo.add(event: codableEvent)
                }
            }
        }
    }
}

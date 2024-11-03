//
//  EventService.swift
//  MeiAnalytics
//
//  Created by Mei Yu on 11/1/24.
//

import Foundation

/// A service responsible for managing and uploading Analytics events.
/// It provides a central point for asynchronously adding, storing, and uploading events.
class EventService {
    
    /// The shared singleton instance of `EventService`.
    public static let shared = EventService()
    
    private let localRepo = LocalLogRepo.shared
    private let serverRepo = EventLogServerRepo()
    private let networkManager = NetworkManager.shared
    
    /// The timer for triggering periodic uploads.
    private var timer: Timer?
    
    /// The time interval, in seconds, for the upload timer.
    private let timerInterval = 30.0

    init() {
        startUploadTimer()
    }

    deinit {
        timer?.invalidate()
    }
    
    /// Adds a new encoded event to the service.
    ///
    /// This function saves the encoded event in the local store for future upload and the
    /// service will manage its persistent and uploading asynchronously.
    ///
    public func add(encodedEvent: EncodedContent) {
        localRepo.add(event: encodedEvent)
    }
}

private extension EventService {
    
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
        
        let events = localRepo.nextBatch
        debug("\(logPrefix) processing event: \(events.count)", logger)
        
        for event in events {
            Task {
                do {
                    debug("\(logPrefix) submitting to server: \(event.debugSummary)", logger)
                    try await serverRepo.sendEventLog(event)
                } catch {
                    debug("\(logPrefix) failed submitting to server: \(event.debugSummary)", logger)
                    // Add the failed event back for retry later.
                    localRepo.add(event: event)
                }
            }
        }
    }
}

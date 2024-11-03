//
//  EventService.swift
//  MeiAnalytics
//
//  Created by Mei Yu on 11/1/24.
//

import Foundation

class EventService {
    public static let shared = EventService()
    
    private let localRepo = LocalLogRepo.shared
    private let serverRepo = EventLogServerRepo()
    
    private var timer: Timer?
    private let timerInterval = 30.0

    init() {
        startUploadTimer()
    }

    deinit {
        timer?.invalidate()
    }
    
    public func add(encodedEvent: EncodedContent) {
        localRepo.add(event: encodedEvent)
    }
}

private extension EventService {
    
    ///
    func startUploadTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { [weak self] _ in
            self?.uploadNextBatch()
        }
    }

    /// Upload next batch of logs to the server if connected to the internet.  Any logs are failed
    /// to be uploaded will be put back to the localRepo for retry later.
    func uploadNextBatch() {
        print("****** uploadEvents called.")
        let events = localRepo.nextBatch
        for event in events {
            Task {
                do {
                    try await serverRepo.sendEventLog(event)
                    print("successfully sent event logged at \(event.debugSummary)")
                } catch {
                    print("failed to sent event logged at \(event.debugSummary)")
                    localRepo.add(event: event)
                }
            }
        }
    }
}

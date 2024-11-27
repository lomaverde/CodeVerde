//
//  EventLocalServiceV3.swift
//  MeiAnalytics
//
//  Created by Mei Yu on 11/26/24.
//
import Foundation
import UIKit

/// A service class responsible for managing encoded events in memory and device storage.
class EventLocalServiceV3: EventLocalServicing {

    func add(event: any EventLoggable) {
        events.append(event)
    }
    
    var dequeueNextBatch: [any EventLoggable] {
        return events.dequeue(count: eventBatchSize)
    }
    
    /// The in-memory list of event data.
    private var events: ThreadSafeArray<EventLoggable> = ThreadSafeArray()
    
    /// The maxium number of events to be returned for process.
    private let eventBatchSize = 20
    
    /// Initializes the service, loads previously saved data, and sets up notification observers.
    init() {
    }
    
    deinit {
    }
}


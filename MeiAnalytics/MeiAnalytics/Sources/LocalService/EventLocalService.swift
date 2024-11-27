//
//  EventLocalService.swift
//  MeiAnalytics
//
//  Created by Mei Yu on 11/26/24.
//

protocol EventLocalServicing {
    
    /// Adds a copy of event to the local service.
    /// - Parameter event: The `event` to add.
    func add(event: EventLoggable)
    
    /// Retrieves and clears the next batch of events.
    var dequeueNextBatch: [EventLoggable] { get }
}


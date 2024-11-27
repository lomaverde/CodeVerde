//
//  Events.swift
//  MeiAnalytics
//
//  Created by Mei Yu on 11/1/24.
//

import Foundation

/// Event will be timestamped and logged when log method is called.
public class ImmediateEvent: EventLoggable {

    
    public let type: String
    public var timestamp: Date
    public var payload: EventPayload
    
    init(type: String, timestamp: Date = .now, payload: EventPayload = EventPayload()) {
        self.type = type
        self.timestamp = timestamp
        self.payload = payload
    }
}

/// Event will be timestamped, duration calculated, and logged when log method is called.
public class DurationEvent: DurationEventLoggable {
    public let type: String
    public var timestamp: Date
    public var payload: EventPayload
    public var startTime: Date?
    public var duration: TimeInterval = -1

    init(type: String, timestamp: Date = .now, payload: EventPayload = EventPayload()) {
        self.type = type
        self.timestamp = timestamp
        self.payload = payload
    }
}

//
//  EventCodableWrapper.swift
//  MeiAnalytics
//
//  Created by Mei Yu on 11/18/24.
//

import Foundation

/// Enum representing potential errors that can occur with EventCodableWrapper.
enum EventCodableWrapperError: Error {
    /// The event type is unsupported or unrecognized.
    case unsupportedEventType
}

/// A wrapper for encoding and decoding multiple event types.
/// Enables seamless serialization and deserialization of different event types in a collection.
enum EventCodableWrapper: Codable {
    case immediateEvent(ImmediateEvent)
    case durationEvent(DurationEvent)
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .immediateEvent(let value):
            try container.encode(value)
        case .durationEvent(let value):
            try container.encode(value)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let value = try? container.decode(ImmediateEvent.self) {
            self = .immediateEvent(value)
        } else if let value = try? container.decode(DurationEvent.self) {
            self = .durationEvent(value)
        } else {
            throw DecodingError.typeMismatch(EventCodableWrapper.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unsupported type."))
        }
    }
    
    init(event: EventLoggable) throws {
        if let immediateEvent = event as? ImmediateEvent {
            self = .immediateEvent(immediateEvent)
        } else if let durationEvent = event as? DurationEvent {
            self = .durationEvent(durationEvent)
        } else {
            throw EventCodableWrapperError.unsupportedEventType
        }
    }
    
    func isEarlier(than other: EventCodableWrapper ) -> Bool {
        return EventCodableWrapper.compareTimestamp(lhs: self, rhs: other)
    }
    
    static func compareTimestamp(lhs: EventCodableWrapper, rhs: EventCodableWrapper) -> Bool {
        switch (lhs, rhs) {
        case (.immediateEvent(let leftEvent), .immediateEvent(let rightEvent)):
            return leftEvent.timestamp < rightEvent.timestamp
        case (.durationEvent(let leftEvent), .durationEvent(let rightEvent)):
            return leftEvent.timestamp < rightEvent.timestamp
        case (.durationEvent(let leftEvent), .immediateEvent(let rightEvent)):
            return leftEvent.timestamp < rightEvent.timestamp
        case (.immediateEvent(let leftEvent), .durationEvent(let rightEvent)):
            return leftEvent.timestamp < rightEvent.timestamp
        }
    }
    
    var event: EventLoggable {
        switch self {
        case .immediateEvent(let event): return event
        case .durationEvent(let event): return event
        }
    }
}

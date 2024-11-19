//
//  EventLoggables.swift
//  MeiAnalytics
//
//  Created by Mei Yu on 11/1/24.
//

import Foundation

/// A protocol that defines the requirements for loggable events for Analytics.
///
/// Conforming types must provide a type, a timestamp, and a payload that captures
/// the event's details. By conforming to `Codable`, `EventLoggable` allows event data to be
/// easily serialized and stored or transmitted over a network.
///
/// This protocol is designed to standardize how events are logged, ensuring consistency across
/// different event types within the system.
///
public protocol EventLoggable: Codable {
    
    /// Type of the logging event
    var type: String { get }
    
    /// Timestamp when logging is requested.
    var timestamp: Date { get set }
    
    /// Payload for logging
    var payload: EventPayload { get set }
    
    /// Timestamps, updates the event, and sends the immutable content to the logging service.
    mutating func log()
    
    /// Return debug information.
    func debugInfo () -> String
    
    /// EncodedData
    func encodedData() throws -> Data
    
    /// Return a deep copy of the event.
    func deepCopy() -> Self
}

public extension EventLoggable {
    /// Return Debug information
    func debugInfo () -> String { "\(timestamp.shortDebugString), \(type), payload: \(payload.values.count)" }
    
    mutating func log(){
        timestamp = .now
        addLog()
    }
    
    func encodedData() throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(self)
    }
    
    func decode(data: Data) throws -> Self {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(Swift.type(of: self), from: data)
    }
}

extension EventLoggable {
    
    var logService: EventCoreService { EventCoreService.shared }
    
    public func deepCopy() -> Self {
        // Encode the object to JSON
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else {
            fatalError("Failed to encode object for deep copy.")
        }
        
        // Decode the JSON back to a new instance
        let decoder = JSONDecoder()
        guard let copy = try? decoder.decode(Self.self, from: data) else {
            fatalError("Failed to decode object for deep copy.")
        }
        
        return copy
    }
    
    func addLog() {
        guard logService.isEnabled else { return }
        
        do {
            // Pass a deep copy of event to the service to avoid it being modifed by the owner of the event
            // after it is being logged.
            let codableEvent = try EventCodableWrapper(event: self.deepCopy())
            logService.add(eventWrapper: codableEvent)
        } catch {
            print(error)
        }
    }
}

/// A protocol that represents loggable events with a specific duration, inheriting from `EventLoggable`.
///
/// `DurationEventLoggable` extends `EventLoggable` by adding properties for tracking
/// the start and end time(timestamp)  of an event, allowing the calculation of an event's duration.
/// This is particularly useful for tracking time-based activities, such as user sessions
/// or specific actions within an app.
///
public protocol DurationEventLoggable: EventLoggable {
    /// The startTime for tracking
    var startTime: Date? { get set }
    
    /// The duration from startTime to logging
    var duration: TimeInterval { get set}
}

public extension DurationEventLoggable {
    /// Start tracking the time.
    mutating func start() {
        startTime = .now
    }
    
    /// Return Debug information
    func debugInfo () -> String { "\(timestamp.shortDebugString), \(type), payload: \(payload.values.count), duration: \(duration)" }
    
    /// Log the event after updating the timestamp and duration.
    mutating func log(){
        timestamp = .now
        if let startTime {
            duration =  timestamp.timeIntervalSince(startTime)
        } else {
            duration = -1
        }
        addLog()
    }
}


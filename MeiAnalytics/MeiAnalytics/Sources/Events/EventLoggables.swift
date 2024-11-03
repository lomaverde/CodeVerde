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
    
    var logService: EventService { EventService.shared }
    
    func addLog() {
        do {
            let encodedData = try self.encodedData()
            let encodedEvent = EncodedContent(timestamp: timestamp , debugSummary: debugInfo(), encodedContent: encodedData)
            // Pass the encoded event to the service to avoid it being modifed by the owner of the event after it is being logged.
            // This is more performant than making a deep copy as we don't need to use the content
            // in the event for other business logic.
            logService.add(encodedEvent: encodedEvent)
        } catch {
            
        }
    }
}

/// A protocol that represents loggable events with a specific duration, inheriting from `EventLoggable`.
///
/// `DurationEventLoggable` extends `EventLoggable` by adding properties for tracking
/// the start and end times of an event, allowing the calculation of an event's duration.
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
            duration = timestamp.timeIntervalSince1970 - startTime.timeIntervalSince1970
        } else {
            duration = -1
        }
        addLog()
    }
}


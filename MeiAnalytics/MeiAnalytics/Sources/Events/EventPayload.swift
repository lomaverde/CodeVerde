//
//  EventPayload.swift
//  MeiAnalytics
//
//  Created by Mei Yu on 11/1/24.
//

import Foundation

/// A class representing the payload data associated with an event.
///
/// `EventPayload` is designed to encapsulate key-value pairs that define the details
/// of an event. It offers methods to add and update values of supported types using string keys.
/// It is designed to be restricted to avoid adding unsupported values.
//
public class EventPayload: Codable, Equatable {
    public static func == (lhs: EventPayload, rhs: EventPayload) -> Bool {
        // Ensure the dictionary have the same keys
        guard lhs.values.keys == rhs.values.keys else {
            return false
        }
        
        /*
        // Check each key-value pair for equality
        for (key, lhsValue) in lhs.values {
            guard let rhsValue = rhs.values[key] else { return false }
            
            // TODO - need to compare int and double without knowing their values.
            if lhsValue != rhsValue {
                return false
            }
        }
        */
        
        return true
    }
    
    var values: [String: AnalyticsLogableValue] = [:]
}

public extension EventPayload {
    
    /// Set or update the value to the given String for the given key
    /// self is return for chaining updates.
    @discardableResult
    func set(_ key: String, _ value: String) -> Self {
        values[key] = .string(value)
        return self
    }
    
    /// Set or update the value to the given Int for the given key
    /// self is return for chaining updates.
    @discardableResult
    func set(_ key: String, _ value: Int) -> Self {
        values[key] = .int(value)
        return self
    }
    
    /// Set or update the value to the given Double for the given key
    /// self is return for chaining updates.
    @discardableResult
    func set(_ key: String, _ value: Double) -> Self {
        values[key] = .double(value)
        return self
    }
    
    /// Set or update the value to the given Bool for the given key
    /// self is return for chaining updates.
    @discardableResult
    func set(_ key: String, _ value: Bool) -> Self {
        values[key] = .bool(value)
        return self
    }
}

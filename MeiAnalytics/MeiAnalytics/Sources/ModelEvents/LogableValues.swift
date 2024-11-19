//
//  AnalyticsLogableValue.swift
//  MeiAnalytics
//
//  Created by Mei Yu on 11/1/24.
//

import Foundation

/// An enumeration representing values that can be logged for Analytics.
///
///  This enum conforms to `Codable` for serialization and `Equatable` to enable comparisons,
///   making it suitable for networking and local storage.
///
enum AnalyticsLogableValue: Codable, Equatable {
    case bool(Bool)
    case double(Double)
    case int(Int)
    case string(String)
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .bool(let value):
            try container.encode(value)
        case .double(let value):
            try container.encode(value)
        case .int(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode(Double.self) {
            self = .double(value)
        } else if let value = try? container.decode(Int.self) {
            self = .int(value)
        } else if let value = try? container.decode(String.self) {
                self = .string(value)
        } else {
            throw DecodingError.typeMismatch(AnalyticsLogableValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unsupported type for analytics"))
        }
    }
}

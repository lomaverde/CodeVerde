//
//  Logs.swift
//  MeiAnalytics
//
//  Created by Mei Yu on 11/3/24.
//

import Foundation

import os

/// Custom logging categories for the app's logging system.

let networkLog = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "Network")
let analyticsLog = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "Analytics")

var nowDebugString: String { Date.now.shortDebugString}


/// Logs a debug message to the specified logging category.
///
/// - Parameters:
///   - message: The debug message to log.
///   - log: The `OSLog` instance specifying the log category, with `OSLog.default` as the default.
func debug(_ message: String, _ log: OSLog = OSLog.default) {
    os_log("%{public}@%{public}@", log: log, type: .debug, nowDebugString, message)
}

/// Logs an info message to the specified logging category.
///
/// - Parameters:
///   - message: The info message to log.
///   - log: The `OSLog` instance specifying the log category, with `OSLog.default` as the default.
func logInfo(_ message: String, _ log: OSLog = OSLog.default) {
    os_log("%{public}@%{public}@", log: log, type: .info, nowDebugString, message)
}

/// Logs an error message to the specified logging category.
///
/// - Parameters:
///   - message: The error message to log.
///   - log: The `OSLog` instance specifying the log category, with `OSLog.default` as the default.
func logError(_ message: String, _ log: OSLog = OSLog.default) {
    os_log("%{public}@%{public}@", log: log, type: .error, nowDebugString, message)
}

extension Date {
    var shortDebugString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
}

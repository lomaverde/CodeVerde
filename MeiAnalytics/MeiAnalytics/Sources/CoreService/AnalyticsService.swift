//
//  AnalyticsFacade.swift
//  MeiAnalytics
//
//  Created by Mei Yu on 11/19/24.
//

import Foundation

public class AnalyticsService {
    
    /// Returns the shared singleton instance of `AnalyticsService`.
    /// This shared service can be customized by updating the `FrameworkContext`.
    /// The singleton instance is used to log all `EventLoggable` events.
    public static let shared = AnalyticsService()
    
    /// Dependency: Context for the Framework.
    var context = FrameworkContext()
    
    /// Private initializer to prevent external instantiation
    private init() {
    }
    
    /// Enable the analytics service
    public func enableService() {
        context.isEnabled = true
    }
    
    /// Disable the analytics service
    public func disableService() {
        context.isEnabled = false
    }
}

/// APIs for unit testing.
extension AnalyticsService {
    
    /// Returns an instance of `AnalyticsService` for configured unit testing.
    /// - Parameter context: An optional `FrameworkContext` to customize the instance for testing. If no context is provided, a default instance is returned.
    static func instanceForTesting(context: FrameworkContext? = nil) -> AnalyticsService {
        let instance = AnalyticsService()
        if let context {
            instance.context = context
        }
        return instance
    }
    
}


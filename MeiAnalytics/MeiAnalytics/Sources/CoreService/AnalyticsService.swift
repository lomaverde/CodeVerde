//
//  AnalyticsFacade.swift
//  MeiAnalytics
//
//  Created by Mei Yu on 11/19/24.
//

import Foundation

public class AnalyticsService {
    
    /// Return a shared singleton instance.
    /// The shared service can be customized by modifying the FrameworkContext.
    /// This instance will be used to log each EventLoggable.
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


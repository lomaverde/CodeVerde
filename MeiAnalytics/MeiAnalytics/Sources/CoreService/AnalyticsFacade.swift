//
//  AnalyticsFacade.swift
//  MeiAnalytics
//
//  Created by Mei Yu on 11/19/24.
//

import Foundation

public class AnalyticsFacade {
    
    // Singleton instance for centralized access
    public static let shared = AnalyticsFacade()
    
    // Dependency: AppContext
    let context = FrameworkContext()
    
    /// Private initializer to prevent external instantiation
    private init() {}
    
    /// Enable the analytics service
    public func enableService() {
        context.isEnabled = true
    }
    
    /// Disable the analytics service
    public func disableService() {
        context.isEnabled = false
    }
}


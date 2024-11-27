//
//  MeiLogSampleAppApp.swift
//  MeiLogSampleApp
//
//  Created by Mei Yu on 11/2/24.
//

import SwiftUI
import MeiAnalytics

@main
struct MeiLogSampleAppApp: App {
    
    private var eventService = AnalyticsService.shared
    
    init() {
        eventService.enableService()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

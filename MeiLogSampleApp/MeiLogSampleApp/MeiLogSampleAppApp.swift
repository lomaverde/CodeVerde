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
    
    private var eventService = EventCoreService.shared
    
    init() {
        eventService.isEnabled = true
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

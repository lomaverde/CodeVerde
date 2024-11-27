//
//  FrameworkContext.swift
//  MeiAnalytics
//
//  Created by Mei Yu on 11/19/24.
//

class FrameworkContext {
    
    var eventCoreService: EventCoreServicing
    var isEnabled: Bool = false {
        didSet {
            eventCoreService.isEnabled = isEnabled
        }
    }

    init(eventCoreService: EventCoreServicing = EventCoreService()) {
        self.eventCoreService = eventCoreService
    }
}

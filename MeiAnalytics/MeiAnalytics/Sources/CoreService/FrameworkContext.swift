//
//  FrameworkContext.swift
//  MeiAnalytics
//
//  Created by Mei Yu on 11/19/24.
//

class FrameworkContext {
    
    let eventCoreService: EventCoreServiceProtocol
    
    var isEnabled: Bool = false {
        didSet {
            eventCoreService.isEnabled = isEnabled
        }
    }

    init(eventCoreService: EventCoreServiceProtocol = EventCoreService()) {
        self.eventCoreService = eventCoreService
    }
}

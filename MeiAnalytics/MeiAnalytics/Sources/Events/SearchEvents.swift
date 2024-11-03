//
//  EventTypes.swift
//  MeiAnalytics
//
//  Created by Mei Yu on 11/1/24.
//

import Foundation

public enum SearchEvent {
    
    public enum immediate: String {
        case searchInputFieldKeyPressed
        
        public var event: ImmediateEvent { ImmediateEvent(type: self.rawValue) }
    }
    
    public enum duration: String {
        case searchInputFieldFocused
        case searchFromSubmittedToResultsDisplayed
        case searchViewInteraction
        
        public var event: DurationEvent { DurationEvent(type: self.rawValue) }
    }
}

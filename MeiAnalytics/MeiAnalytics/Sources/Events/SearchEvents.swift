//
//  SearchEvents.swift
//  MeiAnalytics
//
//  Created by Mei Yu on 11/1/24.
//

import Foundation

/// An enumeration representing different search-related events for analytics tracking.
public enum SearchEvent {
    
    /// An enumeration of immediate events triggered by single, momentary actions.
    public enum immediate: String {
        
        /// An event where a key is pressed in the search input field.
        case searchInputFieldKeyPressed
        
        /// Returns an `ImmediateEvent` instance with the event type corresponding to the case.
        public var event: ImmediateEvent { ImmediateEvent(type: self.rawValue) }
    }
    
    /// An enumeration of duration-based events triggered by extended user interactions.
    public enum duration: String {
        
        /// Represents the time during which the search input field is focused by the user.
        case searchInputFieldFocused
        
        /// Represents the duration from when a search is submitted to when results are displayed.
        case searchFromSubmittedToResultsDisplayed
        
        /// Represents the total time of interaction with the search view.
        case searchViewInteraction
        
        /// Returns a `DurationEvent` instance with the event type corresponding to the case.
        public var event: DurationEvent { DurationEvent(type: self.rawValue) }
    }
}

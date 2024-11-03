//
//  EventLogServerRepo.swift
//  MeiAnalytics
//
//  Created by Mei Yu on 11/1/24.
//

import Foundation

enum ServerLogRepoError: Error {
    case invalidURL
    case serverError
}

// before app went into background
// persist all un-processed event via LocalLogRepo
// after app get into foreground, load all events from LocalLogRepo
class EventLogServerRepo {
    
    private let url = URL(string: "https://example.com/api/events")!
    
    func sendEventLog(_ event: EncodedContent) async throws {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode EventLog to JSON
        request.httpBody = event.encodedContent
        
        // Send the request asynchronously
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // Check the response status
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw ServerLogRepoError.serverError
        }
    }
}

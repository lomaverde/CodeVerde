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
class EventNetworkService {
    
    private let urlProvider = URLProvider()
    
    func sendEventLog(_ event: EncodedContent) async throws {
        let url = urlProvider.testingURL
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add the encoded event to the POST body
        request.httpBody = event.encodedContent
        
        // Send the request asynchronously
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // Check the response status
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode != 200 {
                throw ServerLogRepoError.serverError
            }
        }
    }
    
    /// A utility struct for providing URLs for testing purposes.
    private struct URLProvider {
        let invalidPostURL = URL(string: "https://example.com/api/events")!
        let validPostURL = URL(string: "https://httpbin.org/post")!
        let urls: [URL]
        
        init() {
            urls = [validPostURL, validPostURL, validPostURL, invalidPostURL]
        }
        
        /// Randomly returns either a valid or invalid URL.
        var testingURL: URL { urls.randomElement() ?? validPostURL }
    }
}


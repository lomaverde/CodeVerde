//
//  EventLogServerRepo.swift
//  MeiAnalytics
//
//  Created by Mei Yu on 11/1/24.
//

import Foundation

/// A service class responsible for sending analytics events to a server.
class EventNetworkService {
    
    /// An enum for errors encountered during the service operation.
    ///
    /// - `invalidURL`: Indicates an invalid URL was used.
    /// - `invalidData`: Indicates that the data sent or received is not valid.
    /// - `serverError`: Represents an error returned from the server when the response status code is not 200.
    enum ServiceError: Error {
        case invalidURL
        case invalidData
        case serverError
    }
    
    private let urlProvider = URLProvider()
    
    /// Sends an encoded event log to the server asynchronously.
    ///
    /// This method constructs an HTTP POST request, attaches the encoded event data, and sends it to
    /// the server. If the server returns a status code other than `200 OK`, the method throws an error.
    ///
    /// - Parameter event: The `EncodedContent` object containing the event data to send.
    /// - Throws: `ServiceError.serverError` if the server response indicates a failure.
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
                throw ServiceError.serverError
            }
        }
    }
    
    func sendEventLog(_ event: EventLoggable) async throws {
        let url = urlProvider.testingURL
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add the encoded event to the POST body
        request.httpBody = try event.encodedData()
        
        // Send the request asynchronously
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // Check the response status
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode != 200 {
                throw ServiceError.serverError
            }
        }
    }
}

/// A utility struct for providing URLs for testing purposes.
struct URLProvider {
    let invalidPostURL = URL(string: "https://example.com/api/events")!
    let validPostURL = URL(string: "https://httpbin.org/post")!
    let urls: [URL]
    
    init() {
        urls = [validPostURL, validPostURL, validPostURL, invalidPostURL]
    }
    
    /// Randomly returns either a valid or invalid URL.
    var testingURL: URL { urls.randomElement() ?? validPostURL }
}

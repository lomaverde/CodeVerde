//
//  LocalLogRepo.swift
//  MeiAnalytics
//
//  Created by Mei Yu on 11/1/24.
//

import Foundation
import UIKit

// before app went into background
// persist all un-processed event via LocalLogRepo
// after app get into foreground, load all events from LocalLogRepo

class LocalLogRepo {
    
    init() {
        loadData()
        addObservers()
    }
    
    private func addObservers() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(persistData), name: UIApplication.didEnterBackgroundNotification, object: nil)
        nc.addObserver(self, selector: #selector(persistData), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    private func removeObservers() {
        // Remove observer to prevent memory leaks
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        nc.removeObserver(self, name: UIApplication.willTerminateNotification, object: nil)
    }
    
    deinit {
        removeObservers()
    }
    
    @objc private func persistData() {
        // Always persit a copy of the events to avoid data lost during app crash
        do {
            try save()
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    static let shared = LocalLogRepo()
    private let dbKey = "savedEvents"
    
    func save() throws {
            let encoder = JSONEncoder()
            let encodedData = try? encoder.encode(events)
            UserDefaults.standard.set(encodedData, forKey: dbKey)
    }

    func loadData() {
        if let savedData = UserDefaults.standard.data(forKey: dbKey) {
            do {
                let decoder = JSONDecoder()
                let saveEvents = try decoder.decode([EncodedContent].self, from: savedData)
                events = saveEvents
                events.sort { $0.timestamp < $1.timestamp }
            } catch {
                print("Error reloading data: \(error)")
            }
        }
    }
    
    private var events: [EncodedContent] = []
    private let batchThreshold = 5

    func add(event: EncodedContent) {
        events.append(event)
    }
    
    var nextBatch: [EncodedContent] {
        let batch = events
        events.removeAll()
        return batch
    }
}

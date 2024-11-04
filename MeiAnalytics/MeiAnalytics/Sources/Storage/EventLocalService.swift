//
//  EventLocalService.swift
//  MeiAnalytics
//
//  Created by Mei Yu on 11/1/24.
//

import Foundation
import UIKit

/// A service class responsible for managing encoded events in memory and device storage.
class EventLocalService {
    
    /// The shared singleton instance of `EventLocalService`.
    static let shared = EventLocalService()
    
    /// The key used for saving and retrieving event data in `UserDefaults`.
    private let dbKey = "savedEvents"
    
    /// The in-memory list of event data.
    private var events: ThreadSafeArray<EncodedContent> = ThreadSafeArray()
    
    /// The maxium number of events to be returned for process.
    private let eventBatchSize = 20
    
    /// Initializes the service, loads previously saved data, and sets up notification observers.
    private init() {
        loadData()
        addObservers()
    }
    
    deinit {
        removeObservers()
    }
    
    /// Adds a new event to the in-memory cache.
    func add(event: EncodedContent) {
        events.append(event)
    }
    
    /// Retrieves and clears the next batch of events.
    var dequeueNextBatch: [EncodedContent] {
        return events.dequeue(count: eventBatchSize)
    }
}

private extension EventLocalService {
    
    /// Adds observers for app lifecycle notifications.
    func addObservers() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(persistData), name: UIApplication.didEnterBackgroundNotification, object: nil)
        nc.addObserver(self, selector: #selector(persistData), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    /// Removes observers for app lifecycle notifications.
    /// This method is called in `deinit` to prevent memory leaks.
    private func removeObservers() {
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        nc.removeObserver(self, name: UIApplication.willTerminateNotification, object: nil)
    }

    /// Loads saved event data from `UserDefaults` into memory.
    ///
    /// If data exists under `dbKey`, it is decoded and loaded into `events`. The data
    /// is sorted by timestamp, ensuring chronological order.
    private func loadData() {
        if let savedData = UserDefaults.standard.data(forKey: dbKey) {
            do {
                let decoder = JSONDecoder()
                var savedEvents = try decoder.decode([EncodedContent].self, from: savedData)
                savedEvents.sort { $0.timestamp < $1.timestamp }
                logInfo("LocalLogRepo.loadData: successfully loaded events: \(savedEvents.count)")
                events = ThreadSafeArray(array: savedEvents)
                UserDefaults.standard.set(nil, forKey: dbKey)
            } catch {
                logError("LocalLogRepo.loadData: failed. \(error)")
            }
        }
    }

    /// Persists event data to `UserDefaults` when the app enters the background or is about to terminate.
    ///
    /// This method is triggered by lifecycle notifications and ensures that any unsaved events
    /// are stored to prevent data loss in case of an unexpected app termination.
    @objc private func persistData() {
        do {
            let encoder = JSONEncoder()
            let all_encodedContents = events.getAll()
            let encodedData = try encoder.encode(all_encodedContents)
            UserDefaults.standard.set(encodedData, forKey: dbKey)
            logInfo("LocalLogRepo.persistData: successfully saved events: \(all_encodedContents.count)")
        } catch {
            logError("LocalLogRepo.persistData: failed. \(error)")
        }
    }
}

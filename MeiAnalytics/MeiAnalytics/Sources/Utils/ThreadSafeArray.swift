//
//  ThreadSafeArray.swift
//  MeiAnalytics
//
//  Created by Mei Yu on 11/3/24.
//

import Foundation

/*
 ThreadSafeArray is an implementation using the Reader-Writer Lock design pattern.
 
 In ThreadSafeArray, we use a concurrent DispatchQueue:

 Read operations are handled using queue.sync, allowing multiple reads to occur concurrently without blocking each other.
 
 Write operations use queue.async(flags: .barrier), which creates a "barrier" around the write operation. This barrier ensures that:
    * All previously queued read operations complete before the write starts.
    * No other read or write operations are allowed while the barrier is active.
    * After the barrier (write) operation completes, reads and other writes can continue.
 */

/// A thread-safe array implementation for concurrent access and modification.
///
/// `ThreadSafeArray` provides a way to safely perform read and write operations on an array
/// in a multi-threaded environment. It uses a concurrent `DispatchQueue` to allow multiple
/// reads simultaneously while ensuring exclusive access for write operations via `.barrier`.
///
class ThreadSafeArray<Element> {
    private var array: [Element]
    private let queue = DispatchQueue(label: "com.loma.ThreadSafeArray", attributes: .concurrent)
    
    init(array: [Element] = []) {
        self.array = array
    }
    
    /// Adds a element in a thread-safe manner.
    func append(_ element: Element) {
        queue.async(flags: .barrier) {
            self.array.append(element)
        }
    }
    
    /// Sorts the array using a custom comparator in a thread-safe manner.
    func sort(by comparator: @escaping (Element, Element) -> Bool) {
        queue.async(flags: .barrier) { [weak self] in
            self?.array.sort(by: comparator)
        }
    }
    
    /// Adds an array of element to the array in a thread-safe manner.
    func append(_ elements: [Element]) {
        queue.async(flags: .barrier) {
            self.array.append(contentsOf: elements)
        }
    }

    /// Returns the element at the specified index, if it exists, in a thread-safe manner.
    func get(at index: Int) -> Element? {
        var element: Element?
        queue.sync {
            if index >= 0 && index < self.array.count {
                element = self.array[index]
            }
        }
        return element
    }

    /// Removes the element at the specified index in a thread-safe manner.
    @discardableResult
    func remove(at index: Int) -> Element? {
        var removedElement: Element?
        queue.async(flags: .barrier) {
            if index >= 0 && index < self.array.count {
                removedElement = self.array.remove(at: index)
            }
        }
        return removedElement
    }
    
    /// Dequeues a specified number of elements from the beginning of the array.
    ///
    /// - Parameter count: The number of elements to dequeue.
    /// - Returns: An array of the dequeued elements. If `count` is greater than the available elements,
    ///            it will return only the available elements and clear the array.
    func dequeue(count: Int) -> [Element] {
        var dequeuedElements: [Element] = []
        
        queue.async(flags: .barrier) {
            let adjustedCount = min(count, self.array.count)
            dequeuedElements = Array(self.array.prefix(adjustedCount))
            self.array.removeFirst(adjustedCount)
        }
        
        // Wait until the barrier block finishes and dequeued elements are available
        queue.sync { }
        
        return dequeuedElements
    }
    
    /// Pops a specified number of elements from the end of the array in a thread-safe manner.
    ///
    /// - Parameter count: The number of elements to pop from the end.
    /// - Returns: An array of the popped elements in the order they were removed.
    ///            If `count` is greater than the available elements, it will return only
    ///            the available elements and clear the array.
    func pop(count: Int) -> [Element] {
        var poppedElements: [Element] = []
        
        queue.async(flags: .barrier) {
            let adjustedCount = min(count, self.array.count)
            poppedElements = Array(self.array.suffix(adjustedCount))
            self.array.removeLast(adjustedCount)
        }
        
        // Wait until the barrier block finishes and popped elements are available
        queue.sync { }
        
        return poppedElements
    }

    /// Returns all elements in the array in a thread-safe manner.
    func getAll() -> [Element] {
        var elements: [Element] = []
        queue.sync {
            elements = self.array
        }
        return elements
    }

    /// Returns the count of elements in a thread-safe manner.
    var count: Int {
        var count = 0
        queue.sync {
            count = self.array.count
        }
        return count
    }

    /// Checks if the array is empty in a thread-safe manner.
    var isEmpty: Bool {
        var isEmpty = true
        queue.sync {
            isEmpty = self.array.isEmpty
        }
        return isEmpty
    }
}

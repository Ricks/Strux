//
//  Heap.swift
//  Strux
//
//  Created by Richard Clark on 4/20/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation

/// Min (default) or max heap. A heap is a tree-based data structure that can be used to efficiently
/// implement a priority queue. It gives *O(1)* read (peek) access to the min or max value, and can be
/// updated via a pop or push in *O(log(n))* time. Removing an arbitrary element takes *O(n)* time.
/// ```
/// var pq = Heap<Int>(isMin: false, startingValues: [5, -1, 3, 42, 68, 99, 72])     // Max heap
/// pq.isEmpty                 // false
/// pq.count                   // 7
/// let max = pq.pop()         // max = 99, removes 99 from the heap
/// let currentMax = pq.peek() // currentMax = 72, leaves heap the same
/// pq.push(100)               // Adds 100 to the heap
/// pq.peek()                  // 100
/// pq.contains(3)             // true
/// pq.push(3)                 // Adds another 3
/// pq.remove(3)               // Removes one of the 3's from the heap
/// pq.push(-1)                // Adds another -1
/// pq.removeAll(-1)           // Removes both -1's
/// pq.clear()                 // Removes all values
/// pq.isEmpty                 // true
/// ```
public struct Heap<T: Comparable>: Collection {
    // State
    private var array = [T]()
    private var isMin = true

    public var startIndex: Int { return 0 }
    public var endIndex: Int { return array.count }

    /******************* Private methods *******************/

    // Left child index, or nil if none
    private func leftChild(_ index: Int) -> Int? {
        let i = 2 * index + 1
        return i < count ? i : nil
    }
    // Right child index, or nil if none
    private func rightChild(_ index: Int) -> Int? {
        let i = 2 * index + 2
        return i < count ? i : nil
    }
    // Parent index, or nil if none
    private func parent(_ index: Int) -> Int? {
        return index > 0 ? (index - 1) / 2 : nil
    }
    // Return whether the two nodes are ordered correctly according to whether it's a min or max heap
    private func ordered(_ index1: Int, _ index2: Int) -> Bool {
        return isMin ? (array[index1] <= array[index2]) : (array[index1] >= array[index2])
    }
    // Bubble up used when adding a new element (push)
    private mutating func bubbleUp(_ index: Int) {
        var i = index
        while let pi = parent(i) {
            if ordered(pi, i) { break }
            array.swapAt(pi, i)
            i = pi
        }
    }
    // Bubble down used when removing the root (pop)
    private mutating func bubbleDown(_ index: Int) {
        var i = index
        while let lci = leftChild(i) {
            // ci is the first child in the ordering (smallest if min heap, largest if max)
            var ci = lci
            if let rci = rightChild(i), ordered(rci, lci) {
                ci = rci
            }
            if ordered(i, ci) { break }
            array.swapAt(ci, i)
            i = ci
        }
    }

    /************************** Public interface *************************/

    /// Initializer for the heap
    /// - Parameters:
    ///   - isMin: true (default) for min heap, false for max
    ///   - startingValues: initial values for the heap, in no particular order
    public init(isMin: Bool = true, startingValues: [T] = []) {
        self.isMin = isMin
        for value in startingValues {
            push(value)
        }
    }

    /// Push an item onto the heap. Complexity is *O(log(n)*).
    /// - Parameter item: item to add to the heap
    public mutating func push(_ item: T) {
        array.append(item)
        bubbleUp(count - 1)
    }

    /// Remove and return the min or max value from the heap. Complexity is *O(log(n))*.
    /// - Returns: optional item (nil if the heap is empty)
    @discardableResult
    public mutating func pop() -> T? {
        let out = array.first
        if !isEmpty {
            array.swapAt(0, count - 1)
            array.removeLast()
            bubbleDown(0)
        }
        return out
    }

    /// Return the min or max value of the heap. Complexity is *O(1)*.
    public func peek() -> T? {
        return array.first
    }

    /// Remove the first occurrence of the given item from the heap. Complexity is *O(n)*.
    /// - Parameter item: item to remove
    public mutating func remove(_ item: T) {
        guard let index = array.firstIndex(of: item) else {
            return
        }
        array.swapAt(index, count - 1)
        array.removeLast()
        if index < count {
            bubbleUp(index)
            bubbleDown(index)
        }
    }

    /// Remove all occurrences of the given item from the heap. Complexity is *O(n)*.
    /// - Parameter item: item to remove
    public mutating func removeAll(_ item: T) {
        var prevCount = 0
        repeat {
            prevCount = count
            remove(item)
        } while count != prevCount
    }

    /// Remove all items from the heap.
    public mutating func clear() {
        array.removeAll()
    }

    public subscript(pos: Int) -> T {
        return array[pos]
    }

    public func index(after i: Int) -> Int {
        precondition((startIndex..<endIndex).contains(i), "Index out of bounds")
        return i + 1
    }

}

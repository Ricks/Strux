//
//  Queue.swift
//  DataStructures
//
//  Created by Richard Clark on 4/20/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation

/// Standard queue (FIFO) - items are added at one end of the queue, and removed from the other.
/// add() and remove() are *O(1)* (amortized for remove()). Queue conforms to the Collection and
/// ExpressibleByArrayLiteral protocols.
///
/// ```
/// var q = Queue<Int>()
/// q.isEmpty             // true
/// q.add(3)
/// q.add(7)
/// q.peek()              // 3
/// q.count               // 2
/// q[0]                  // 3
/// q[1]                  // 7
/// let val = q.remove()  // val = 3
/// q.peek()              // 7
/// q.contains(7)         // true
/// ```
public struct Queue<T>: Collection, ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = T

    //State
    private var left: [T] = []
    private var right: [T] = []

    public var startIndex: Int { return 0 }
    public var endIndex: Int { return left.count + right.count }

    private init(left: [T], right: [T]) {
        self.left = left
        self.right = right
    }

    /// Constructor using array literal.
    public init(arrayLiteral elements: T...) {
        self.init(left: elements.reversed(), right: [])
    }

    /// Adds (enqueues) an item. Complexity is *O(1)*.
    /// - Parameter item: item to be added
    public mutating func add(_ item: T) {
        right.append(item)
    }

    /// Removes (dequeues) an item from the opposite end of the queue from which items are added.
    /// Complexity is *O(1)* (amortized).
    /// - Returns: optional item (nil if the queue is empty)
    @discardableResult
    public mutating func remove() -> T? {
        if left.isEmpty {
            left = right.reversed()
            right.removeAll()
        }
        return left.popLast()
    }

    /// Return the next item to be removed (dequeued) without actually removing it.
    /// Complexity is *O(1)*.
    /// - Returns: optional item (nil if the queue is empty)
    public func peek() -> T? {
        if !left.isEmpty {
            return left.last
        } else {
            return right.first
        }
    }

    public subscript(pos: Int) -> T {
        precondition((startIndex..<endIndex).contains(pos), "Index out of bounds")
        if pos < left.endIndex {
            return left[left.endIndex - pos - 1]
        } else {
            return right[pos - left.endIndex]
        }
    }

    public func index(after i: Int) -> Int {
        precondition((startIndex..<endIndex).contains(i), "Index out of bounds")
        return i + 1
    }
}

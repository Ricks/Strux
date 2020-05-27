//
//  BSTreeModify.swift
//  Strux
//
//  Created by Richard Clark on 5/26/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation

extension BSTree {

    private func processNodeInsertion(_ newNode: BSNode<T>, _ val: T) {
        countStorage += 1
        if firstNode == nil || ordered(val, firstNode!.value) { firstNode = newNode }
        if lastNode == nil || ordered(lastNode!.value, val) { lastNode = newNode }
    }

    private func processNodeRemoval(_ val: T) {
        countStorage -= 1
        if firstNode != nil && firstNode!.value == val { firstNode = root?.firstNode }
        if lastNode != nil && lastNode!.value == val { lastNode = root?.lastNode }
    }

    func performInsertion(_ val: T, _ n: Int) {
        guard n >= 1 else {
            return
        }
        var insertionNode: BSNode<T>?
        var newNode: Bool
        if root == nil {
            insertionNode = BSNode(val, n, ordered: ordered, parent: god, direction: .left)
            root = insertionNode
            medianIndex.setInitialNode(root!)
            newNode = true
        } else {
            let result = root!.insert(val, n)
            insertionNode = result.node
            newNode = result.new
        }
        if newNode && insertionNode != nil {
            processNodeInsertion(insertionNode!, val)
        }
        totalCountStorage += n
        medianIndex.updateAfterChange(of: val, n: n, ordered: ordered)
    }

    @discardableResult
    func performRemoval(_ val: T, _ n: Int) -> Int {
        var numToRemove = 0
        if let thisRoot = root, let removalNode = thisRoot.find(val) {
            numToRemove = Swift.min(n, Int(removalNode.valueCount))
            let removingNode = (numToRemove == removalNode.valueCount)
            if removingNode { medianIndex.aboutToRemoveNode(removalNode) }
            removalNode.remove(val, n)
            if removingNode { processNodeRemoval(val) }
            totalCountStorage -= numToRemove
            medianIndex.updateAfterChange(of: val, n: -numToRemove, ordered: ordered)
        }
        return numToRemove
    }

    func performClear() {
        root = nil
        firstNode = nil
        lastNode = nil
        medianIndex.setToNil()
        countStorage = 0
        totalCountStorage = 0
    }

    // MARK: Modifying the Tree

    /// Insert the given number of the given value into the tree. If the value is already in the tree,
    /// the count is incremented by the given number.
    /// Time complexity: *O(logN)*
    /// - Parameters:
    ///   - val: The value to insert n of
    ///   - n: The number of val to insert
    public func insert(_ val: T, _ n: Int) {
        performInsertion(val, n)
    }

    /// Insert the given value into the tree. If the value is already in the tree, the count is incremented
    /// by one. Time complexity: *O(logN)*
    /// - Parameters:
    ///   - val: The value to insert one of
    public func insert(_ val: T) {
        performInsertion(val, 1)
    }

    /// Insert values from an array. Time complexity: *O(log(Nm))* , where m is the number of values being
    /// inserted.
    /// - Parameters:
    ///   - vals: The values to insert
    public func insert(_ vals: [T]) {
        for val in vals { insert(val) }
    }

    /// Insert multple values separated by commas. Time complexity: *O(log(Nm))* , where m is the number of
    /// values being inserted.
    /// - Parameters:
    ///   - vals: The values to insert
    public func insertMultiple(_ vals: T...) {
        insert(vals)
    }

    /// Remove the given number of the given value from the tree. If the given number is >= the number
    /// of the value in the tree, the value is removed completed.
    /// Time complexity: *O(logN)*
    /// - Parameters:
    ///   - val: The value to remove n of
    ///   - n: The number of val to remove
    public func remove(_ val: T, _ n: Int) {
        performRemoval(val, n)
    }

    /// Remove one of the given value from the tree. If the number of the value already in the tree is
    /// more than one, the number is decremented by one, otherwise the value is removed from the tree.
    /// Time complexity: *O(logN)*
    /// - Parameters:
    ///   - val: The value to remove one of
    public func remove(_ val: T) {
        performRemoval(val, 1)
    }

    /// Remove all occurrences of the given value from the tree.
    /// Time complexity: *O(logN)*
    /// - Parameters:
    ///   - val: The value to remove all occurrences of
    public func removeAll(_ val: T) {
        performRemoval(val, Int.max)
    }

    /// Remove all values from the tree. Time complexity: *O(1)*
    public func clear() {
        performClear()
    }
}

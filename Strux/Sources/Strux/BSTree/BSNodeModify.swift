//
//  BSNodeModify.swift
//  Strux
//
//  Created by Richard Clark on 4/25/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation

extension BSNode {

    /// Insert the given value/count as this node's left child, updating the "next" pointers and
    /// rebalancing as needed.
    /// - Parameters:
    ///   - val: The value for the new node.
    ///   - n: The value count.
    /// - Returns: The new node
    @discardableResult
    private func insertLeftChildNode(_ val: T, _ n: Int) -> BSNode<T> {
        let pred = inOrderPredecessor
        let newNode = BSNode(val, n, ordered: ordered, parent: self, direction: .left)
        left = newNode
        pred?.next = left
        left!.next = self
        rebalanceIfNecessary()
        return newNode
    }

    /// Insert the given value/count as this node's right child, updating the "next" pointers and
    /// rebalancing as needed.
    /// - Parameters:
    ///   - val: The value for the new node.
    ///   - n: The value count.
    /// - Returns: The new node
    @discardableResult
    private func insertRightChildNode(_ val: T, _ n: Int) -> BSNode<T> {
        let newNode = BSNode(val, n, ordered: ordered, parent: self, direction: .right)
        right = newNode
        right!.next = next
        next = right
        rebalanceIfNecessary()
        return newNode
    }

    /// Increase by one the count of the given value, in the subtree having this node as root. If there is
    /// already a node for this value, increase the count by 1, otherwise insert a new node and initialize
    /// the count to 1. Return the node for the value.
    /// Complexity is *O(log(n))*.
    /// - Parameters:
    ///   - val: The value to insert or increment the count of
    /// - Returns: The existing or newly-inserted node, and a flag indicating whether the node is newly-created
    @discardableResult
    func insert(_ val: T, _ n: Int) -> (node: BSNode<T>, new: Bool) {
        var result: (node: BSNode<T>, new: Bool)
        if ordered(val, value) {
            if let thisLeft = left {
                result = thisLeft.insert(val, n)
            } else {
                result = (insertLeftChildNode(val, n), true)
             }
        } else if ordered(value, val) {
            if let thisRight = right {
                result = thisRight.insert(val, n)
            } else {
                result = (insertRightChildNode(val, n), true)
            }
        } else {
            valueCount += Int32(n)
            result = (self, false)
        }
        return result
    }

    /// Remove this node
    func removeNode() {
        let predecessor = inOrderPredecessor
        var replaced = false
        if let thisLeft = left {
            if let thisRight = right {
                // Two children. Replace value with that of the in-order predecessor or successor.
                let toSwapWith = (thisLeft.height > thisRight.height) ? thisLeft.lastNode : thisRight.firstNode
                swap(with: toSwapWith)
                value = toSwapWith.value
                removeNode()
            } else {
                // Only left child
                replace(with: thisLeft)
                replaced = true
            }
        } else {
            if let thisRight = right {
                // Only right child
                replace(with: thisRight)
                replaced = true
            } else {
                // No children
                replace(with: nil)
                replaced = true
            }
        }
        if replaced {
            predecessor?.next = next
            if let bsParent = parent as? BSNode {
                bsParent.rebalanceIfNecessary()
            }
        }
    }

    @discardableResult
    func remove(_ val: T, _ n: Int) -> Int {
        guard let removalNode = find(val) else {
            return 0
        }
        let numToRemove = Swift.min(n, Int(removalNode.valueCount))
        if numToRemove == removalNode.valueCount {
            removalNode.removeNode()
        } else {
            removalNode.valueCount -= Int32(numToRemove)
        }
        return numToRemove
    }
    
}

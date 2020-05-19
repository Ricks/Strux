//
//  BSNodeModify.swift
//  DataStructures
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
    private func insertLeftChildNode(_ val: T) -> BSNode<T> {
        let pred = inOrderPredecessor
        let newNode = BSNode(val, 1, parent: self, direction: .left)
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
    private func insertRightChildNode(_ val: T) -> BSNode<T> {
        let newNode = BSNode(val, 1, parent: self, direction: .right)
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
    func insert(_ val: T) -> (node: BSNode<T>, new: Bool) {
        var result: (node: BSNode<T>, new: Bool)
        if val == value {
            valueCount += 1
            result = (self, false)
        } else if val < value {
            if let thisLeft = left {
                result = thisLeft.insert(val)
            } else {
                result = (insertLeftChildNode(val), true)
             }
        } else {
            if let thisRight = right {
                result = thisRight.insert(val)
            } else {
                result = (insertRightChildNode(val), true)
            }
        }
        return result
    }

    /// Delete this node
    func deleteNode() {
        let predecessor = inOrderPredecessor
        var replaced = false
        if let thisLeft = left {
            if let thisRight = right {
                // Two children. Replace value with that of the in-order predecessor or successor.
                let toSwapWith = (thisLeft.height > thisRight.height) ? thisLeft.maxNode : thisRight.minNode
                swap(with: toSwapWith)
                value = toSwapWith.value
                deleteNode()
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
}

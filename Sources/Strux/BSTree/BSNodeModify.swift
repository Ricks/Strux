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

    // Replace this node with the given one, i.e. set this node's parent to point to the new node. This assumes
    // that the replacement doesn't change the node order, other than removing the current node from it.
    // - Parameter with: The node to replace with, which can be nil
    public func replace(with node: BSNode?) {
        if isLeft {
            parent.leftNode = node
        } else {
            parent.rightNode = node
        }
    }

    @discardableResult
    func insertLeftChildNode(_ val: T, _ n: Int) -> BSNode<T>? {
        let pred = inOrderPredecessor
        let newNode = BSNode(val, n, parent: self, direction: .left)
        left = newNode
        pred?.next = left
        left!.next = self
        rebalanceIfNecessary()
        return newNode
    }

    @discardableResult
    func insertRightChildNode(_ val: T, _ n: Int) -> BSNode<T>? {
        let newNode = BSNode(val, n, parent: self, direction: .right)
        right = newNode
        right!.next = next
        next = right
        rebalanceIfNecessary()
        return newNode
    }

    // Increase the count of the value in the subtree having this node as root. If there is already a node
    // for this value, increase the count by **n**, otherwise insert a new node and initialize the count to **n**.
    // Complexity is O(log(n)).
    // - Parameters:
    //   - val: The value to insert or increment the count of
    //   - n: The number to increase the count by
    // - Returns: the node inserted, if any
    @discardableResult
    func insert(_ val: T, _ n: Int) -> BSNode<T>? {
        guard n >= 1 else { return nil }
        var newNode: BSNode<T>?
        if val == value {
            valueCount += Int32(n)
        } else if val < value {
            if let thisLeft = left {
                newNode = thisLeft.insert(val, n)
            } else {
                newNode = insertLeftChildNode(val, n)
             }
        } else {
            if let thisRight = right {
                newNode = thisRight.insert(val, n)
            } else {
                newNode = insertRightChildNode(val, n)
            }
        }
        return newNode
    }

    // Increase by 1 the count of the value in the subtree having this node as root.
    // If there is already a node for this value, increase the count by 1, otherwise insert a new node and
    // initialize the count to 1. Complexity is O(log(n)).
    // - Parameters:
    //   - val: The value to insert or increment the count of
    @discardableResult
    func insert(_ val: T) -> BSNode<T>? {
        return insert(val, 1)
    }

    // Delete n occurrences of this value from the subtree having this node as root.
    @discardableResult
    func delete(_ val: T, _ n: Int) -> Bool {
        var nodeRemoved = false
        if let node = find(val) {
            if node.valueCount > n {
                node.valueCount -= Int32(n)
            } else {
                node.deleteNode()
                nodeRemoved = true
            }
        }
        return nodeRemoved
    }

    // Delete all occurrences of this value from the subtree having this node as root.
    @discardableResult
    func deleteAll(_ val: T) -> Bool {
        var nodeRemoved = false
        if let node = find(val) {
            node.deleteNode()
            nodeRemoved = true
        }
        return nodeRemoved
    }

    // Delete this node
    func deleteNode() {
        let pred = inOrderPredecessor
        var replaced = false
        if let thisLeft = left {
            if let thisRight = right {
                // Two children. Replace value with that of the in-order predecessor or successor.
                if thisLeft.height > thisRight.height {
                    let predecessor = thisLeft.maxNode
                    copyValueFrom(predecessor)
                    predecessor.deleteNode()
                } else {
                    let successor = thisRight.minNode
                    copyValueFrom(successor)
                    next = successor.next
                    successor.deleteNode()
                }
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
            pred?.next = next
            if let bsParent = parent as? BSNode {
                bsParent.rebalanceIfNecessary()
            }
        }
    }
}

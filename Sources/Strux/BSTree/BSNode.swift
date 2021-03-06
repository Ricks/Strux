//
//  BSNode.swift
//  Strux
//
//  Created by Richard Clark on 4/25/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation

/// Node for a counted, self-balancing (AVL) binary search tree. Counted means that there are no duplicate
/// nodes with the same value, but values have counts associated with them. For a subtree to be a valid BST,
/// the value of the root node of the subtree must be **strictly** greater than any value in the sub-subtree,
/// if any, with its left child as root, and **strictly** less than any value in the sub-subtree, if any, with
/// its right child as root, and all sub-subtrees of the subtree must meet the same condition.
class BSNode<T>: BNode {
    public typealias Element = (value: T, count: Int)
    /// The node's value
    var value: T
    /// The count of the value, always >= 1
    var valueCount: Int32 = 1
    /// Height of the subtree having this node as parent. Zero if this node is a leaf (no children).
    var height: Int32 = 0
    /// Ordering function
    var ordered: Ordered<T>

    /// Constructor with value and count
    /// - Parameters:
    ///   - val: The node's value
    ///   - n: The initial count
    init(_ val: T, _ n: Int, ordered: @escaping Ordered<T>, parent: BNode, direction: ChildDirection) {
        value = val
        valueCount = Int32(n)
        self.ordered = ordered
        super.init()
        if direction == .left {
            parent.leftNode = self
        } else {
            parent.rightNode = self
        }
    }

    /// Constructor that initializes the value's count to 1
    /// - Parameter val: The node's value
    convenience init(_ val: T, ordered: @escaping Ordered<T>, parent: BNode, direction: ChildDirection) {
        self.init(val, 1, ordered: ordered, parent: parent, direction: direction)
    }

    /// Left child node.
    var left: BSNode? {
        get { return leftNode as? BSNode }
        set { leftNode = newValue }
    }

    /// Right child node.
    var right: BSNode? {
        get { return rightNode as? BSNode }
        set { rightNode = newValue }
    }

    /// Parent node. All BSNodes have parents, including root, but root's parent is not a BSNode, it's a BNode.
    var parent: BNode {
        parentNode!
    }

    /// Next node in order, i.e. the node with the next highest value.
    var next: BSNode<T>? {
        get { return nextNode as? BSNode }
        set { nextNode = newValue }
    }

    /// Previous node in order, i.e. the node with the next lowest value.
    var prev: BSNode<T>? {
        prevNode as? BSNode
    }

    /// The height of the subtree having the left child as root, or -1 if there's no left child.
    var leftHeight: Int32 {
        left?.height ?? -1
    }

    /// The height of the subtree having the right child as root, or -1 if there's no right child.
    var rightHeight: Int32 {
        right?.height ?? -1
    }

    // The node with the first-ordered value in the subtree having this node as root. Complexity is *O(log(n))*.
    var firstNode: BSNode<T> {
        left?.firstNode ?? self
    }

    // The node with the last-ordered value in the subtree having this node as root. Complexity is *O(log(n))*.
    var lastNode: BSNode<T> {
        right?.lastNode ?? self
    }

    // The node of having the next-lowest value, or nil if none. Complexity is *O(log(n))*.
    var inOrderPredecessor: BSNode<T>? {
        if let thisLeft = left {
            return thisLeft.lastNode
        } else {
            var node = self
            while let bsParent = node.parent as? BSNode<T> {
                if node.isRight {
                    return bsParent
                } else {
                    node = bsParent
                }
            }
        }
        return nil
    }

    /// The node having the next-highest value, or nil if none. Complexity is *O(log(n))*.
    var inOrderSuccessor: BSNode<T>? {
        if let thisRight = right {
            return thisRight.firstNode
        } else {
            var node = self
            while let bsParent = node.parent as? BSNode<T> {
                if node.isLeft {
                    return bsParent
                } else {
                    node = bsParent
                }
            }
        }
        return nil
    }

    func swap(with other: BSNode) {
        let otherHeight = other.height
        super.swap(with: other)
        other.height = height
        height = otherHeight
    }

    /// Find the node in the subtree with the lowest value >= the given one, i.e. the ceiling node.
    /// - Parameter val: The value to search for.
    /// - Returns: The node containing the ceiling, or nil if the subtree doesn't have any values >= the given one.
    func findCeiling(_ val: T) -> BSNode<T>? {
        var result: BSNode<T>?
        if ordered(val, value) {
            result = left?.findCeiling(val) ?? self
        } else if ordered(value, val) {
            result = right?.findCeiling(val)
        } else {
            result = self
        }
        return result
    }

    /// Find a value in the subtree having this node as root. Complexity is *O(log(n))*.
    /// - Parameter val: The value to search for.
    /// - Returns: The node containing this value, or nil if the subtree doesn't contain the value.
    func find(_ val: T) -> BSNode<T>? {
        var result: BSNode<T>?
        if ordered(val, value) {
            result = left?.find(val)
        } else if ordered(value, val) {
            result = right?.find(val)
        } else {
            result = self
        }
        return result
    }

    /// The value/count pair of this node, as a tuple (val: T, count: Int)
    var element: Element {
        (value, Int(valueCount))
    }

    var totalCount: Int {
        return Int(valueCount) + (left?.totalCount ?? 0) + (right?.totalCount ?? 0)
    }

}

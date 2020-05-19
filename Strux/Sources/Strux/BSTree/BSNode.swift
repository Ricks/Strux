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
class BSNode<T: Comparable>: BNode {
    typealias Element = (value: T, count: Int)
    /// The node's value
    var value: T
    /// The count of the value, always >= 1
    var valueCount: Int32 = 1
    /// Height of the subtree having this node as parent. Zero if this node is a leaf (no children).
    var height: Int32 = 0

    /// Constructor with value and count
    /// - Parameters:
    ///   - val: The node's value
    ///   - n: The initial count
    init(_ val: T, _ n: Int, parent: BNode, direction: ChildDirection) {
        value = val
        valueCount = Int32(n)
        super.init()
        if direction == .left {
            parent.leftNode = self
        } else {
            parent.rightNode = self
        }
    }

    /// Constructor that initializes the value's count to 1
    /// - Parameter val: The node's value
    convenience init(_ val: T, parent: BNode, direction: ChildDirection) {
        self.init(val, 1, parent: parent, direction: direction)
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

    // The node with the maximum value in the subtree having this node as root. Complexity is *O(log(n))*.
    var maxNode: BSNode<T> {
        right?.maxNode ?? self
    }

    // The node with the minimum value in the subtree having this node as root. Complexity is *O(log(n))*.
    var minNode: BSNode<T> {
        left?.minNode ?? self
    }

    // The node of having the next-lowest value, or nil if none. Complexity is *O(log(n))*.
    var inOrderPredecessor: BSNode<T>? {
        if let thisLeft = left {
            return thisLeft.maxNode
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
            return thisRight.minNode
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

    /// Find a value in the subtree having this node as root. Complexity is *O(log(n))*.
    /// - Parameter val: The value to search for.
    /// - Returns: The node containing this value, or nil if the subtree doesn't contain the value.
    func find(_ val: T) -> BSNode<T>? {
        if val == value {
            return self
        } else if val < value {
            return left?.find(val)
        }
        return right?.find(val)
    }

    /// The value/count pair of this node, as a tuple (val: T, count: Int)
    var element: Element {
        (value, Int(valueCount))
    }

    var totalCount: Int {
        return Int(valueCount) + (left?.totalCount ?? 0) + (right?.totalCount ?? 0)
    }

}

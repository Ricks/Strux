//
//  BNode.swift
//  DataStructures
//
//  Created by Richard Clark on 4/25/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation

enum ChildDirection {
    case left
    case right
}

/// Basic binary node behavior, ensuring integrity of parent and next/prev node pointers.
public class BNode {
    private var leftNodeStorage: BNode?
    private var rightNodeStorage: BNode?
    weak private var parentNodeStorage: BNode?
    weak private var nextNodeStorage: BNode?
    weak private var prevNodeStorage: BNode?

    /// Left child node, or nil if none
    var leftNode: BNode? {
        get {
            return leftNodeStorage
        }
        set {
            newValue?.parentNodeStorage = self
            leftNodeStorage = newValue
        }
    }

    /// Right child node, or nil if none
    var rightNode: BNode? {
        get {
            return rightNodeStorage
        }
        set {
            newValue?.parentNodeStorage = self
            rightNodeStorage = newValue
        }
    }

    /// Parent node, or nil if none
    var parentNode: BNode? {
        parentNodeStorage
    }

    /// Next node, or nil if none
    var nextNode: BNode? {
        get {
            return nextNodeStorage
        }
        set {
            newValue?.prevNodeStorage = self
            nextNodeStorage = newValue
        }
    }

    /// Previous node, or nil if none
    var prevNode: BNode? {
        prevNodeStorage
    }

    /// Set the pointer to the previous node to nil
    public func nilPrevNode() {
        prevNodeStorage = nil
    }

    /// True if this is a left child node. 
    public var isLeft: Bool {
        parentNode?.leftNode === self
    }

    /// True if this is a right child node.
    public var isRight: Bool {
        parentNode?.rightNode === self
    }

    /// Number of nodes in the subtree having this node as root
    public var nodeCount: Int {
        1 + (leftNode?.nodeCount ?? 0) + (rightNode?.nodeCount ?? 0)
    }

    /// Replace this node with the given one, i.e. set this node's parent to point to the new node. This
    /// assumes that the replacement doesn't change the node order, other than removing the current node
    /// from it.
    /// - Parameter with: The node to replace with, which can be nil
    public func replace(with other: BNode?) {
        if parentNode !== other {
            if isLeft {
                parentNode?.leftNode = other
            } else {
                parentNode?.rightNode = other
            }
        }
    }

    public func swap(with other: BNode) {
        let thisIsLeft = isLeft
        let thisParentNode = parentNode
        let thisLeftNode = leftNode
        let thisRightNode = rightNode
        let thisNextNode = nextNode
        let thisPrevNode = prevNode

        let newParent = (other.parentNode === self) ? other : other.parentNode
        let newLeftNode = (other.leftNode === self) ? other : other.leftNode
        let newRightNode = (other.rightNode === self) ? other : other.rightNode
        let newNextNode = (other.nextNode === self) ? other : other.nextNode
        let newPrevNode = (other.prevNode === self) ? other : other.prevNode

        if other.isLeft {
            newParent?.leftNode = self
        } else {
            newParent?.rightNode = self
        }
        leftNode = newLeftNode
        rightNode = newRightNode
        nextNode = newNextNode
        if newPrevNode != nil {
            newPrevNode!.nextNode = self
        } else {
            nilPrevNode()
        }

        let newOtherParent = (thisParentNode === other) ? self : thisParentNode
        let newOtherLeftNode = (thisLeftNode === other) ? self : thisLeftNode
        let newOtherRightNode = (thisRightNode === other) ? self : thisRightNode
        let newOtherNextNode = (thisNextNode === other) ? self : thisNextNode
        let newOtherPrevNode = (thisPrevNode === other) ? self : thisPrevNode

        if thisIsLeft {
            newOtherParent?.leftNode = other
        } else {
            newOtherParent?.rightNode = other
        }
        other.leftNode = newOtherLeftNode
        other.rightNode = newOtherRightNode
        other.nextNode = newOtherNextNode
        if newOtherPrevNode != nil {
            newOtherPrevNode!.nextNode = other
        } else {
            other.nilPrevNode()
        }
    }

}

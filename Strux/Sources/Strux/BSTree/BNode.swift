//
//  BNode.swift
//  DataStructures
//
//  Created by Richard Clark on 4/25/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation

/// Basic binary node behavior, ensuring integrity of parent node pointer.
public class BNode {
    private var leftNodeStorage: BNode?
    private var rightNodeStorage: BNode?
    weak private var parentNodeStorage: BNode?

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

}

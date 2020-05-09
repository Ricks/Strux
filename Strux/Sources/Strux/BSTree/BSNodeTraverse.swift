//
//  BSNodeTraverse.swift
//  DataStructures
//
//  Created by Richard Clark on 4/25/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation

extension BSNode {

    /// Returns the nodes in the subtree having this node as root, in sorted order (the nodes in the left
    /// child subtree, if any, followed by this node, followed by the nodes in the right child subtree,
    /// if any).
    ///  - Returns: The node array
    func traverseInOrderNodes() -> [BSNode] {
        var out = [BSNode]()
        if let left = left { out = out + left.traverseInOrderNodes() }
        out.append(self)
        if let right = right { out = out + right.traverseInOrderNodes() }
        return out
    }

    /// Returns the elements in the subtree having this node as root, in sorted order (the nodes in the left
    /// child subtree, if any, followed by this node, followed by the nodes in the right child subtree,
    /// if any).
    ///  - Returns: The element array
    func traverseInOrder() -> [Element] {
        var out = [Element]()
        if let left = left { out = out + left.traverseInOrder() }
        out.append((value, Int(valueCount)))
        if let right = right { out = out + right.traverseInOrder() }
        return out
    }

    /// Returns the elements in the subtree having this node as root, in "pre-order" (this node, followed by
    /// the nodes in the left child subtree, if any, followed by the nodes in the right child subtree, if any).
    /// - Returns: The node array
    func traversePreOrder() -> [Element] {
        var out = [(value, Int(valueCount))]
        if let left = left { out = out + left.traversePreOrder() }
        if let right = right { out = out + right.traversePreOrder() }
        return out
    }

    /// Returns the nodes in the subtree having this node as root, in "post-order" (the nodes in the left child
    /// subtree, if any, followed by the nodes in the right child subtree, if any, followed by this node).
    /// - Returns: The node array
    func traversePostOrder() -> [Element] {
        var out = [Element]()
        if let left = left { out = out + left.traversePostOrder() }
        if let right = right { out = out + right.traversePostOrder() }
        out.append((value, Int(valueCount)))
        return out
    }

    /// Returns the nodes in the subtree having this node as root, each level of the tree at
    /// a time, from the root downward. This is a breadth-first traversal.
    /// - Returns: The node array
    func traverseLevel() -> [Element] {
        var out = [Element]()
        var q = Queue<BSNode<T>>()
        q.add(self)
        while let node = q.remove() {
            out.append((node.value, Int(node.valueCount)))
            if let left = node.left {
                q.add(left)
            }
            if let right = node.right {
                q.add(right)
            }
        }
        return out
    }

}

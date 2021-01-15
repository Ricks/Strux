//
//  DisjointSet.swift
//  Strux
//
//  Created by Richard Clark on 1/11/21.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation

/// A disjoint-set data structure, also known as union-find or merge-find. The data structure stores
/// associations between unique values of type T. Two values are in the same subset if there are associations that
/// link them. The structure allows you to quickly determine whether two values are in the same subset.
///
/// There are two methods used to set the associations and determine whether two values are in the same subset:
///
///    **union(v1, v2)** merges the subsets containing v1 and v2, if they're not already in the same subset
///
///    **find(v)** returns the root value of the subset. Two values v1 and v2 are in the same subset if find(v1) = find(v2)
///
/// From Wikipedia: While there are several ways of implementing disjoint-set data structures, in practice they are
/// often identified with a particular implementation called a disjoint-set forest. This is a specialized type of
/// forest which performs unions and finds in near constant amortized time. To perform a sequence of m addition,
/// union, or find operations on a disjoint-set forest with n nodes requires total time O(mα(n)), where α(n) is the
/// extremely slow-growing inverse Ackermann function. Disjoint-set forests do not guarantee this performance on a
/// per-operation basis. Individual union and find operations can take longer than a constant times α(n) time, but
/// each operation causes the disjoint-set forest to adjust itself so that successive operations are faster.
/// Disjoint-set forests are both asymptotically optimal and practically efficient.
/// ```
/// var ds = DisjointSet<Int>()
/// ds.union(2, 3)
/// ds.union(3, 4)
/// ds.find(1)     // 1
/// ds.find(2)     // 3
/// ds.find(3)     // 3
/// ds.find(4)     // 3
/// ds.find(5)     // 5
/// ```
public class DisjointSet<T: Hashable>: CustomStringConvertible {

    private class Node<T: Hashable> {
        let value: T
        var size: Int
        var parent: Node<T>?   // Root nodes have nil parent

        init(_ value: T) {
            self.value = value
            size = 1
        }
    }

    private var nodes = [T: Node<T>]()

    private func getNode(_ value: T) -> Node<T> {
        var node = nodes[value]
        if node == nil {
            node = Node(value)
            nodes[value] = node
        }
        return node!
    }

    private func findNode(_ node: Node<T>) -> Node<T> {
        if let parent = node.parent {
            let root = findNode(parent)
            node.parent = root
            return root
        }
        return node
    }

    /************************** Public interface *************************/

    /// Put two values in the same subset (make them have the same root).
    /// - Parameter value1: first value
    /// - Parameter value2: second value
    public func union(_ value1: T, _ value2: T) {
        let root1 = findNode(getNode(value1))
        let root2 = findNode(getNode(value2))
        guard root1 !== root2 else {
            return
        }
        if root1.size > root2.size {
            root2.parent = root1
            root1.size += root2.size
        } else {
            root1.parent = root2
            root2.size += root1.size
        }
    }

    /// Return the root value of the given value
    /// - Parameter value: value to find the root of
    /// - Returns: the root of the value
    public func find(_ value: T) -> T {
        if let node = nodes[value] {
            return findNode(node).value
        }
        return value
    }

    /// Clear the set, i.e. remove all associations and make it like a newly-created DisjointSet.
    public func clear() {
        nodes = [T: Node<T>]()
    }

    /// A string that is a newline-separated list of "\<value\>: root = find(\<value\>)", giving for each value in
    /// the set, the root of the value. Only values that have been given as one of the values in a union()
    /// call are listed.
    public var description: String {
        nodes.keys.map { "\($0): root = \(find($0))" }.joined(separator: "\n")
    }
}

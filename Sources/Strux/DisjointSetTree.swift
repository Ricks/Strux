//
//  DisjointSetTree.swift
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
/// Methods:
///
///    **contains(v)** returns true if v is in the set, false otherwise.
///
///    **makeSubset(v)** if v is not already in the set, add it to the set as a new subset.
///
///    **union(v1, v2)** merges the subsets containing v1 and v2, if they're not already in the same subset.
///
///    **find(v)** returns the root value of the subset. Two values v1 and v2 are in the same subset iff find(v1)
///     = find(v2).
///
///    **clear()** clears the set, i.e. return it to the state of a newly-created set.
///
///  Properties:
///
///    **count** the number of unique values
///
///    **subsetCount** the number of unique subsets
///
/// *From Wikipedia*: While there are several ways of implementing disjoint-set data structures, in practice they are
/// often identified with a particular implementation called a disjoint-set forest. This is a specialized type of
/// forest which performs unions and finds in near constant amortized time. To perform a sequence of m addition,
/// union, or find operations on a disjoint-set forest with n nodes requires total time O(mα(n)), where α(n) is the
/// extremely slow-growing inverse Ackermann function. Disjoint-set forests do not guarantee this performance on a
/// per-operation basis. Individual union and find operations can take longer than a constant times α(n) time, but
/// each operation causes the disjoint-set forest to adjust itself so that successive operations are faster.
/// Disjoint-set forests are both asymptotically optimal and practically efficient.
/// ```
/// let ds = DisjointSetTree<Int>()
/// ds.union(2, 3)
/// ds.union(3, 4)
/// ds.find(1)     // 1
/// ds.find(2)     // 3
/// ds.find(3)     // 3
/// ds.find(4)     // 3   (2, 3, and 4 are in the same subset)
/// ds.find(5)     // 5
/// print(ds)
/// 
/// 4: root = 3
/// 2: root = 3
/// 3: root = 3
/// ```
public class DisjointSetTree<T: Hashable>: CustomStringConvertible {
    public var count: Int {
        nodes.values.count
    }
    
    public var subsetCount: Int {
        nodes.values.filter { isRootNode($0) }.count
    }

    private class Node {
        let value: T
        var size: Int
        var parent: Node?   // Root nodes have nil parent

        init(_ value: T) {
            self.value = value
            size = 1
        }
    }

    private var nodes = [T: Node]()

    private func getNode(_ value: T) -> Node {
        var node = nodes[value]
        if node == nil {
            node = Node(value)
            nodes[value] = node
        }
        return node!
    }
    
    private func isRootNode(_ node: Node) -> Bool {
        return node.parent == nil
    }

    private func findNode(_ node: Node) -> Node {
        if let parent = node.parent {
            let root = findNode(parent)
            node.parent = root
            return root
        }
        return node
    }

    public init() {
    }
    
    public func contains(_ value: T) -> Bool {
        return nodes[value] != nil
    }

    /// Add a new value into a new set containing only the new element, and the new set is added to the data structure.
    /// - Parameter value: value to add
    public func makeSubset(_ value: T) {
        if !contains(value) {
            let node = getNode(value)
            node.size = 1
        }
    }

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

    /// Return the root value of the given value. Two values v1 and v2 are in the same subset if find(v1) = find(v2).
    /// - Parameter value: value to find the root of
    /// - Returns: the root of the value
    public func find(_ value: T) -> T {
        if let node = nodes[value] {
            return findNode(node).value
        }
        return value
    }

    /// Clear the set, i.e. remove all associations and make it like a newly-created DisjointSetTree.
    public func clear() {
        nodes = [T: Node]()
    }

    /// A string that is a newline-separated list of "\<value\>: root = find(\<value\>)", giving for each value in
    /// the set, the root of the value. Only values that have been given as one of the values in a union()
    /// call are listed.
    public var description: String {
        (nodes.keys.map { "\($0): root = \(find($0))" }).joined(separator: "\n")
    }
}

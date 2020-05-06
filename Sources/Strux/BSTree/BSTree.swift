//
//  BinarySearchTree.swift
//  DataStructures
//
//  Created by Richard Clark on 4/20/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation

/// A counted, self-balancing (AVL) binary search tree. Counted means that there are no duplicate nodes with
/// the same value, but values have counts associated with them. To be a valid BST, the value of the root node
/// must be **strictly**greater than any value in the subtree, if any, with its left child as root, and
/// **strictly** less than any value in the subtree, if any, with its right child as root, and all subtrees
/// of the tree must meet the same condition.
///
/// BSTree is a BNode so that it can serve as the parent of root.
public class BSTree<T: Comparable>: BNode, NSCopying, ExpressibleByArrayLiteral {
    public typealias Element = (value: T, count: Int)
    public typealias Index = BSTreeIndex<T>

    /// The root node of the tree, or nil if the tree is empty. The root node has the tree as parent, so that
    /// all the BSNodes of the tree have parents.
    var root: BSNode<T>? {
        get { return leftNode as? BSNode }
        set { leftNode = newValue }
    }

    /// The number of elements in the tree (NOT the sum of all value counts)
    private(set) public var count = 0

    private func initializeWithCountedSet(_ countedSet: NSCountedSet) {
        let values = countedSet.allObjects as! [T]
        for val in values {
            insert(val, countedSet.count(for: val))
        }
    }

    public init(countedSet: NSCountedSet) {
        super.init()
        initializeWithCountedSet(countedSet)
    }

    public init(_ values: [T] = [T]()) {
        super.init()
        initializeWithCountedSet(NSCountedSet(array: values))
    }

    /// Constructor using array literal.
    required public init(arrayLiteral values: T...) {
        super.init()
        initializeWithCountedSet(NSCountedSet(array: values))
    }

    public func indexOf(_ val: T) -> Index? {
        let node = root?.find(val)
        return (node == nil) ? nil : BSTreeIndex(node: node)
    }

    public func contains(value: T) -> Bool {
        return indexOf(value) != nil
    }

    public func count(of val: T) -> Int {
        return Int(root?.find(val)?.valueCount ?? 0)
    }

    public func insert(_ val: T, _ n: Int) {
        guard n >= 1 else { return }
        if let root = root {
            if let newNode = root.insert(val, n) {
                count += 1
                if val < minNode!.value { minNode = newNode }
                else if val > maxNode!.value { maxNode = newNode }
            }
        } else {
            root = BSNode(val, n, parent: self, direction: .left)
            count = 1
            maxNode = root
            minNode = root
        }
    }

    public func insert(_ val: T) {
        insert(val, 1)
    }

    private func processDeleteNode(_ val: T) {
        count -= 1
        if minNode?.value == val {
            minNode = root?.minNode
        } else if maxNode?.value == val {
            maxNode = root?.maxNode
        }
    }

    public func delete(_ val: T, _ n: Int) {
        if let thisRoot = root, thisRoot.delete(val, n) {
            processDeleteNode(val)
        }
    }

    public func delete(_ val: T) {
        delete(val, 1)
    }

    public func deleteAll(_ val: T) {
        if let thisRoot = root, thisRoot.deleteAll(val) {
            processDeleteNode(val)
        }
    }

    public var height: Int {
        Int(root?.height ?? -1)
    }

    var maxNode: BSNode<T>?
    public var max: Element? {
        maxNode?.element
    }
    public var last: Element? { max }

    var minNode: BSNode<T>?
    public var min: Element? {
        minNode?.element
    }

    public func traverseInOrder() -> [Element] {
        // Using next pointers is faster than recursive BSNode traverseInOrder
        var out = [Element]()
        for element in self {
            out.append(element)
        }
        return out
    }

    public func traversePreOrder() -> [Element] {
        return root?.traversePreOrder() ?? []
    }

    public func traversePostOrder() -> [Element] {
        return root?.traversePostOrder() ?? []
    }

    public func traverseLevelNodes() -> [Element] {
        return root?.traverseLevel() ?? []
    }

    public var isValid: Bool {
        root?.isValid ?? true
    }

    public var isBalanced: Bool {
        root?.isBalanced ?? true
    }

    public func toCountedSet() -> NSCountedSet {
        let set = NSCountedSet()
        let elems = traverseInOrder()
        for elem in elems {
            for _ in 0 ..< elem.count {
                set.add(elem.value)
            }
        }
        return set
    }

    /// This creates a shallow copy if T is a reference type.
    public func copy(with zone: NSZone? = nil) -> Any {
        return BSTree(countedSet: toCountedSet())
    }

}

extension BSTree: CustomStringConvertible {

    public var description: String {
        root?.description ?? ""
    }

    public var descriptionWithHeight: String {
        root?.descriptionWithHeight ?? ""
    }

    public var descriptionWithNext: String {
        root?.descriptionWithNext ?? ""
    }

}

extension BSTree: Equatable {

    public static func == (lhs: BSTree<T>, rhs: BSTree<T>) -> Bool {
        if lhs.count != rhs.count { return false }
        var lIndex = lhs.startIndex
        var rIndex = rhs.startIndex
        while lIndex != lhs.endIndex {
            if lhs[lIndex] != rhs[rIndex] { return false }
            lIndex = lhs.index(after: lIndex)
            rIndex = rhs.index(after: rIndex)
        }
        return true
    }

}

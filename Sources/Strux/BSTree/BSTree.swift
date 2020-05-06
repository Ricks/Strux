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
/// the same value, but values have counts associated with them. To be a valid BST, the value of the root node must be **strictly**greater than any value in the subtree, if any, with its left child as root, and
/// **strictly** less than any value in the subtree, if any, with its right child as root, and all subtrees
/// of the tree must meet the same condition.
///
/// BSTree is a BNode so that it can serve as the parent of root.
public class BSTree<T: Comparable>: BNode, NSCopying, ExpressibleByArrayLiteral {
    public typealias Element = (value: T, count: Int)
    public typealias Index = BSTreeIndex<T>

    /// The root node of the tree, or nil if the tree is empty. The root node has the tree as parent, so
    /// that all the BSNodes of the tree have parents.
    var root: BSNode<T>? {
        get { return leftNode as? BSNode }
        set { leftNode = newValue }
    }

    /// The number of elements in the tree (NOT the sum of all value counts)
    public private(set) var count = 0

    private func initializeWithCountedSet(_ countedSet: NSCountedSet) {
        let values = countedSet.allObjects as! [T]
        for val in values {
            insert(val, countedSet.count(for: val))
        }
    }

    /// Initialize with an NSCountedSet.
    /// - Parameter countedSet: NSCountedSet
    public init(countedSet: NSCountedSet) {
        super.init()
        initializeWithCountedSet(countedSet)
    }

    /// Initialize with an array of values, which can contain duplicates.
    /// - Parameter values: Array
    public init(_ values: [T] = [T]()) {
        super.init()
        initializeWithCountedSet(NSCountedSet(array: values))
    }

    /// Constructor using array literal. The array can contain duplicates.
    /// - Parameter values: Array literal
    required public init(arrayLiteral values: T...) {
        super.init()
        initializeWithCountedSet(NSCountedSet(array: values))
    }

    /// Return the index (BSTreeIndex) of the value, or nil if the tree doesn't have the value.
    /// Time complexity: O(log(n))
    /// - Parameter val: The value to look for
    /// - Returns: index (optional)
    public func indexOf(_ val: T) -> Index? {
        let node = root?.find(val)
        return (node == nil) ? nil : BSTreeIndex(node: node)
    }

    /// Return true if the tree contains the given value, false otherwise.
    /// Time complexity: O(log(n))
    /// - Parameter value: The value to look for
    /// - Returns: true or false
    public func contains(value: T) -> Bool {
        return indexOf(value) != nil
    }

    /// Returns the count of the value in the tree. Zero if the tree doesn't contain the value.
    /// Time complexity: O(log(n))
    /// - Parameter value: The value get the count of
    /// - Returns: Integer count
    public func count(of val: T) -> Int {
        return Int(root?.find(val)?.valueCount ?? 0)
    }

    /// Insert the given number of the given value into the tree. If the value is already in the tree,
    /// the count is incremented by the given number.
    /// Time complexity: O(log(n))
    /// - Parameters:
    ///   - val: The value to insert n of
    ///   - n: The number of val to insert
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

    /// Insert one of the given value into the tree. If the value is already in the tree,
    /// the count is incremented by one.
    /// Time complexity: O(log(n))
    /// - Parameters:
    ///   - val: The value to insert one of
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

    /// Delete the given number of the given value from the tree. If the given number is >= the number
    /// of the value in the tree, the value is removed completed.
    /// Time complexity: O(log(n))
    /// - Parameters:
    ///   - val: The value to remove n of
    ///   - n: The number of val to remove
    public func delete(_ val: T, _ n: Int) {
        if let thisRoot = root, thisRoot.delete(val, n) {
            processDeleteNode(val)
        }
    }

    /// Delete one of the given value from the tree. If the number of the value already in the tree is
    /// more than one, the number is decremented by one, otherwise the value is removed from the tree.
    /// Time complexity: O(log(n))
    /// - Parameters:
    ///   - val: The value to remove one of
    public func delete(_ val: T) {
        delete(val, 1)
    }

    /// Delete all occurrences of the given value from the tree.
    /// Time complexity: O(log(n))
    /// - Parameters:
    ///   - val: The value to remove all occurrences of
    public func deleteAll(_ val: T) {
        if let thisRoot = root, thisRoot.deleteAll(val) {
            processDeleteNode(val)
        }
    }

    /// The height of the tree, i.e. the number of levels minus 1. An empty tree has a height of -1, a
    /// tree with just a root node has height 0, and a tree with two nodes has height 1.
    /// Time complexity: O(1)
    public var height: Int {
        Int(root?.height ?? -1)
    }

    var maxNode: BSNode<T>?
    /// The maximum element in the tree.
    /// Time complexity: O(1)
    public var max: Element? {
        maxNode?.element
    }
    /// The last (maximum) element of the tree.
    public var last: Element? { max }

    var minNode: BSNode<T>?
    /// The minimum element in the tree.
    /// Time complexity: O(1)
    public var min: Element? {
        minNode?.element
    }

    /// Return the elements of the tree "in order" (from min to max).
    /// - Returns: An array of elements
    public func traverseInOrder() -> [Element] {
        // Using next pointers is faster than recursive BSNode traverseInOrder
        var out = [Element]()
        for element in self {
            out.append(element)
        }
        return out
    }

    /// Return the elements of the tree in "pre" order, meaning that the root is the first
    /// element returned.
    /// - Returns: An array of elements
    public func traversePreOrder() -> [Element] {
        return root?.traversePreOrder() ?? []
    }

    /// Return the elements of the tree in "post" order, meaning that the root is the last
    /// element returned.
    /// - Returns: An array of elements
    public func traversePostOrder() -> [Element] {
        return root?.traversePostOrder() ?? []
    }

    /// Return the elements of the tree in level order, starting with the root and working downward.
    /// - Returns: An array of elements
    public func traverseLevelNodes() -> [Element] {
        return root?.traverseLevel() ?? []
    }

    /// True if the tree is a valid binary search tree, meaning that the value of the root node is
    /// greater than the value of its left child, and less than that of its right child, and all
    /// subtrees meet the same requirement. Note that if only the public functions (insert and delete)
    /// are used to modify the tree, it should always be valid.
    public var isValid: Bool {
        root?.isValid ?? true
    }

    /// True if the tree is balanced, meaning that the height of the left subtree of the root is no more
    /// than one different from the height of the right subtree, and all subtrees meet the same
    /// requirement. Note that if only the public functions (insert and delete) are used to modify the
    /// tree, it should always be balanced.
    public var isBalanced: Bool {
        root?.isBalanced ?? true
    }

    /// Returns an NSCountedSet with the same values and counts as the tree.
    /// - Returns: NSCountedSet
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

    /// Returns a copy of the tree (a shallow copy if T is a reference type).
    public func copy(with zone: NSZone? = nil) -> Any {
        return BSTree(countedSet: toCountedSet())
    }

}

extension BSTree: CustomStringConvertible {

    /// An ASCII-graphics depiction of the tree
    public var description: String {
        root?.description ?? ""
    }

    /// An ASCII-graphics depiction of the tree, with the height of each node given
    public var descriptionWithHeight: String {
        root?.descriptionWithHeight ?? ""
    }

    /// An ASCII-graphics depiction of the tree, with the next node for each node shown (i.e. the nodes
    /// in increasing order of value).
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

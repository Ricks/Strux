//
//  BinarySearchTree.swift
//  DataStructures
//
//  Created by Richard Clark on 4/20/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation

/// A counted, self-balancing (AVL) binary search tree. Counted means that there are no duplicate nodes
/// with the same value, but values have counts associated with them. To be a valid BST, the value of the
/// root node must be **strictly** greater than any value in the subtree, if any, with its left child as
/// root, and **strictly** less than any value in the subtree, if any, with its right child as root, and
/// all subtrees of the tree must meet the same condition.
///
/// Insertions, deletions, and queries have time complexity *O(log(n))*. Returning the count (of unique
/// values), tree height, minimum (first), and maximum (last) values are all *O(1)*. Traversing the tree in
/// order, min to max, is *O(n)*.
///
/// BSTree conforms to the Collection protocol, and meets all of Collection's expected performance
/// requirements (see above). It also conforms to Equatable, NSCopying, and ExpressibleByArrayLiteral.
///
/// The elements of the Collection are tuples of the form (value: T, count: Int). The indices of the
/// Collection are of non-numeric type BSTreeIndex<T>.
///
/// ```
/// let tree: BSTree = [14, -2, 32, 14]  // BSTree is a class, so it can be a "let"
/// tree.insert(42, 2)             // Insert 2 of value 42
/// tree.deleteAll(14)             // Delete both 14's
/// tree.contains(value: -2)       // true
/// print(tree)
///
///    32
///   /  \
/// -2    42(2)
///
/// tree.height                    // 1
/// tree.count                     // 3
/// tree.min.value                 // -2
/// tree.min.count                 // 1
/// tree.max.value                 // 42
/// tree.max.count                 // 2
/// Array(tree)                    // [(value: -2, count: 1), (value: 32, count: 1), (value: 42, count: 2)]
/// ```
public class BSTree<T: Comparable>: BNode, NSCopying, ExpressibleByArrayLiteral {
    public typealias Element = (value: T, count: Int)
    public typealias Index = BSTreeIndex<T>

    // MARK: State

    /// The root node of the tree, or nil if the tree is empty. The root node has the tree as parent, so
    /// that all the BSNodes of the tree have parents.
    var root: BSNode<T>? {
        get { return leftNode as? BSNode }
        set { leftNode = newValue }
    }

    var maxNode: BSNode<T>?
    var minNode: BSNode<T>?
    var medianNode: BSNode<T>?
    // The i'th (zero-based) member of the count members having this value that is
    // the actual median. If the offset is < the count - 1, then the median value is
    // the value given by the node, whether or not the total count of values is odd.
    var medianOffset = 0

    /// The number of elements (values) in the tree (NOT the sum of all value counts).
    /// Time complexity: *O(1)*
    public private(set) var count = 0

    /// The sum of all value counts.
    /// Time complexity: *O(1)*
    public private(set) var totalCount = 0

    // MARK: Constructors

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

    /// Initialize with an unsorted array of values, which can contain duplicates.
    /// - Parameter values: Array
    public init(_ values: [T] = [T]()) {
        super.init()
        initializeWithCountedSet(NSCountedSet(array: values))
    }

    /// Constructor using unsorted array literal. The array can contain duplicates.
    /// - Parameter values: Array literal
    required public init(arrayLiteral values: T...) {
        super.init()
        initializeWithCountedSet(NSCountedSet(array: values))
    }

    // MARK: Methods

    /// Return the index (BSTreeIndex) of the value, or nil if the tree doesn't have the value.
    /// Time complexity: *O(log(n))*
    /// - Parameter val: The value to look for
    /// - Returns: index, or nil if not found
    public func indexOf(_ val: T) -> Index? {
        let node = root?.find(val)
        return (node == nil) ? nil : BSTreeIndex(node: node)
    }

    /// Return true if the tree contains the given value, false otherwise.
    /// Time complexity: *O(log(n))*
    /// - Parameter value: The value to look for
    /// - Returns: true or false
    public func contains(value: T) -> Bool {
        return indexOf(value) != nil
    }

    /// Returns the count of the value in the tree. Zero if the tree doesn't contain the value.
    /// Time complexity: *O(log(n))*
    /// - Parameter value: The value get the count of
    /// - Returns: Integer count
    public func count(of val: T) -> Int {
        return Int(root?.find(val)?.valueCount ?? 0)
    }

    private func updateMedianAfterInsertOne(of val: T) {
        if totalCount == 1 {
            medianNode = minNode
            medianOffset = 0
        } else if totalCount % 2 == 0 {
            if medianNode != nil && val < medianNode!.value {
                medianOffset -= 1
                if medianOffset < 0 {
                    medianNode = medianNode?.prev
                    medianOffset = Int((medianNode?.valueCount ?? 0) - 1)
                }
            }
        } else {
            if medianNode != nil && val >= medianNode!.value {
                medianOffset += 1
                if medianOffset >= (medianNode?.valueCount ?? 0) {
                    medianNode = medianNode?.next
                    medianOffset = 0
                }
            }
        }
    }

    private func updateMedianBeforeDeleteOne(of val: T) {
        if totalCount == 1 {
            medianNode = nil
            medianOffset = 0
        } else if totalCount % 2 == 0 {
            if medianNode != nil && (val < medianNode!.value ||
                val == medianNode!.value && medianOffset == medianNode!.valueCount - 1) {
                medianOffset += 1
                if medianOffset >= (medianNode?.valueCount ?? 0) {
                    medianNode = medianNode?.next
                    medianOffset = 0
                }
            }
        } else {
            if medianNode != nil && val >= medianNode!.value {
                medianOffset -= 1
                if medianOffset < 0 {
                    medianNode = medianNode?.prev
                    medianOffset = Int((medianNode?.valueCount ?? 0) - 1)
                }
            }
        }
    }

    private func processNodeInsertion(_ newNode: BSNode<T>, _ val: T) {
        count += 1
        if minNode == nil || val < minNode!.value { minNode = newNode }
        if maxNode == nil || val > maxNode!.value { maxNode = newNode }
    }

    private func processNodeDeletion(_ val: T) {
        count -= 1
        if minNode != nil && minNode!.value == val { minNode = root?.minNode }
        if maxNode != nil && maxNode!.value == val { maxNode = root?.maxNode }
    }

    /// Insert the given number of the given value into the tree. If the value is already in the tree,
    /// the count is incremented by the given number.
    /// Time complexity: *O(log(n))*.
    /// - Parameters:
    ///   - val: The value to insert n of
    ///   - n: The number of val to insert
    public func insert(_ val: T, _ n: Int) {
        guard n >= 1 else { return }
        var insertionNode: BSNode<T>?
        for i in 0 ..< n {
            if i == 0 {
                // First time through, make sure we have an insertion node
                var newNode: Bool
                if root == nil {
                    insertionNode = BSNode(val, 1, parent: self, direction: .left)
                    root = insertionNode
                    newNode = true
                } else {
                    let result = root!.insert(val)
                    insertionNode = result.node
                    newNode = result.new
                }
                if newNode && insertionNode != nil {
                    processNodeInsertion(insertionNode!, val)
                }
            } else {
                // Already have the node, just bump up the count
                insertionNode?.valueCount += 1
            }
            totalCount += 1
            updateMedianAfterInsertOne(of: val)
        }
    }

    /// Insert one of the given value into the tree. If the value is already in the tree,
    /// the count is incremented by one.
    /// Time complexity: *O(log(n))*.
    /// - Parameters:
    ///   - val: The value to insert one of
    public func insert(_ val: T) {
        insert(val, 1)
    }

    /// Delete the given number of the given value from the tree. If the given number is >= the number
    /// of the value in the tree, the value is removed completed.
    /// Time complexity: *O(log(n))*.
    /// - Parameters:
    ///   - val: The value to remove n of
    ///   - n: The number of val to remove
    @discardableResult
    public func delete(_ val: T, _ n: Int) -> Int {
        var numToDelete = 0
        if let thisRoot = root, let deletionNode = thisRoot.find(val) {
            numToDelete = Swift.min(n, Int(deletionNode.valueCount))
            for _ in 0 ..< numToDelete {
                updateMedianBeforeDeleteOne(of: val)
                totalCount -= 1
                if deletionNode.valueCount > 1 {
                    deletionNode.valueCount -= 1
                } else {
                    deletionNode.deleteNode()
                    processNodeDeletion(val)
                }
            }
        }
        return numToDelete
    }

    /// Delete one of the given value from the tree. If the number of the value already in the tree is
    /// more than one, the number is decremented by one, otherwise the value is removed from the tree.
    /// Time complexity: *O(log(n))*.
    /// - Parameters:
    ///   - val: The value to remove one of
    public func delete(_ val: T) {
        delete(val, 1)
    }

    /// Delete all occurrences of the given value from the tree.
    /// Time complexity: *O(log(n))*.
    /// - Parameters:
    ///   - val: The value to remove all occurrences of
    public func deleteAll(_ val: T) {
        delete(val, Int.max)
    }

    /// Remove all values from the tree.
    /// Time complexity: *O(1)*.
    public func clear() {
        root = nil
        minNode = nil
        maxNode = nil
        medianNode = nil
        medianOffset = 0
        count = 0
        totalCount = 0
     }

    /// The height of the tree, i.e. the number of levels minus 1. An empty tree has height -1, a
    /// tree with just a root node has height 0, and a tree with two nodes has height 1.
    /// Time complexity: *O(1)*.
    public var height: Int {
        Int(root?.height ?? -1)
    }

    /// The maximum element in the tree.
    /// Time complexity: *O(1)*.
    public var maximum: Element? {
        maxNode?.element
    }
    /// The last (maximum) element of the tree.
    /// Time complexity: *O(1)*.
    public var last: Element? { maximum }

    /// The minimum element in the tree.
    /// Time complexity: *O(1)*.
    public var minimum: Element? {
        minNode?.element
    }

    /// Returns zero, one, or two median values. There will be zero values if and only if the tree is
    /// empty. There will be two values if the tree has an even number of values (n), and the n/2 and
    /// n/2 + 1 values (starting with 1) differ. Otherwise one value.
    public func medians() -> [T] {
        var out = [T]()
        if let medianNode = medianNode {
            out.append(medianNode.value)
            if (totalCount % 2 == 0) && (medianOffset == medianNode.valueCount - 1) {
                if let nextNode = medianNode.next {
                    out.append(nextNode.value)
                }
            }
        }
        return out
    }

    /// Return the elements of the tree "in order" (from min to max).
    /// Time complexity: *O(n)*.
    /// - Returns: An array of elements
    public func traverseInOrder() -> [Element] {
        // Using next pointers (i.e. Collection) is faster than recursive BSNode traverseInOrder.
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

    /// Return the elements of the tree in "level" order, starting with the root and working downward.
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

    public func toValueArray() -> [T] {
        var out = [T]()
        for elem in self {
            for _ in 0 ..< elem.count {
                out.append(elem.value)
            }
        }
        return out
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

    /// Description with each node's "next" pointer shown.
    var descriptionWithNext: String {
        root?.descriptionWithNext ?? ""
    }

    /// Description with each node's node count (the number of nodes in the subtree having that node as root)
    /// shown.
    var descriptionWithNodeCount: String {
        root?.descriptionWithNodeCount ?? ""
    }

    /// Description with each node's total count (the sum of all valueCount's in the subtree having that node
    /// as root) shown.
    var descriptionWithTotalCount: String {
        root?.descriptionWithTotalCount ?? ""
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

class SummedBSTree<T>: BSTree<T> where T: AdditiveArithmetic & Comparable {

    /// The sum of all values.
    /// Time complexity: *O(1)*
    public var sum = T.zero

    override public func insert(_ val: T, _ n: Int) {
        super.insert(val, n)
        for _ in 0 ..< n { sum += val }
    }

    override public func clear() {
        super.clear()
        sum = T.zero
    }

    @discardableResult
    override public func delete(_ val: T, _ n: Int) -> Int {
        let numDeleted = super.delete(val, n)
        for _ in 0 ..< numDeleted { sum -= val }
        return numDeleted
    }

}

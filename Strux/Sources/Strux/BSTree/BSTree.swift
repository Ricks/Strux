//
//  BinarySearchTree.swift
//  Strux
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
/// Insertions, deletions, and queries have time complexity *O(log(n))*. Returning the count of unique
/// values, the count of total values, tree height, minimum, maximum, and median are all *O(1)*.
/// If the values are numeric, the sum of all values is also available in *O(1)*. Traversing the tree in order,
/// min to max, is *O(n)*.
///
/// BSTree conforms to the BidirectionalCollection protocol, and meets all of that protocol's expected performance
/// requirements. It also conforms to Equatable, NSCopying, and ExpressibleByArrayLiteral.
///
/// The elements of the Collection are tuples of the form (value: T, count: Int). The indices of the
/// Collection are of non-numeric type BSTreeIndex<T>.
///
/// ```
/// let tree: BSTree = [14, -2, 32, 14]  // BSTree is a class, so it can be a "let"
/// tree.insert(42, 2)             // Insert 2 of value 42
/// tree.deleteAll(14)             // Delete both 14's
/// tree.containsValue(-2)       // true
/// print(tree)
///
///    32
///   /  \
/// -2    42(2)
///
/// tree.height                    // 1
/// tree.count                     // 3
/// tree.totalCount                // 4
/// tree.minimum                   // -2
/// tree.maximum                   // 42
/// tree.medians                   // [32, 42]
/// tree.sum                       // 114
/// Array(tree)                    // [(value: -2, count: 1), (value: 32, count: 1), (value: 42, count: 2)]
/// ```
public class BSTree<T: Comparable>: NSCopying, ExpressibleByArrayLiteral {
    public typealias Element = (value: T, count: Int)
    public typealias Index = BSTreeIndex<T>

    // MARK: State

    private var god = BNode()

    /// The root node of the tree, or nil if the tree is empty. The root node has the tree as parent, so
    /// that all the BSNodes of the tree have parents.
    var root: BSNode<T>? {
        get { return god.leftNode as? BSNode }
        set { god.leftNode = newValue }
    }

    fileprivate var maxNode: BSNode<T>?
    fileprivate var minNode: BSNode<T>?
    fileprivate var medianIndex = ValueIndex<T>()

    /// The number of elements (values) in the tree (NOT the sum of all value counts).
    /// Time complexity: *O(1)*
    public private(set) var count = 0

    /// The sum of all value counts.
    /// Time complexity: *O(1)*
    public private(set) var totalCount = 0

    private var sumStorage: T?

    // MARK: Constructors

    private func initializeWithCountedSet(_ countedSet: NSCountedSet) {
         let values = countedSet.allObjects as! [T]
         for val in values {
             insert(val, countedSet.count(for: val))
         }
    }

    /// Initialize with an NSCountedSet.
    /// - Parameter countedSet: NSCountedSet
    public convenience init(countedSet: NSCountedSet) {
        self.init()
        initializeWithCountedSet(countedSet)
    }

    /// Initialize with an unsorted array of values, which can contain duplicates.
    /// - Parameter values: Array
    public convenience init(_ values: [T]) {
        self.init()
        initializeWithCountedSet(NSCountedSet(array: values))
    }

    /// Constructor using unsorted array literal. The array can contain duplicates.
    /// - Parameter values: Array literal
    required public convenience init(arrayLiteral values: T...) {
        self.init()
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
    public func containsValue(_ value: T) -> Bool {
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
            medianIndex = ValueIndex(node: minNode, offset: 0)
        } else if totalCount % 2 == 0 {
            if medianIndex.node != nil && val < medianIndex.node!.value {
                medianIndex = medianIndex.prev
             }
        } else {
            if medianIndex.node != nil && val >= medianIndex.node!.value {
                medianIndex = medianIndex.next
            }
        }
    }

    private func updateMedianBeforeDeleteOne(of val: T) {
        if totalCount == 1 {
            medianIndex = ValueIndex(node: nil, offset: 0)
        } else if totalCount % 2 == 0 {
            if medianIndex.node != nil && (val < medianIndex.node!.value ||
                val == medianIndex.node!.value && medianIndex.offsetIsMax) {
                medianIndex = medianIndex.next
            }
        } else {
            if medianIndex.node != nil && val >= medianIndex.node!.value {
                medianIndex = medianIndex.prev
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

    fileprivate func performInsertion(_ val: T, _ n: Int) {
        guard n >= 1 else {
            return
        }
        var insertionNode: BSNode<T>?
        for i in 0 ..< n {
            if i == 0 {
                // First time through, make sure we have an insertion node
                var newNode: Bool
                if root == nil {
                    insertionNode = BSNode(val, 1, parent: god, direction: .left)
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

    /// Insert the given number of the given value into the tree. If the value is already in the tree,
    /// the count is incremented by the given number.
    /// Time complexity: *O(log(n))*.
    /// - Parameters:
    ///   - val: The value to insert n of
    ///   - n: The number of val to insert
    public func insert(_ val: T, _ n: Int) {
        performInsertion(val, n)
    }

    /// Insert one of the given value into the tree. If the value is already in the tree,
    /// the count is incremented by one.
    /// Time complexity: *O(log(n))*.
    /// - Parameters:
    ///   - val: The value to insert one of
    public func insert(_ val: T) {
        performInsertion(val, 1)
    }

    @discardableResult
    fileprivate func performDeletion(_ val: T, _ n: Int) -> Int {
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

    /// Delete the given number of the given value from the tree. If the given number is >= the number
    /// of the value in the tree, the value is removed completed.
    /// Time complexity: *O(log(n))*.
    /// - Parameters:
    ///   - val: The value to remove n of
    ///   - n: The number of val to remove
    public func delete(_ val: T, _ n: Int) {
        performDeletion(val, n)
    }

    /// Delete one of the given value from the tree. If the number of the value already in the tree is
    /// more than one, the number is decremented by one, otherwise the value is removed from the tree.
    /// Time complexity: *O(log(n))*.
    /// - Parameters:
    ///   - val: The value to remove one of
    public func delete(_ val: T) {
        performDeletion(val, 1)
    }

    /// Delete all occurrences of the given value from the tree.
    /// Time complexity: *O(log(n))*.
    /// - Parameters:
    ///   - val: The value to remove all occurrences of
    public func deleteAll(_ val: T) {
        performDeletion(val, Int.max)
    }

    fileprivate func performClear() {
        root = nil
        minNode = nil
        maxNode = nil
        medianIndex = ValueIndex()
        count = 0
        totalCount = 0
    }

    /// Remove all values from the tree. sumStorage cleared in extension below.
    /// Time complexity: *O(1)*.
    public func clear() {
        performClear()
    }

    /// The height of the tree, i.e. the number of levels minus 1. An empty tree has height -1, a
    /// tree with just a root node has height 0, and a tree with two nodes has height 1.
    /// Time complexity: *O(1)*.
    public var height: Int {
        Int(root?.height ?? -1)
    }

    /// The maximum element in the tree, or nil if the tree is empty.
    /// Time complexity: *O(1)*.
    public var maximum: T? {
        maxNode?.value
    }

    /// The last (maximum) element of the tree.
    /// Time complexity: *O(1)*.
    public var last: Element? { maxNode?.element }

    /// The minimum value in the tree, or nil if the tree is empty.
    /// Time complexity: *O(1)*.
    public var minimum: T? {
        minNode?.value
    }

    /// Returns zero, one, or two median values. There will be zero values if and only if the tree is
    /// empty. There will be two values if the tree has an even number of values (n), and the n/2 and
    /// n/2 + 1 values (starting with 1) differ. Otherwise one value.
    public var medians: [T] {
        var out = [T]()
        if let medianNode = medianIndex.node {
            out.append(medianNode.value)
            if (totalCount % 2 == 0) && medianIndex.offsetIsMax {
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
            for _ in 0 ..< elem.count { set.add(elem.value) }
        }
        return set
    }

    public func toValueArray() -> [T] {
        var out = [T]()
        for elem in self {
            for _ in 0 ..< elem.count { out.append(elem.value) }
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
    public var descriptionWithNext: String {
        root?.descriptionWithNext ?? ""
    }

    /// Description with each node's node count (the number of nodes in the subtree having that node as root)
    /// shown.
    public var descriptionWithNodeCount: String {
        root?.descriptionWithNodeCount ?? ""
    }

    /// Description with each node's total count (the sum of all valueCount's in the subtree having that node
    /// as root) shown.
    public var descriptionWithTotalCount: String {
        root?.descriptionWithTotalCount ?? ""
    }

}

extension BSTree: Equatable {

    public static func == (lhs: BSTree<T>, rhs: BSTree<T>) -> Bool {
        if lhs.count != rhs.count {
            return false
        }
        var lIndex = lhs.startIndex
        var rIndex = rhs.startIndex
        while lIndex != lhs.endIndex {
            if lhs[lIndex] != rhs[rIndex] {
                return false
            }
            lIndex = lhs.index(after: lIndex)
            rIndex = rhs.index(after: rIndex)
        }
        return true
    }

}

extension BSTree where T: AdditiveArithmetic {

    private func ensureSumStorageInitialized() {
        if sumStorage == nil {
            sumStorage = T.zero
            for elem in self { addToSumStorage(elem.value, elem.count) }
        }
    }

    /// The sum of each value times its count (if T conforms to AdditiveArithmetic).
    /// Time complexity: *O(1)*
    public var sum: T {
        get {
            ensureSumStorageInitialized()
            return sumStorage!
        }
        set {
            ensureSumStorageInitialized()
            sumStorage = newValue
        }
    }

    private func addToSumStorage(_ val: T, _ n: Int) {
        for _ in 0 ..< n { sum += val }
    }

    private func subtractFromSumStorage(_ val: T, _ n: Int) {
        for _ in 0 ..< n { sum -= val }
    }

    public func insert(_ val: T, _ n: Int) {
        addToSumStorage(val, n)        // Has to come before performInsertsion() so that sum is initialized correctly.
        performInsertion(val, n)
    }

    public func insert(_ val: T) {
        addToSumStorage(val, 1)        // Has to come before performInsertsion() so that sum is initialized correctly.
        performInsertion(val, 1)
    }

    public func clear() {
        performClear()
        sumStorage = T.zero
    }

    public func delete(_ val: T, _ n: Int) {
        let numDeleted = performDeletion(val, n)
        subtractFromSumStorage(val, numDeleted)
    }

    public func delete(_ val: T) {
        let numDeleted = performDeletion(val, 1)
        subtractFromSumStorage(val, numDeleted)
    }

    public func deleteAll(_ val: T) {
        let numDeleted = performDeletion(val, Int.max)
        subtractFromSumStorage(val, numDeleted)
    }

}

private struct ValueIndex<T: Comparable> {
    weak var node: BSNode<T>?
    var offset = 0

    private static func maxOffset(_ node: BSNode<T>?) -> Int {
        return Int((node?.valueCount ?? 0)) - 1
    }

    var next: ValueIndex<T> {
        var nNode = node
        var nOffset = offset + 1
        if nOffset > ValueIndex.maxOffset(nNode) {
            nNode = nNode?.next
            nOffset = 0
        }
        return ValueIndex(node: nNode, offset: nOffset)
    }

    var prev: ValueIndex<T> {
        var pNode = node
        var pOffset = offset - 1
        if pOffset < 0 {
            pNode = pNode?.prev
            pOffset = ValueIndex.maxOffset(pNode)
        }
        return ValueIndex(node: pNode, offset: pOffset)
    }

    var offsetIsMax: Bool {
        offset == ValueIndex.maxOffset(node)
    }

}

extension BSTree: BidirectionalCollection {

    public var startIndex: Index { BSTreeIndex(node: minNode) }
    public var endIndex: Index { BSTreeIndex(node: nil) }

    public subscript(i: Index) -> Element {
        assert((startIndex..<endIndex).contains(i), "Index out of bounds")
        return (i.node!.value, Int(i.node!.valueCount))
    }

    public func index(after i: Index) -> Index {
        return BSTreeIndex(node: i.node?.next)
    }

    public func index(before i: Index) -> Index {
        return BSTreeIndex(node: i.node?.prev ?? maxNode)
    }

}

public struct BSTreeIndex<T: Comparable>: Comparable {
    weak var node: BSNode<T>?

    public static func == (lhs: BSTreeIndex<T>, rhs: BSTreeIndex<T>) -> Bool {
        if let lnode = lhs.node, let rnode = rhs.node {
            return lnode === rnode
        }
        return lhs.node == nil && rhs.node == nil
    }

    public static func < (lhs: BSTreeIndex<T>, rhs: BSTreeIndex<T>) -> Bool {
        if let lnode = lhs.node, let rnode = rhs.node {
            return lnode.value < rnode.value
        }
        // nil means endIndex, which all other indices are less than
        return lhs.node != nil && rhs.node == nil
    }

}

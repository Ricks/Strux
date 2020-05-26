//
//  BSTree.swift
//  Strux
//
//  Created by Richard Clark on 4/20/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation

/// Type of the comparator that can be supplied to the BSTree constructors to provide an order if the tree values
/// are not Comparable, or to override the innate ordering.
///
/// For example, if we wanted the ordering for String values to be case insensitive:
/// ```
/// let tree = BSTree() { (s1: String, s2: String) in
///     return s1.lowercased() < s2.lowercased()
/// }
/// ```
/// or more succinctly:
/// ```
/// let tree = BSTree() { $0.lowercased() < $1.lowercased() }
/// ```
public typealias Ordered<T> = (T, T) -> Bool

/// A counted, self-balancing (AVL) binary search tree. Counted means that there are no duplicate nodes
/// with the same value, but values have counts associated with them. To be a valid BST, the value of the
/// root node must be **strictly** greater than any value in the subtree, if any, with its left child as
/// root, and **strictly** less than any value in the subtree, if any, with its right child as root, and
/// all subtrees of the tree must meet the same condition.
///
/// BSTree provides much the same capabilities as Java's TreeSet, except that it is also counted, and provides
/// a running median, and, if the values are numeric, a running sum.
///
/// The type of value being stored must be Comparable, or a comparator conforming to the Ordered protocol must
/// be supplied. The comparator can also be given to override a Comparable type's innate ordering (e.g. to make
/// the ordering of String values case insentitive).
///
/// Insertions, deletions, and queries have time complexity *O(log(n))*. Returning the count of unique
/// values, the count of total values, tree height, first, last, and median are all *O(1)*. If the values are
/// numeric, the sum of all values is also available in *O(1)*. Ceiling, floor, higher, and lower functions
/// are *O(log(n))*. Traversing the tree in order, first to last or vice-versa, is *O(n)*.
///
/// BSTree conforms to the BidirectionalCollection protocol, and meets all of that protocol's expected performance
/// requirements. It also conforms to Equatable and NSCopying.
///
/// The elements of the Collection are tuples of the form (value: T, count: Int). The indices of the
/// Collection are of non-numeric type BSTreeIndex<T>.
///
/// ```
/// let tree = BSTree(14, -2, 32, 14)  // BSTree is a class, so it can be a "let"
/// tree.insert(42, 2)                 // Insert 2 of value 42
/// tree.removeAll(14)                 // Remove both 14's
/// tree.containsValue(-2)             // true
/// print(tree)
///
///    32
///   /  \
/// -2    42(2)
///
/// tree.height                    // 1
/// tree.count                     // 3
/// tree.totalCount                // 4
/// tree.firstValue                // -2
/// tree.lastValue                 // 42
/// tree.medianValues              // [32, 42]
/// tree.sum                       // 114
/// tree.ceilingValue(32)          // 32
/// tree.floorValue(32)            // 32
/// tree.higherValue(32)           // 42
/// tree.lowerValue(32)            // -2
/// Array(tree)                    // [(value: -2, count: 1), (value: 32, count: 1), (value: 42, count: 2)]
/// ```
public class BSTree<T: Equatable>: NSCopying {
    public typealias Element = (value: T, count: Int)
    public typealias Index = BSTreeIndex<T>

    // MARK: State

    private var god = BNode()
    private var ordered: Ordered<T>

    /// The root node of the tree, or nil if the tree is empty. The root node has the tree as parent, so
    /// that all the BSNodes of the tree have parents.
    var root: BSNode<T>? {
        get { return god.leftNode as? BSNode }
        set { god.leftNode = newValue }
    }

    fileprivate var lastNode: BSNode<T>?
    fileprivate var firstNode: BSNode<T>?
    fileprivate var medianIndex = MedianIndex<T>()

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

    /// Initialize with ordered.
    public init(ordered: @escaping Ordered<T>) {
        self.ordered = ordered
    }

    /// Initialize with an NSCountedSet and ordered.
    /// - Parameters:
    ///   - countedSet: NSCountedSet
    ///   - ordered: ordered ((T, T) -> Bool)
    public convenience init(countedSet: NSCountedSet, ordered: @escaping Ordered<T>) {
        self.init(ordered: ordered)
        initializeWithCountedSet(countedSet)
    }

    /// Initialize with an unsorted array of values, which can contain duplicates, and a ordered.
    /// - Parameters:
    ///   - values: Array
    ///   - ordered: ordered ((T, T) -> Bool)
    public convenience init(_ values: [T], ordered: @escaping Ordered<T>) {
        self.init(ordered: ordered)
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

    private func processNodeInsertion(_ newNode: BSNode<T>, _ val: T) {
        count += 1
        if firstNode == nil || ordered(val, firstNode!.value) { firstNode = newNode }
        if lastNode == nil || ordered(lastNode!.value, val) { lastNode = newNode }
    }

    private func processNodeDeletion(_ val: T) {
        count -= 1
        if firstNode != nil && firstNode!.value == val { firstNode = root?.firstNode }
        if lastNode != nil && lastNode!.value == val { lastNode = root?.lastNode }
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
                    insertionNode = BSNode(val, ordered: ordered, parent: god, direction: .left)
                    root = insertionNode
                    medianIndex.setInitialNode(root!)
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
        }
        medianIndex.updateAfterChange(of: val, n: n, ordered: ordered)
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

    /// Insert the given value into the tree. If the value is already in the tree, the count is incremented by one.
    /// Time complexity: *O(log(n))*.
    /// - Parameters:
    ///   - val: The value to insert one of
    public func insert(_ val: T) {
        performInsertion(val, 1)
    }

    /// Insert values from an array.
    /// - Parameters:
    ///   - vals: The values to insert
    public func insert(_ vals: [T]) {
        for val in vals {
            insert(val)
        }
    }

    /// Insert multple values separated by commas.
    /// - Parameters:
    ///   - vals: The values to insert
    public func insertMultiple(_ vals: T...) {
        insert(vals)
    }

    @discardableResult
    fileprivate func performRemoval(_ val: T, _ n: Int) -> Int {
        var numToRemove = 0
        if let thisRoot = root, let deletionNode = thisRoot.find(val) {
            numToRemove = Swift.min(n, Int(deletionNode.valueCount))
            for _ in 0 ..< numToRemove {
                totalCount -= 1
                if deletionNode.valueCount > 1 {
                    deletionNode.valueCount -= 1
                } else {
                    medianIndex.aboutToRemoveNode(deletionNode)
                    deletionNode.removeNode()
                    processNodeDeletion(val)
                }
            }
        }
        medianIndex.updateAfterChange(of: val, n: -numToRemove, ordered: ordered)
        return numToRemove
    }

    /// Remove the given number of the given value from the tree. If the given number is >= the number
    /// of the value in the tree, the value is removed completed.
    /// Time complexity: *O(log(n))*.
    /// - Parameters:
    ///   - val: The value to remove n of
    ///   - n: The number of val to remove
    public func remove(_ val: T, _ n: Int) {
        performRemoval(val, n)
    }

    /// Remove one of the given value from the tree. If the number of the value already in the tree is
    /// more than one, the number is decremented by one, otherwise the value is removed from the tree.
    /// Time complexity: *O(log(n))*.
    /// - Parameters:
    ///   - val: The value to remove one of
    public func remove(_ val: T) {
        performRemoval(val, 1)
    }

    /// Remove all occurrences of the given value from the tree.
    /// Time complexity: *O(log(n))*.
    /// - Parameters:
    ///   - val: The value to remove all occurrences of
    public func removeAll(_ val: T) {
        performRemoval(val, Int.max)
    }

    fileprivate func performClear() {
        root = nil
        firstNode = nil
        lastNode = nil
        medianIndex = MedianIndex<T>()
        count = 0
        totalCount = 0
    }

    /// Remove all values from the tree. sumStorage cleared in extension below.
    /// Time complexity: *O(1)*
    public func clear() {
        performClear()
    }

    /// The height of the tree, i.e. the number of levels minus 1. An empty tree has height -1, a
    /// tree with just a root node has height 0, and a tree with two nodes has height 1.
    /// Time complexity: *O(1)*
    public var height: Int {
        Int(root?.height ?? -1)
    }

    /// Index of the first value in the tree, according to the ordering given by the comparator, or by the
    /// '<' operator. nil if the tree is empty. Note that this differs from startIndex in that it will be nil
    /// if the tree is empty whereas startIndex will not.
    /// Time complexity: *O(1)*
    public var firstIndex: Index? { firstNode == nil ? nil : BSTreeIndex(node: firstNode) }

    /// The first value in the tree, according to the ordering given by the comparator, or by the
    /// '<' operator. nil if the tree is empty.
    /// Time complexity: *O(1)*
    public var firstValue: T? { firstNode?.value }

    /// Index of the last value in the tree, according to the ordering given by the comparator, or by the
    /// '<' operator. nil if the tree is empty. Note that this differs from endIndex in that endIndex is one past
    /// lastIndex, and is never nil.
    /// Time complexity: *O(1)*
    public var lastIndex: Index? { lastNode == nil ? nil : BSTreeIndex(node: lastNode) }

    /// The last value in the tree, according to the ordering given by the comparator, or by the
    /// '<' operator. nil if the tree is empty.
    /// Time complexity: *O(1)*
    public var lastValue: T? { lastNode?.value }

    /// Returns the indices of zero, one, or two median values. There will be zero indices if and only if
    /// the tree is empty. There will be two indices if the tree has an even number of values (n = totalCount),
    /// and the n/2 and n/2 + 1 values (starting with 1) differ. Otherwise one index. Time complexity: *O(1)*
    public var medianIndices: [Index] {
        medianIndex.medianNodes.map { BSTreeIndex(node: $0) }
    }

    /// Returns zero, one, or two median values. There will be zero indices if and only if
    /// the tree is empty. There will be two indices if the tree has an even number of values (n = totalCount),
    /// and the n/2 and n/2 + 1 values (starting with 1) differ. Otherwise one index. Time complexity: *O(1)*
    public var medianValues: [T] {
        return medianIndex.medianNodes.map { $0.value }
    }

    /// Returns the index of the least value >= the given value, according to the ordering given by the
    /// comparator, or by the '<' operator. Returns nil if there is no ceiling. Time complexity: *O(log(n))*
    /// - Parameter val: The value to find the ceiling of
    /// - Returns: The index (nil if there is no ceiling value)
    public func ceilingIndex(_ val: T) -> Index? {
        let ceilingNode = root?.findCeiling(val)
        return (ceilingNode == nil) ? nil : BSTreeIndex(node: ceilingNode)
    }

    /// Returns the least value >= the given value, according to the ordering given by the
    /// comparator, or by the '<' operator. Returns nil if there is no ceiling. Time complexity: *O(log(n))*
    /// - Parameter val: The value to find the ceiling of
    /// - Returns: The ceiling value (nil if none)
    public func ceilingValue(_ val: T) -> T? {
        let index = ceilingIndex(val)
        return index == nil ? nil : self[index!].value
    }

    /// Returns the index of the greatest value <= the given value, according to the ordering given by the
    /// comparator, or by the '<' operator. Returns nil if there is no floor. Time complexity: *O(log(n))*
    /// - Parameter val: The value to find the floor of
    /// - Returns: The index (nil if there is no floor value)
    public func floorIndex(_ val: T) -> Index? {
        var floorNode: BSNode<T>?
        if let root = root {
            if let node = root.findCeiling(val) {
                floorNode = (node.value == val) ? node : node.prev
            } else {
                floorNode = lastNode
            }
        }
        return (floorNode == nil) ? nil : BSTreeIndex(node: floorNode)
    }

    /// Returns the greatest value <= the given value, according to the ordering given by the
    /// comparator, or by the '<' operator. Returns nil if there is no floor. Time complexity: *O(log(n))*
    /// - Parameter val: The value to find the floor of
    /// - Returns: The floor value (nil if none)
    public func floorValue(_ val: T) -> T? {
        let index = floorIndex(val)
        return index == nil ? nil : self[index!].value
    }

    /// Returns the index of the least value > the given value, according to the ordering given by the
    /// comparator, or by the '<' operator. Returns nil if there is no higher value. Time complexity: *O(log(n))*
    /// - Parameter val: The value to find the higher value of
    /// - Returns: The index (nil if there is no higher value)
    public func higherIndex(_ val: T) -> Index? {
        var higherNode: BSNode<T>?
        if let root = root {
            if let node = root.findCeiling(val) {
                higherNode = (node.value == val) ? node.next : node
            }
        }
        return (higherNode == nil) ? nil : BSTreeIndex(node: higherNode)
    }

    /// Returns the least value > the given value, according to the ordering given by the
    /// comparator, or by the '<' operator. Returns nil if there is no higher value. Time complexity: *O(log(n))*
    /// - Parameter val: The value to find the higher value of
    /// - Returns: The higher value (nil if none)
    public func higherValue(_ val: T) -> T? {
        let index = higherIndex(val)
        return index == nil ? nil : self[index!].value
    }

    /// Returns the index of the greatest value < the given value, according to the ordering given by the
    /// comparator, or by the '<' operator. Returns nil if there is no lower value. Time complexity: *O(log(n))*
    /// - Parameter val: The value to find the lower value of
    /// - Returns: The index (nil if there is no lower value)
    public func lowerIndex(_ val: T) -> Index? {
        var lowerNode: BSNode<T>?
        if let root = root {
            if let node = root.findCeiling(val) {
                lowerNode = node.prev
            } else {
                lowerNode = lastNode
            }
        }
        return (lowerNode == nil) ? nil : BSTreeIndex(node: lowerNode)
    }

    /// Returns the greatest value < the given value, according to the ordering given by the
    /// comparator, or by the '<' operator. Returns nil if there is no lower value. Time complexity: *O(log(n))*
    /// - Parameter val: The value to find the lower value of
    /// - Returns: The lower value (nil if none)
    public func lowerValue(_ val: T) -> T? {
        let index = lowerIndex(val)
        return index == nil ? nil : self[index!].value
    }

    /// Return the elements of the tree "in order" (from min to max).
    /// Time complexity: *O(n)*
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
    /// subtrees meet the same requirement. Note that if only the public functions (insert and remove)
    /// are used to modify the tree, it should always be valid.
    public var isValid: Bool {
        root?.isValid ?? true
    }

    /// True if the tree is balanced, meaning that the height of the left subtree of the root is no more
    /// than one different from the height of the right subtree, and all subtrees meet the same
    /// requirement. Note that if only the public functions (insert and remove) are used to modify the
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

    /// Returns an array of the values in the tree, in order, and with duplicates. The size of the array
    /// is equal to totalCount.
    /// - Returns: Sorted array of values
    public func toValueArray() -> [T] {
        var out = [T]()
        for elem in self {
            for _ in 0 ..< elem.count { out.append(elem.value) }
        }
        return out
    }

    /// Returns a copy of the tree (a shallow copy if T is a reference type).
    public func copy(with zone: NSZone? = nil) -> Any {
        return BSTree(countedSet: toCountedSet(), ordered: ordered)
    }

}

extension BSTree: CustomStringConvertible {

    /// An ASCII-graphics depiction of the tree.
    public var description: String {
        root?.description ?? ""
    }

    /// An ASCII-graphics depiction of the tree, with the height of each node given.
    public var descriptionWithHeight: String {
        root?.descriptionWithHeight ?? ""
    }

    /// Description with each node's "next" and "prev" pointers shown.
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

extension BSTree where T: Comparable {

    /// Initialize the tree with a default comparator of the type's '<' operator.
    public convenience init() {
        self.init(ordered: { (a: T, b: T) -> Bool in a < b })
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

    /// Initialize with an unsorted array of values, which can contain duplicates.
    /// - Parameter values: Array
    public convenience init(_ values: T...) {
        self.init()
        initializeWithCountedSet(NSCountedSet(array: values))
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

    /// Insert the given number of the given value into the tree. If the value is already in the tree,
    /// the count is incremented by the given number.
    /// Time complexity: *O(log(n))*.
    /// - Parameters:
    ///   - val: The value to insert n of
    ///   - n: The number of val to insert
    public func insert(_ val: T, _ n: Int) {
        addToSumStorage(val, n)        // Has to come before performInsertsion() so that sum is initialized correctly.
        performInsertion(val, n)
    }

    /// Insert the given value into the tree. If the value is already in the tree, the count is incremented by one.
    /// Time complexity: *O(log(n))*.
    /// - Parameters:
    ///   - val: The value to insert one of
    public func insert(_ val: T) {
        addToSumStorage(val, 1)        // Has to come before performInsertsion() so that sum is initialized correctly.
        performInsertion(val, 1)
    }

    /// Remove all values from the tree. sumStorage cleared in extension below.
    /// Time complexity: *O(1)*
    public func clear() {
        performClear()
        sumStorage = T.zero
    }

    /// Remove the given number of the given value from the tree. If the given number is >= the number
    /// of the value in the tree, the value is removed completed.
    /// Time complexity: *O(log(n))*.
    /// - Parameters:
    ///   - val: The value to remove n of
    ///   - n: The number of val to remove
    public func remove(_ val: T, _ n: Int) {
        let numRemoved = performRemoval(val, n)
        subtractFromSumStorage(val, numRemoved)
    }

    /// Remove one of the given value from the tree. If the number of the value already in the tree is
    /// more than one, the number is decremented by one, otherwise the value is removed from the tree.
    /// Time complexity: *O(log(n))*.
    /// - Parameters:
    ///   - val: The value to remove one of
    public func remove(_ val: T) {
        let numRemoved = performRemoval(val, 1)
        subtractFromSumStorage(val, numRemoved)
    }

    /// Remove all occurrences of the given value from the tree.
    /// Time complexity: *O(log(n))*.
    /// - Parameters:
    ///   - val: The value to remove all occurrences of
    public func removeAll(_ val: T) {
        let numRemoved = performRemoval(val, Int.max)
        subtractFromSumStorage(val, numRemoved)
    }

}

extension BSTree: BidirectionalCollection {

    public var startIndex: Index { BSTreeIndex(node: firstNode) }
    public var endIndex: Index { BSTreeIndex(node: nil) }

    public subscript(i: Index) -> Element {
        assert((startIndex..<endIndex).contains(i), "Index out of bounds")
        return (i.node!.value, Int(i.node!.valueCount))
    }

    public func index(after i: Index) -> Index {
        return BSTreeIndex(node: i.node?.next)
    }

    public func index(before i: Index) -> Index {
        return BSTreeIndex(node: i.node?.prev ?? lastNode)
    }

}

/// Non-numeric index type of the Collection.
public struct BSTreeIndex<T: Equatable>: Comparable {
    weak var node: BSNode<T>?

    public static func == (lhs: BSTreeIndex<T>, rhs: BSTreeIndex<T>) -> Bool {
        if let lnode = lhs.node, let rnode = rhs.node {
            return lnode === rnode
        }
        return lhs.node == nil && rhs.node == nil
    }

    public static func < (lhs: BSTreeIndex, rhs: BSTreeIndex) -> Bool {
        if let lnode = lhs.node, let rnode = rhs.node {
            return lnode.ordered(lnode.value, rnode.value)
        }
        // nil means endIndex, which all other indices are less than
        return lhs.node != nil && rhs.node == nil
    }

}

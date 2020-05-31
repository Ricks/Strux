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
/// ````
/// let tree = BSTree() { (s1: String, s2: String) in
///     return s1.lowercased() < s2.lowercased()
/// }
/// ````
/// or more succinctly:
/// ````
/// let tree = BSTree() { $0.lowercased() < $1.lowercased() }
/// ````
public typealias Ordered<T> = (T, T) -> Bool

/// A counted, self-balancing (AVL) binary search tree. Counted means that there are no duplicate nodes
/// with the same value, but values have counts associated with them. BSTree provides much the same
/// capabilities as Java's TreeSet, except that it is also counted, provides a running median, and, if the
/// values are numeric, provides a running sum.
///
/// The type of value being stored must be Comparable, or a comparator of type `Ordered` must
/// be supplied. The comparator can also be given to override a Comparable type's innate ordering (e.g. to make
/// the ordering of String values case insentitive). If a comparator isn't given, the ordering is from min
/// to max.
///
/// Insertions, deletions, and specific value queries (index, contains, count, ceiling, floor, higher, lower)
/// have time complexity *O(logN)*. General queries, i.e. the count of unique values, the count of total values,
/// tree height, first, last, and median are all *O(1)*. If the values are numeric, the sum of all values is
/// also available in *O(1)*. Traversing the tree in order, first to last or vice-versa, is *O(N)*.
///
/// BSTree conforms to the BidirectionalCollection protocol, and meets all of that protocol's expected
/// performance requirements. It also conforms to Equatable and NSCopying.
///
/// The elements of the Collection are tuples of the form (value: T, count: Int). The indices of the
/// Collection are of non-numeric type BSTreeIndex<T>.
///
/// ```
/// let tree = BSTree(14, 32, 14)  // Don't need comparator, because Int is Comparable
/// tree.insert(-2)
/// tree.insert(42, count: 2)      // Insert 2 of value 42
/// tree.removeAll(14)             // Remove both 14's
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
/// tree.contains(-2)              // true
/// tree.count(42)                 // 2
/// tree.ceilingValue(30)          // 32
/// tree.ceilingValue(32)          // 32
/// tree.floorValue(32)            // 32
/// tree.floorValue(35)            // 32
/// tree.higherValue(32)           // 42
/// tree.lowerValue(32)            // -2
/// Array(tree)                    // [(value: -2, count: 1), (value: 32, count: 1), (value: 42, count: 2)]
/// for elem in tree {
///     print("value = \(elem.value), count = \(elem.count)")
/// }
///
/// value = -2, count = 1
/// value = 32, count = 1
/// value = 42, count = 2
///
/// let index = tree.indexOf(42)    // Type BSTreeIndex<Int>
/// if let index = index {
///     let index2 = tree.index(before: index)
///     print("value = \(tree[index2].value), count = \(tree[index2].count)")
/// }
///
/// value = 32, count = 1
/// ```
public class BSTree<T: Equatable>: NSCopying {
    /// :nodoc:
    public typealias Element = (value: T, count: Int)
    /// :nodoc:
    public typealias Index = BSTreeIndex<T>

    // Private/Internal Properties and Methods

    var god = BNode()
    var ordered: Ordered<T>
    var countStorage = 0
    var totalCountStorage = 0
    var sumStorage: T?
    var lastNode: BSNode<T>?
    var firstNode: BSNode<T>?
    var medianIndex = MedianIndex<T>()

    /// The root node of the tree, or nil if the tree is empty. The root node has god as parent, so
    /// that all the BSNodes of the tree have parents.
    var root: BSNode<T>? {
        get { return god.leftNode as? BSNode }
        set { god.leftNode = newValue }
    }

    private func initializeWithCountedSet(_ countedSet: NSCountedSet) {
         let values = countedSet.allObjects as! [T]
         for val in values {
            insert(val, count: countedSet.count(for: val))
         }
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

    // MARK: Constructors

    /// Initialize with comparator (optional if T is Comparable).
    /// - Parameters:
    ///   - ordered: Ordered ((T, T) -> Bool)
    public init(ordered: @escaping Ordered<T>) {
        self.ordered = ordered
    }

    /// Initialize with an NSCountedSet and comparator (optional if T is Comparable).
    /// - Parameters:
    ///   - countedSet: NSCountedSet
    ///   - ordered: Ordered ((T, T) -> Bool)
    public convenience init(countedSet: NSCountedSet, ordered: @escaping Ordered<T>) {
        self.init(ordered: ordered)
        initializeWithCountedSet(countedSet)
    }

    /// Initialize with an unsorted sequence of values, which can contain duplicates, and a comparator
    /// (optional if T is Comparable).
    /// - Parameters:
    ///   - values: Array
    ///   - ordered: Ordered ((T, T) -> Bool)
    public convenience init<S>(_ vals: S, ordered: @escaping Ordered<T>) where S: Sequence, S.Element == T {
        self.init(ordered: ordered)
        var values = [T]()
        for val in vals { values.append(val) }
        initializeWithCountedSet(NSCountedSet(array: values))
    }

    // MARK: Copying

    /// Returns a copy of the tree (a shallow copy if T is a reference type).
    ///
    /// Example:
    /// ```
    /// let tree = BSTree(4, -9, 12, 3, 0, 65, -20, 4, 6)
    /// let tree2 = tree.copy() as! BSTree<Int>
    /// ```
    public func copy(with zone: NSZone? = nil) -> Any {
        return BSTree(countedSet: toCountedSet(), ordered: ordered)
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

    /// Initialize with an unsorted sequence of values, which can contain duplicates.
    /// - Parameter values: Array
    public convenience init<S>(_ vals: S) where S: Sequence, S.Element == T {
        self.init()
        var values = [T]()
        for val in vals { values.append(val) }
        initializeWithCountedSet(NSCountedSet(array: values))
    }

    /// Initialize with a comma-separated list of values, which can contain duplicates.
    /// - Parameter values: Array
    public convenience init(_ values: T...) {
        self.init()
        initializeWithCountedSet(NSCountedSet(array: values))
    }

}

extension BSTree {

    private func processNodeInsertion(_ newNode: BSNode<T>, _ val: T) {
        countStorage += 1
        if firstNode == nil || ordered(val, firstNode!.value) { firstNode = newNode }
        if lastNode == nil || ordered(lastNode!.value, val) { lastNode = newNode }
    }

    private func processNodeRemoval(_ val: T) {
        countStorage -= 1
        if firstNode != nil && firstNode!.value == val { firstNode = root?.firstNode }
        if lastNode != nil && lastNode!.value == val { lastNode = root?.lastNode }
    }

    func performInsertion(_ val: T, _ n: Int) {
        guard n >= 1 else {
            return
        }
        var insertionNode: BSNode<T>?
        var newNode: Bool
        if root == nil {
            insertionNode = BSNode(val, n, ordered: ordered, parent: god, direction: .left)
            root = insertionNode
            medianIndex.setInitialNode(root!)
            newNode = true
        } else {
            let result = root!.insert(val, n)
            insertionNode = result.node
            newNode = result.new
        }
        if newNode && insertionNode != nil {
            processNodeInsertion(insertionNode!, val)
        }
        totalCountStorage += n
        medianIndex.updateAfterChange(of: val, count: n, ordered: ordered)
    }

    @discardableResult
    func performRemoval(_ val: T, _ n: Int) -> Int {
        var numToRemove = 0
        if let thisRoot = root, let removalNode = thisRoot.find(val) {
            numToRemove = Swift.min(n, Int(removalNode.valueCount))
            let removingNode = (numToRemove == removalNode.valueCount)
            if removingNode { medianIndex.aboutToRemoveNode(removalNode) }
            removalNode.remove(val, n)
            if removingNode { processNodeRemoval(val) }
            totalCountStorage -= numToRemove
            medianIndex.updateAfterChange(of: val, count: -numToRemove, ordered: ordered)
        }
        return numToRemove
    }

    func performClear() {
        root = nil
        firstNode = nil
        lastNode = nil
        medianIndex.setToNil()
        countStorage = 0
        totalCountStorage = 0
    }

    // MARK: Modifying the Tree

    /// Insert the given value into the tree. If the value is already in the tree, the count is incremented
    /// by one. Time complexity: *O(logN)*
    /// - Parameters:
    ///   - val: The value to insert one of
    public func insert(_ val: T) {
        performInsertion(val, 1)
    }

    /// Insert multple values separated by commas. Time complexity: *O(log(Nm))* , where m is the number of
    /// values being inserted.
    /// - Parameters:
    ///   - vals: The values to insert
    public func insert(_ vals: T...) {
        for val in vals { performInsertion(val, 1) }
    }

    /// Insert the given number of the given value into the tree. If the value is already in the tree,
    /// the count is incremented by the given number.
    /// Time complexity: *O(logN)*
    /// - Parameters:
    ///   - val: The value to insert n of
    ///   - n: The number of val to insert
    public func insert(_ val: T, count: Int) {
        performInsertion(val, count)
    }

    /// Insert multiple values from a sequence. Time complexity: *O(log(Nm))*, where m is the number
    /// of values being inserted.
    /// - Parameters:
    ///   - vals: The values to insert
    public func insert<S>(_ vals: S) where S: Sequence, S.Element == T {
        for val in vals { performInsertion(val, 1) }
    }

    /// Remove one of the given value from the tree. If the number of the value already in the tree is
    /// more than one, the number is decremented by one, otherwise the value is removed from the tree.
    /// Time complexity: *O(logN)*
    /// - Parameters:
    ///   - val: The value to remove one of
    public func remove(_ val: T) {
        performRemoval(val, 1)
    }

    /// Remove multple values separated by commas. Time complexity: *O(log(Nm))*, where m is the number of
    /// values being removed.
    /// - Parameters:
    ///   - vals: The values to remove
    public func remove(_ vals: T...) {
        for val in vals {
            performRemoval(val, 1)
        }
    }

    /// Remove the given number of the given value from the tree. If the given number is >= the number
    /// of the value in the tree, the value is removed completed.
    /// Time complexity: *O(logN)*
    /// - Parameters:
    ///   - val: The value to remove n of
    ///   - n: The number of val to remove
    public func remove(_ val: T, count: Int) {
        performRemoval(val, count)
    }

    /// Remove from the tree the values given in a sequence. Time complexity: *O(log(Nm))*, where m is the
    /// number of values being removed.
    /// - Parameters:
    ///   - vals: The values to insert
    public func remove<S>(_ vals: S) where S: Sequence, S.Element == T {
        for val in vals {
            performRemoval(val, 1)
        }
    }

    /// Remove all occurrences of the given value from the tree.
    /// Time complexity: *O(logN)*
    /// - Parameters:
    ///   - val: The value to remove all occurrences of
    public func removeAll(_ val: T) {
        performRemoval(val, Int.max)
    }

    /// Remove all values from the tree. Time complexity: *O(1)*
    public func clear() {
        performClear()
    }
}

extension BSTree {

    // MARK: Value-Specific Queries

    /// Return the index (`BSTreeIndex`) of the value, or nil if the tree doesn't have the value.
    /// Time complexity: *O(logN)*
    /// - Parameter val: The value to look for
    /// - Returns: index, or nil if not found
    public func index(_ val: T) -> Index? {
        let node = root?.find(val)
        return (node == nil) ? nil : BSTreeIndex(node: node)
    }

    /// Return true if the tree contains the given value, false otherwise.
    /// Time complexity: *O(logN)*
    /// - Parameter value: The value to look for
    /// - Returns: true or false
    public func contains(_ value: T) -> Bool {
        return index(value) != nil
    }

    /// Returns the count of the value in the tree. Zero if the tree doesn't contain the value.
    /// Time complexity: *O(logN)*
    /// - Parameter value: The value get the count of
    /// - Returns: Integer count
    public func count(_ val: T) -> Int {
        return Int(root?.find(val)?.valueCount ?? 0)
    }

    /// Returns the index of the least value >= the given value, according to the ordering given by the
    /// comparator, or by the '<' operator. Returns nil if there is no ceiling. Time complexity: *O(logN)*
    /// - Parameter val: The value to find the ceiling of
    /// - Returns: The index (nil if there is no ceiling value)
    public func ceilingIndex(_ val: T) -> Index? {
        let ceilingNode = root?.findCeiling(val)
        return (ceilingNode == nil) ? nil : BSTreeIndex(node: ceilingNode)
    }

    /// Returns the least value >= the given value, according to the ordering given by the
    /// comparator, or by the '<' operator. Returns nil if there is no ceiling. Time complexity: *O(logN)*
    /// - Parameter val: The value to find the ceiling of
    /// - Returns: The ceiling value (nil if none)
    public func ceilingValue(_ val: T) -> T? {
        let index = ceilingIndex(val)
        return index == nil ? nil : self[index!].value
    }

    /// Returns the index of the greatest value <= the given value, according to the ordering given by the
    /// comparator, or by the '<' operator. Returns nil if there is no floor. Time complexity: *O(logN)*
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
    /// comparator, or by the '<' operator. Returns nil if there is no floor. Time complexity: *O(logN)*
    /// - Parameter val: The value to find the floor of
    /// - Returns: The floor value (nil if none)
    public func floorValue(_ val: T) -> T? {
        let index = floorIndex(val)
        return index == nil ? nil : self[index!].value
    }

    /// Returns the index of the least value > the given value, according to the ordering given by the
    /// comparator, or by the '<' operator. Returns nil if there is no higher value. Time complexity: *O(logN)*
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
    /// comparator, or by the '<' operator. Returns nil if there is no higher value. Time complexity: *O(logN)*
    /// - Parameter val: The value to find the higher value of
    /// - Returns: The higher value (nil if none)
    public func higherValue(_ val: T) -> T? {
        let index = higherIndex(val)
        return index == nil ? nil : self[index!].value
    }

    /// Returns the index of the greatest value < the given value, according to the ordering given by the
    /// comparator, or by the '<' operator. Returns nil if there is no lower value. Time complexity: *O(logN)*
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
    /// comparator, or by the '<' operator. Returns nil if there is no lower value. Time complexity: *O(logN)*
    /// - Parameter val: The value to find the lower value of
    /// - Returns: The lower value (nil if none)
    public func lowerValue(_ val: T) -> T? {
        let index = lowerIndex(val)
        return index == nil ? nil : self[index!].value
    }
}

extension BSTree {

    // MARK: General Queries

    /// The number of elements (unique values) in the tree (NOT the sum of all value counts, which is
    /// ```totalCount```). This is also the number of nodes.
    /// Time complexity: *O(1)*
    public var count: Int {
        countStorage
    }

    /// The sum of all value counts.
    /// Time complexity: *O(1)*
    public var totalCount: Int {
        totalCountStorage
    }

    /// The height of the tree, i.e. the number of levels minus 1. An empty tree has height -1, a
    /// tree with just a root node has height 0, and a tree with two nodes has height 1.
    /// Time complexity: *O(1)*
    public var height: Int {
        Int(root?.height ?? -1)
    }

    /// Index of the first value in the tree, according to the ordering given by the comparator,
    /// or nil if the tree is empty. If no comparator is supplied, the '<' operator is used, and the first
    /// value is the minimum. Note that this differs from startIndex in that it will be nil if the tree is
    /// empty whereas startIndex will not. Time complexity: *O(1)*
    public var firstIndex: Index? { firstNode == nil ? nil : BSTreeIndex(node: firstNode) }

    /// The first value in the tree, according to the ordering given by the comparator,
    /// or nil if the tree is empty. If no comparator is supplied, the '<' operator is used, and the first
    /// value is the minimum. Time complexity: *O(1)*
    public var firstValue: T? { firstNode?.value }

    /// Index of the last value in the tree, according to the ordering given by the comparator, or nil
    /// if the tree is empty. If no comparator is supplied, the '<' operator is used, and the last
    /// value is the maximum. Note that this differs from endIndex in that endIndex is one past
    /// lastIndex, and is never nil. Time complexity: *O(1)*
    public var lastIndex: Index? { lastNode == nil ? nil : BSTreeIndex(node: lastNode) }

    /// The last value in the tree, according to the ordering given by the comparator, or nil
    /// if the tree is empty. If no comparator is supplied, the '<' operator is used, and the last
    /// value is the maximum. Time complexity: *O(1)*
    public var lastValue: T? { lastNode?.value }

    /// Returns the indices of zero, one, or two median values. There will be zero indices if and only if
    /// the tree is empty. There will be two indices if the tree's ```totalCount``` is a multiple of 2
    /// and the values at positions n/2 and n/2 + 1 (starting with 1) differ. Otherwise one index. Time
    /// complexity: *O(1)*
    public var medianIndices: [Index] {
        medianIndex.medianNodes.map { BSTreeIndex(node: $0) }
    }

    /// Returns zero, one, or two median values. There will be zero values if and only if
    /// the tree is empty. There will be two values if the tree's totalCount is a multiple of 2
    /// and the values at positions n/2 and n/2 + 1 (starting with 1) differ. Otherwise one value.
    /// Time complexity: *O(1)*
    public var medianValues: [T] {
        return medianIndex.medianNodes.map { $0.value }
    }
}

extension BSTree {

    // MARK: Traversal

    /// Return the elements of the tree in sorted order from first to last, according to the ordering
    /// given by the comparator, or by the '<' operator, which orders from min to max.
    /// Time complexity: *O(N)*
    /// - Returns: An array of elements
    public func traverseInOrder() -> [Element] {
        // Using next pointers (i.e. Collection) is faster than recursive BSNode traverseInOrder.
        var out = [Element]()
        for element in self { out.append(element) }
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
    public func traverseByLevel() -> [Element] {
        return root?.traverseLevel() ?? []
    }

    // MARK: Converting

    /// Returns an NSCountedSet with the same values and counts as the tree.
    /// - Returns: NSCountedSet
    public func toCountedSet() -> NSCountedSet {
        let set = NSCountedSet()
        for elem in self {
            for _ in 0 ..< elem.count { set.add(elem.value) }
        }
        return set
    }

    /// Returns an array of the values in the tree, in order, and with duplicates, if there are any values with
    /// a count greater than one. The size of the array is equal to `totalCount`.
    /// - Returns: Sorted array of values
    public func toValueArray() -> [T] {
        var out = [T]()
        for elem in self {
            for _ in 0 ..< elem.count { out.append(elem.value) }
        }
        return out
    }

}

// MARK: Comparing

extension BSTree: Equatable {

    /// Returns true if the two trees have the same values and value counts. They don't necessarily need
    /// to have the same internal node structure.
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

// MARK: Tree Depictions

extension BSTree: CustomStringConvertible {

    /// An ASCII-graphics depiction of the tree.
    ///
    /// Example:
    ///```
    ///      __42_
    ///     /     \
    ///   13       70(2)
    ///  /  \
    /// 9    17
    ///```
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

// MARK: BidirectionalCollection

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

/// Non-numeric index type of BSTree.
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

extension BSTree where T: AdditiveArithmetic {

    private func ensureSumStorageInitialized() {
        if sumStorage == nil {
            sumStorage = T.zero
            for elem in self { addToSumStorage(elem.value, elem.count) }
        }
    }

    /// The sum of each value times its count. Time complexity: *O(1)*
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

    /// :nodoc:
    public func insert(_ val: T) {
        // Has to come before performInsertsion() so that sum is initialized correctly.
        addToSumStorage(val, 1)
        performInsertion(val, 1)
    }

    /// :nodoc:
    public func insert(_ vals: T...) {
        for val in vals {
            // Has to come before performInsertsion() so that sum is initialized correctly.
            addToSumStorage(val, 1)
            performInsertion(val, 1)
        }
    }

    /// :nodoc:
    public func insert(_ val: T, count: Int) {
        // Has to come before performInsertsion() so that sum is initialized correctly.
        addToSumStorage(val, count)
        performInsertion(val, count)
    }

    /// :nodoc:
    public func insertFrom<S>(_ vals: S) where S: Sequence, S.Element == T {
        for val in vals {
            // Has to come before performInsertsion() so that sum is initialized correctly.
            addToSumStorage(val, 1)
            performInsertion(val, 1)
        }
    }

    /// :nodoc:
    public func remove(_ val: T) {
        let numRemoved = performRemoval(val, 1)
        subtractFromSumStorage(val, numRemoved)
    }

    /// :nodoc:
    public func remove(_ vals: T...) {
        for val in vals {
            let numRemoved = performRemoval(val, 1)
            subtractFromSumStorage(val, numRemoved)
        }
    }

    /// :nodoc:
    public func remove(_ val: T, count: Int) {
        let numRemoved = performRemoval(val, count)
        subtractFromSumStorage(val, numRemoved)
    }

    /// :nodoc:
    public func remove<S>(_ vals: S) where S: Sequence, S.Element == T {
        for val in vals {
            let numRemoved = performRemoval(val, 1)
            subtractFromSumStorage(val, numRemoved)
        }
    }

    /// :nodoc:
    public func removeAll(_ val: T) {
        let numRemoved = performRemoval(val, Int.max)
        subtractFromSumStorage(val, numRemoved)
    }

    /// :nodoc:
    public func clear() {
        performClear()
        sumStorage = T.zero
    }

}

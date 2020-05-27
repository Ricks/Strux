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
/// with the same value, but values have counts associated with them. BSTree provides much the same
/// capabilities as Java's TreeSet, except that it is also counted, provides a running median, and, if the
/// values are numeric, provides a running sum.
///
/// The type of value being stored must be Comparable, or a comparator of type Ordered must
/// be supplied. The comparator can also be given to override a Comparable type's innate ordering (e.g. to make
/// the ordering of String values case insentitive). If a comparator isn't given, the ordering is from min
/// to max.
///
/// Insertions, deletions, and specific value queries (indexOf, containsValue, ceiling, floor, higher, lower)
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
/// let tree = BSTree(14, -2, 32, 14)  // Don't need comparator, because Int is Comparable
/// tree.insert(42, 2)                 // Insert 2 of value 42
/// tree.removeAll(14)                 // Remove both 14's
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
/// tree.indexOf(42)               // BSTreeIndex type
/// tree.containsValue(-2)         // true
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
/// ```
public class BSTree<T: Equatable>: NSCopying {
    public typealias Element = (value: T, count: Int)
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

    /// The root node of the tree, or nil if the tree is empty. The root node has the tree as parent, so
    /// that all the BSNodes of the tree have parents.
    var root: BSNode<T>? {
        get { return god.leftNode as? BSNode }
        set { god.leftNode = newValue }
    }

    private func initializeWithCountedSet(_ countedSet: NSCountedSet) {
         let values = countedSet.allObjects as! [T]
         for val in values {
             insert(val, countedSet.count(for: val))
         }
    }

    /// True if the tree is a valid binary search tree, meaning that the value of the root node is
    /// greater than the value of its left child, and less than that of its right child, and all
    /// subtrees meet the same requirement. Note that if only the public functions (insert and remove)
    /// are used to modify the tree, it should always be valid.
    var isValid: Bool {
        root?.isValid ?? true
    }

    /// True if the tree is balanced, meaning that the height of the left subtree of the root is no more
    /// than one different from the height of the right subtree, and all subtrees meet the same
    /// requirement. Note that if only the public functions (insert and remove) are used to modify the
    /// tree, it should always be balanced.
    var isBalanced: Bool {
        root?.isBalanced ?? true
    }

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

    /// Initialize with an unsorted array of values, which can contain duplicates, and a comparator
    /// (optional if T is Comparable).
    /// - Parameters:
    ///   - values: Array
    ///   - ordered: Ordered ((T, T) -> Bool)
    public convenience init(_ values: [T], ordered: @escaping Ordered<T>) {
        self.init(ordered: ordered)
        initializeWithCountedSet(NSCountedSet(array: values))
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

    // MARK: Traversal

    /// Return the elements of the tree in sorted order from first to last, according to the ordering
    /// given by the comparator, or by the '<' operator, which orders from min to max.
    /// Time complexity: *O(N)*
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
    public func traverseByLevel() -> [Element] {
        return root?.traverseLevel() ?? []
    }

    // MARK: Converting/Comparing

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

}

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
    ///    __42_
    ///   /     \
    /// 13       70(2)
    ///   \
    ///    17
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

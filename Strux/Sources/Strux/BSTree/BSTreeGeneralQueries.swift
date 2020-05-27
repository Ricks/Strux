//
//  BSTreeGeneralQueries.swift
//  
//
//  Created by Richard Clark on 5/26/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation

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

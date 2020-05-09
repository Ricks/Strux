//
//  BSTreeCollection.swift
//  DataStructures
//
//  Created by Richard Clark on 4/30/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation

extension BSTree: Collection {

    public var startIndex: Index { BSTreeIndex(node: minNode) }
    public var endIndex: Index { BSTreeIndex(node: nil) }

    public subscript(i: Index) -> Element {
        assert((startIndex..<endIndex).contains(i), "Index out of bounds")
        return (i.node!.value, Int(i.node!.valueCount))
    }

    public func index(after i: Index) -> Index {
        return BSTreeIndex(node: i.node?.next)
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

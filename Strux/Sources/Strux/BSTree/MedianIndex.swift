//
//  MedianIndex.swift
//  BSTree
//
//  Index used to keep track of the median value in the tree.
//
//  Created by Richard Clark on 5/24/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation

struct MedianIndex<T>: CustomStringConvertible {
    weak var node: BSNode<T>?
    var halfIndex = -1

    private mutating func setToNil() {
        node = nil
        halfIndex = -1
    }

    private var numHalves: Int {
        Int(node?.valueCount ?? 0) * 2
    }

    private mutating func moveToNext() {
        halfIndex -= numHalves
        node = node?.next
    }

    private mutating func moveToPrev() {
        node = node?.prev
        halfIndex += numHalves
    }

    private mutating func normalize() {
        while halfIndex >= numHalves && node?.next != nil { moveToNext() }
        while halfIndex < 0 && node?.prev != nil { moveToPrev() }
    }

    private mutating func denormalize() {
        if node?.next != nil { moveToNext() }
        else if node?.prev != nil { moveToPrev() }
        else { setToNil() }
    }

    mutating func setInitialNode(_ initialNode: BSNode<T>) {
        node = initialNode
        halfIndex = -1
    }

    mutating func aboutToRemoveNode(_ nodeToBeRemoved: BSNode<T>) {
        if nodeToBeRemoved === node { denormalize() }
    }

    mutating func updateAfterChange(of val: T, n: Int, ordered: Ordered<T>) {
        if let node = node {
            halfIndex += (ordered(val, node.value) ? -n : n)
            normalize()
        }
    }

    var medianNodes: [BSNode<T>] {
        var out = [BSNode<T>]()
        if let medianNode = node {
            out.append(medianNode)
            if halfIndex == numHalves - 1, let nextNode = medianNode.next {
                out.append(nextNode)
            }
        }
        return out
    }

    var description: String {
        "node = \(valOrNil(node?.value)), halfIndex = \(halfIndex)"
    }

}

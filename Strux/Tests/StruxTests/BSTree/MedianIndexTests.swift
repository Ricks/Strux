//
//  MedianIndexTests.swift
//  BSTree
//  
//
//  Created by Richard Clark on 5/25/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import XCTest
import Foundation
@testable import Strux

class MedianIndexTests: XCTestCase {

    func helperTestIndex(_ mIndex: MedianIndex<Int>,
                         _ expectedValue: Int,
                         _ expectedHalfIndex: Int) -> String? {
        let value = mIndex.node?.value
        if value != expectedValue || mIndex.halfIndex != expectedHalfIndex {
            let msg = "Expected median of val = \(expectedValue), halfOffsest = \(expectedHalfIndex), " +
                      "got val = \(valOrNil(value)), halfOffset = \(mIndex.halfIndex)"
            return msg
        }
        return nil
    }

    func helperTestMedianNodes(_ mIndex: MedianIndex<Int>, _ expectedMedianValues: [Int]) -> String? {
        let medianValues = mIndex.medianNodes.map { $0.value }
        if medianValues != expectedMedianValues {
            let msg = "Expected medianNodes of \(expectedMedianValues), got \(medianValues)"
            return msg
        }
        return nil
    }

    func test1() {
        let tree = BSTree(2)
        let ordered: Ordered<Int> = { $0 < $1 }
        var medianIndex = MedianIndex<Int>()
        medianIndex.setInitialNode(tree.root!)
        medianIndex.updateAfterChange(of: 2, n: 1, ordered: ordered)
        if let msg = helperTestIndex(medianIndex, 2, 0) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(medianIndex, [2]) {
            XCTFail(msg)
            print(tree)
        }

        tree.insert(2)
        medianIndex.updateAfterChange(of: 2, n: 1, ordered: ordered)
        if let msg = helperTestIndex(medianIndex, 2, 1) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(medianIndex, [2]) {
            XCTFail(msg)
            print(tree)
        }

        tree.remove(2)
        medianIndex.updateAfterChange(of: 2, n: -1, ordered: ordered)
        if let msg = helperTestIndex(medianIndex, 2, 0) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(medianIndex, [2]) {
            XCTFail(msg)
            print(tree)
        }

        tree.insert(4, 7)
        medianIndex.updateAfterChange(of: 4, n: 7, ordered: ordered)
        if let msg = helperTestIndex(medianIndex, 4, 5) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(medianIndex, [4]) {
            XCTFail(msg)
            print(tree)
        }

        tree.insert(7, 7)
        medianIndex.updateAfterChange(of: 7, n: 7, ordered: ordered)
        if let msg = helperTestIndex(medianIndex, 4, 12) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(medianIndex, [4]) {
            XCTFail(msg)
            print(tree)
        }

        tree.remove(4, 6)
        medianIndex.updateAfterChange(of: 4, n: -6, ordered: ordered)
        if let msg = helperTestIndex(medianIndex, 7, 4) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(medianIndex, [7]) {
            XCTFail(msg)
            print(tree)
        }
    }

    func test2() {
        let tree = BSTree<Int>()
        let ordered: Ordered<Int> = { $0 < $1 }
        var medianIndex = MedianIndex<Int>()

        tree.insert(2, 6)
        medianIndex.setInitialNode(tree.root!)
        medianIndex.updateAfterChange(of: 2, n: 6, ordered: ordered)
        if let msg = helperTestIndex(medianIndex, 2, 5) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(medianIndex, [2]) {
            XCTFail(msg)
            print(tree)
        }

        tree.insert(4, 7)
        medianIndex.updateAfterChange(of: 4, n: 7, ordered: ordered)
        if let msg = helperTestIndex(medianIndex, 4, 0) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(medianIndex, [4]) {
            XCTFail(msg)
            print(tree)
        }

        tree.remove(4, 6)
        medianIndex.updateAfterChange(of: 4, n: -6, ordered: ordered)
        if let msg = helperTestIndex(medianIndex, 2, 6) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(medianIndex, [2]) {
            XCTFail(msg)
            print(tree)
        }
    }

    func test3() {
        let tree = BSTree<Int>()
        let ordered: Ordered<Int> = { $0 < $1 }
        var medianIndex = MedianIndex<Int>()

        tree.insert(4, 7)
        medianIndex.setInitialNode(tree.root!)
        medianIndex.updateAfterChange(of: 4, n: 7, ordered: ordered)
        tree.insert(2, 3)
        medianIndex.updateAfterChange(of: 2, n: 3, ordered: ordered)
        tree.insert(7, 3)
        medianIndex.updateAfterChange(of: 7, n: 3, ordered: ordered)
        if let msg = helperTestIndex(medianIndex, 4, 6) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(medianIndex, [4]) {
            XCTFail(msg)
            print(tree)
        }

        tree.remove(4, 6)
        medianIndex.updateAfterChange(of: 4, n: -6, ordered: ordered)
        if let msg = helperTestIndex(medianIndex, 4, 0) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(medianIndex, [4]) {
            XCTFail(msg)
            print(tree)
        }
    }

    func test4() {
        let tree = BSTree<Int>()
        let ordered: Ordered<Int> = { $0 < $1 }
        var medianIndex = MedianIndex<Int>()

        tree.insert(4, 7)
        medianIndex.setInitialNode(tree.root!)
        medianIndex.updateAfterChange(of: 4, n: 7, ordered: ordered)
        tree.insert(2, 7)
        medianIndex.updateAfterChange(of: 2, n: 7, ordered: ordered)
        if let msg = helperTestIndex(medianIndex, 2, 13) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(medianIndex, [2, 4]) {
            XCTFail(msg)
            print(tree)
        }
    }

}

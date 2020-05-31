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
                         _ expectedValue: Int?,
                         _ expectedHalfIndex: Int) -> String? {
        let value = mIndex.node?.value
        if value != expectedValue || mIndex.halfIndex != expectedHalfIndex {
            let msg = "Expected median of val = \(valOrNil(expectedValue)), halfOffsest = \(expectedHalfIndex), " +
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
        if let msg = helperTestIndex(tree.medianIndex, 2, 0) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(tree.medianIndex, [2]) {
            XCTFail(msg)
            print(tree)
        }

        tree.insert(2)
        if let msg = helperTestIndex(tree.medianIndex, 2, 1) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(tree.medianIndex, [2]) {
            XCTFail(msg)
            print(tree)
        }

        tree.remove(2)
        if let msg = helperTestIndex(tree.medianIndex, 2, 0) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(tree.medianIndex, [2]) {
            XCTFail(msg)
            print(tree)
        }

        tree.insert(4, count: 7)
        if let msg = helperTestIndex(tree.medianIndex, 4, 5) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(tree.medianIndex, [4]) {
            XCTFail(msg)
            print(tree)
        }

        tree.insert(7, count: 7)
        if let msg = helperTestIndex(tree.medianIndex, 4, 12) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(tree.medianIndex, [4]) {
            XCTFail(msg)
            print(tree)
        }

        tree.remove(4, count: 6)
        if let msg = helperTestIndex(tree.medianIndex, 7, 4) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(tree.medianIndex, [7]) {
            XCTFail(msg)
            print(tree)
        }
    }

    func test2() {
        let tree = BSTree<Int>()

        tree.insert(2, count: 6)
        if let msg = helperTestIndex(tree.medianIndex, 2, 5) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(tree.medianIndex, [2]) {
            XCTFail(msg)
            print(tree)
        }

        tree.insert(4, count: 7)
        if let msg = helperTestIndex(tree.medianIndex, 4, 0) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(tree.medianIndex, [4]) {
            XCTFail(msg)
            print(tree)
        }

        tree.remove(4, count: 6)
       if let msg = helperTestIndex(tree.medianIndex, 2, 6) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(tree.medianIndex, [2]) {
            XCTFail(msg)
            print(tree)
        }
    }

    func test3() {
        let tree = BSTree<Int>()

        tree.insert(4, count: 7)
        tree.insert(2, count: 3)
        tree.insert(7, count: 3)
        if let msg = helperTestIndex(tree.medianIndex, 4, 6) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(tree.medianIndex, [4]) {
            XCTFail(msg)
            print(tree)
        }

        tree.remove(4, count: 6)
        if let msg = helperTestIndex(tree.medianIndex, 4, 0) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(tree.medianIndex, [4]) {
            XCTFail(msg)
            print(tree)
        }
    }

    func test4() {
        let tree = BSTree<Int>()

        tree.insert(4, count: 7)
        tree.insert(2, count: 7)
        if let msg = helperTestIndex(tree.medianIndex, 2, 13) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(tree.medianIndex, [2, 4]) {
            XCTFail(msg)
            print(tree)
        }
    }

    func testDeleteNode() {
        let tree = BSTree(2)
        if let msg = helperTestIndex(tree.medianIndex, 2, 0) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(tree.medianIndex, [2]) {
            XCTFail(msg)
            print(tree)
        }

        tree.insert(2)
        print(tree)
        print("")
        if let msg = helperTestIndex(tree.medianIndex, 2, 1) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(tree.medianIndex, [2]) {
            XCTFail(msg)
            print(tree)
        }

        tree.remove(2)
        print(tree)
        print("")
        if let msg = helperTestIndex(tree.medianIndex, 2, 0) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(tree.medianIndex, [2]) {
            XCTFail(msg)
            print(tree)
        }

        tree.insert(4, count: 7)
        print(tree)
        print("")
        if let msg = helperTestIndex(tree.medianIndex, 4, 5) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(tree.medianIndex, [4]) {
            XCTFail(msg)
            print(tree)
        }

        tree.insert(7, count: 7)
        print(tree)
        print("")
        if let msg = helperTestIndex(tree.medianIndex, 4, 12) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(tree.medianIndex, [4]) {
            XCTFail(msg)
            print(tree)
        }

        tree.remove(4, count: 7)
        print(tree)
        print("")
        if let msg = helperTestIndex(tree.medianIndex, 7, 5) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(tree.medianIndex, [7]) {
            XCTFail(msg)
            print(tree)
        }
    }

    func testDeleteNode2() {
        let tree = BSTree<Int>()
        XCTAssertEqual(tree.medianIndex.description, "node = nil, halfIndex = -1")
        tree.insert(2)
        if let msg = helperTestIndex(tree.medianIndex, 2, 0) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(tree.medianIndex, [2]) {
            XCTFail(msg)
            print(tree)
        }

        tree.insert(2)
        print(tree)
        print("")
        if let msg = helperTestIndex(tree.medianIndex, 2, 1) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(tree.medianIndex, [2]) {
            XCTFail(msg)
            print(tree)
        }

        tree.remove(2, count: 2)
        print(tree)
        print("")
        if let msg = helperTestIndex(tree.medianIndex, nil, -1) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(tree.medianIndex, []) {
            XCTFail(msg)
            print(tree)
        }

        tree.insert(4, count: 7)
        print(tree)
        print("")
        if let msg = helperTestIndex(tree.medianIndex, 4, 6) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(tree.medianIndex, [4]) {
            XCTFail(msg)
            print(tree)
        }

        tree.insert(7, count: 7)
        print(tree)
        print("")
        if let msg = helperTestIndex(tree.medianIndex, 4, 13) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(tree.medianIndex, [4, 7]) {
            XCTFail(msg)
            print(tree)
        }

        tree.remove(4, count: 7)
        print(tree)
        print("")
        if let msg = helperTestIndex(tree.medianIndex, 7, 6) {
            XCTFail(msg)
            print(tree)
        }
        if let msg = helperTestMedianNodes(tree.medianIndex, [7]) {
            XCTFail(msg)
            print(tree)
        }
        XCTAssertEqual(tree.medianIndex.description, "node = 7, halfIndex = 6")
    }

}

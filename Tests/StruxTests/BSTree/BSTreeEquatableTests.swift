//
//  BSTreeEquatableTests.swift
//  StruxTests
//
//  Created by Richard Clark on 5/3/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation

import XCTest
import Foundation
@testable import Strux

let numTestTrees = 100

class BSTreeEquatableTests: XCTestCase {

    func testRandom() {
        setSeed(44)
        for _ in 0 ..< 10 {
            print(seededRandom(in: 1 ..< 5))
        }
    }

    func testEquatable() {
        for treeIndex in 0 ..< numTestTrees {
            print(treeIndex)
            var toInsert1 = [Int]()
            for _ in 0 ..< 1000 {
                toInsert1.append(seededRandom(in: -10..<10))
            }
            let toInsert2 = toInsert1.shuffled()
            var toRemove1 = [Int]()
            for _ in 0 ..< 100 {
                toRemove1.append(seededRandom(in: -10..<10))
            }
            let toRemove2 = toRemove1.shuffled()
            let tree1 = BSTree<Int>()
            let tree2 = BSTree<Int>()
            for i in 0..<toInsert1.count {
                tree1.insert(toInsert1[i])
                tree2.insert(toInsert2[i])
            }
            for i in 0..<toRemove1.count {
                tree1.remove(toRemove1[i])
                tree2.remove(toRemove2[i])
            }
            validateTree(tree1, "tree1 \(treeIndex)")
            validateTree(tree2, "tree1 \(treeIndex)")
            if tree1 != tree2 {
                XCTFail("tree1 != tree2 for index \(treeIndex)")
                print("tree1\n\(tree1)")
                print("tree2\n\(tree2)")
            }
        }
    }

    func testEquatable2() {
        let tree1 = BSTree(0, 9, 6, -3, 2)
        let tree2 = BSTree(0, 9, 6, -3, 2, 42)
        let tree3 = BSTree(0, 9, 6, -3, 11)
        XCTAssertNotEqual(tree1, tree2)
        XCTAssertNotEqual(tree1, tree3)
    }

}

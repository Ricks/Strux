//
//  BSNodeModifyTests.swift
//  DataStructures
//
//  Created by Richard Clark on 4/27/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import XCTest
import Foundation
@testable import Strux

class BSNodeModifyTests: XCTestCase {

    func testInsertDelete() {
        setSeed(5)
        (0..<100).forEach { treeIndex in
            print("Tree \(treeIndex) ...")
            let initialValues = [44, -12, 3]
            let set = NSCountedSet(array: initialValues)
            let treeSizish = seededRandom(in: 0..<1000)
            let tree = BSTree(initialValues)
            (0..<treeSizish).forEach { _ in
                let val = seededRandom(in: -5..<100)
                let count = seededRandom(in: 1..<4)
                let choice = seededRandom(in: 0..<10)
                switch choice {
                case 0:
                    tree.deleteAll(val)
                    let n = set.count(for: val)
                    for _ in 0 ..< n { set.remove(val) }
                case 1:
                    tree.delete(val)
                    set.remove(val)
                case 2:
                    tree.delete(val, count)
                    for _ in 0 ..< count { set.remove(val) }
                default:
                    if count == 1 {
                        tree.insert(val)
                    } else {
                        tree.insert(val, count)
                    }
                    for _ in 0 ..< count { set.add(val) }
                }
                validateTree(tree, "Tree \(treeIndex)")
                if tree.toCountedSet() != set {
                    XCTFail("Tree \(treeIndex) has counts \(tree.toCountedSet()), expected \(set)")
                }
                for val in set {
                    let intVal = val as! Int
                    XCTAssertEqual(tree.count(of: intVal), set.count(for: intVal))
                }
                let vals = (set.allObjects as! [Int]).sorted()
                XCTAssertEqual(tree.count, vals.count)
                let treeElements = tree.traverseInOrder()
                XCTAssertEqual(treeElements.count, vals.count)
                for i in 0..<vals.count {
                    XCTAssertEqual(treeElements[i].value, vals[i])
                    XCTAssertEqual(treeElements[i].count, set.count(for: vals[i]))
                }
                if tree.minimum?.value != vals.min() {
                    XCTFail("Tree \(treeIndex) has min value of \(valOrNil(tree.minimum?.value)), " +
                        "expected \(valOrNil(vals.min()))")
                    print(tree)
                }
                if tree.maximum?.value != vals.max() {
                    XCTFail("Tree \(treeIndex) has max value of \(valOrNil(tree.maximum?.value)), " +
                        "expected \(valOrNil(vals.max()))")
                    print(tree)
                }
            }
        }
    }

    func testInsertZero() {
        let tree: BSTree = [4, -9, 12, 3, 0, 65, -20, 4, 6]
        let node6 = tree.root!.right!
        node6.insert(13, 0)
    }

    func testDeleteMoreThanThereAre() {
        let tree = BSTree<Int>()
        tree.insert(2)
        tree.insert(42, 4)
        XCTAssertEqual(tree.count, 2)
        XCTAssertEqual(tree.totalCount, 5)
        tree.delete(42, 5)
        XCTAssertEqual(tree.count, 1)
        XCTAssertEqual(tree.totalCount, 1)
    }
}

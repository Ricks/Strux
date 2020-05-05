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
//                    print("deleteAll \(val)")
                    tree.deleteAll(val)
                    let n = set.count(for: val)
                    for _ in 0 ..< n { set.remove(val) }
                case 1:
//                    print("delete \(val)")
                    tree.delete(val)
                    set.remove(val)
                case 2:
//                    print("delete \(val)(\(count))")
                    tree.delete(val, count)
                    for _ in 0 ..< count { set.remove(val) }
                default:
                    if count == 1 {
//                        print("insert \(val)")
                        tree.insert(val)
                    } else {
//                        print("insert \(val)(\(count))")
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
                if tree.min?.value != vals.min() {
                    XCTFail("Tree \(treeIndex) has min value of \(valOrNil(tree.min?.value)), " +
                        "expected \(valOrNil(vals.min()))")
                    print(tree)
                }
                if tree.max?.value != vals.max() {
                    XCTFail("Tree \(treeIndex) has max value of \(valOrNil(tree.max?.value)), " +
                        "expected \(valOrNil(vals.max()))")
                    print(tree)
                }
            }
        }
    }

}

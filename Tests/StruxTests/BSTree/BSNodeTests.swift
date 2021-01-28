//
//  BSNodeTests.swift
//  StruxTests
//  
//  Created by Richard Clark on 5/14/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation

import XCTest
import Foundation
@testable import Strux

class BSNodeTests: XCTestCase {

    func testSwap() {
        let god = BNode()
        let ordered = { (a: Int, b: Int) -> Bool in a < b }
        let node42 = BSNode(42, ordered: ordered, parent: god, direction: .left)
        var root = node42
        let node52 = BSNode(52, ordered: ordered, parent: root, direction: .right)
        let node51 = BSNode(51, ordered: ordered, parent: node52, direction: .left)
        let node50 = BSNode(50, ordered: ordered, parent: node51, direction: .left)
        let node66 = BSNode(66, ordered: ordered, parent: node52, direction: .right)
        root.next = node50
        node50.next = node51
        node51.next = node52
        node52.next = node66
        print("")
        print(root.descriptionWithNext)
        node66.swap(with: node52)
        print("")
        print(root.descriptionWithNext)
        node66.swap(with: node42)
        root = node66
        print("")
        print(root.descriptionWithNext)
        node50.swap(with: node51)
        print("")
        print(root.descriptionWithNext)
        node50.swap(with: node42)
        print("")
        print(root.descriptionWithNext)
        node50.swap(with: node66)
        root = node50
        print("")
        print(root.descriptionWithNext)
    }

    func testFindCeiling() {
        let tree = BSTree(1, 2, 4, 6, 9, 15, 22, -1)
        guard let root = tree.root else {
            XCTFail()
            return
        }
        print(tree)
        XCTAssertEqual(root.findCeiling(-2)?.value, -1)
        XCTAssertEqual(root.findCeiling(-1)?.value, -1)
        XCTAssertEqual(root.findCeiling(0)?.value, 1)
        XCTAssertEqual(root.findCeiling(1)?.value, 1)
        XCTAssertEqual(root.findCeiling(2)?.value, 2)
        XCTAssertEqual(root.findCeiling(3)?.value, 4)
        XCTAssertEqual(root.findCeiling(5)?.value, 6)
        XCTAssertEqual(root.findCeiling(14)?.value, 15)
        XCTAssertEqual(root.findCeiling(15)?.value, 15)
        XCTAssertEqual(root.findCeiling(22)?.value, 22)
        XCTAssertNil(root.findCeiling(23))
    }

    func testFindCeilingMonkey() {
        setSeed(5)
        (0 ..< numTestTrees).forEach { treeIndex in
            print("Tree \(treeIndex) ...")
            let treeSizish = seededRandom(in: 0 ..< 1000)
            let tree = BSTree<Int>()
            (0..<treeSizish).forEach { _ in
                let val = seededRandom(in: -5 ..< 100)
                let count = seededRandom(in: 1 ..< 4)
                tree.insert(val, count: count)
                guard let root = tree.root else { XCTFail(); return }
                var lastVal: Int?
                for (val, _) in tree {
                    var lookingFor: Int
                    let expecting = val
                    if lastVal == nil {
                        lookingFor = val - 1
                    } else {
                        lookingFor = (val + lastVal! + 1) / 2
                    }
                    let found = root.findCeiling(lookingFor)?.value
                    if found != expecting {
                        XCTFail("Looking for \(lookingFor), expected \(expecting), got \(valOrNil(found)), val = \(val), lastVal = \(valOrNil(lastVal))")
                        print(tree)
                        exit(1)
                    }
                    lastVal = val
                }
                if lastVal != nil {
                    XCTAssertNil(root.findCeiling(lastVal! + 1))
                }
            }
        }
    }
}

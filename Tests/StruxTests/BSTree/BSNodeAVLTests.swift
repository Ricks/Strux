//
//  BSNodeAVLTests.swift
//  StruxTests
//
//  Created by Richard Clark on 4/25/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import XCTest
import Foundation
@testable import Strux

extension BSNode {

    func equal(_ val1: T, _ val2: T) -> Bool {
        return !ordered(val1, val2) && !ordered(val2, val1)
    }

    private func isNextCorrectHelper() -> Bool {
        if let pred = inOrderPredecessor {
            if pred.next !== self {
                return false
            }
        }
        if next !== inOrderSuccessor {
            return false
        }
        if let thisLeft = left {
            if !thisLeft.isNextCorrectHelper() {
                return false
            }
        }
        if let thisRight = right {
            if !thisRight.isNextCorrectHelper() {
                return false
            }
        }
        return true
    }

    var isNextCorrect: Bool {
        if !isNextCorrectHelper() {
            return false
        }
        var elems1 = [Element]()
        var node: BSNode<T>? = firstNode
        while let thisNode = node {
            elems1.append((thisNode.value, Int(thisNode.valueCount)))
            node = thisNode.next
        }
        let elems2 = traverseInOrder()
        if elems1.count != elems2.count {
            return false
        }
        for i in 0 ..< elems1.count {
            if !(equal(elems1[i].value, elems2[i].value) && elems1[i].count == elems2[i].count) {
                return false
            }
        }
        return true
    }

    private func isPrevCorrectHelper() -> Bool {
        if let next = inOrderSuccessor {
            if next.prev !== self {
                return false
            }
        }
        if prev !== inOrderPredecessor {
            return false
        }
        if let thisLeft = left {
            if !thisLeft.isPrevCorrectHelper() {
                return false
            }
        }
        if let thisRight = right {
            if !thisRight.isPrevCorrectHelper() {
                return false
            }
        }
        return true
    }

    var isPrevCorrect: Bool {
        if !isPrevCorrectHelper() {
            return false
        }
        var elems1 = [Element]()
        var node: BSNode<T>? = lastNode
        while let thisNode = node {
            elems1.append((thisNode.value, Int(thisNode.valueCount)))
            node = thisNode.prev
        }
        let elems2 = Array(traverseInOrder().reversed())
        if elems1.count != elems2.count {
            return false
        }
        for i in 0 ..< elems1.count {
            if !(equal(elems1[i].value, elems2[i].value) && elems1[i].count == elems2[i].count) {
                return false
            }
        }
        return true
    }

    var isHeightCorrect: Bool {
        let lh = left?.height ?? -1
        let rh = right?.height ?? -1
        let lihc = left?.isHeightCorrect ?? true
        let rihc = right?.isHeightCorrect ?? true
        return (height == max(lh, rh) + 1) && lihc && rihc
    }

}

func dumpNextPointers<T>(_ tree: BSTree<T>) {
    let elems1 = tree.root?.traverseInOrder() ?? []
    print("traverseInOrder:")
    for elem in elems1 { print(elem.value, terminator: " ") }

    var elems2 = [BSNode<T>.Element]()
    var node: BSNode<T>? = tree.root?.firstNode
    while let thisNode = node {
        elems2.append((thisNode.value, Int(thisNode.valueCount)))
        node = thisNode.next
    }
    print("\nnext:")
    for elem in elems2 { print(elem.value, terminator: " ") }
    print("")

    print("\npredecessors and successors")
    let nodes: [BSNode] = tree.root?.traverseInOrderNodes() ?? []
    for node in nodes {
        print("\(node.value):", terminator: " ")
        print("\(valOrNil(node.inOrderPredecessor?.value))", terminator: " ")
        print("\(valOrNil(node.inOrderSuccessor?.value))")
    }
}

func validateTree(_ tree: BSTree<Int>, _ id: String) {
    if !tree.isValid {
        XCTFail("\(id) is not a valid BST")
        print(tree)
    }
    if !tree.isBalanced {
        XCTFail("\(id) is not balanced")
        print(tree)
    }
    if let root = tree.root, !root.isHeightCorrect {
        XCTFail("\(id) has incorrect height")
        print(tree.descriptionWithHeight)
    }
    if let root = tree.root, !root.isNextCorrect {
        XCTFail("\(id) has incorrect next pointers")
        print(tree.descriptionWithNext)
        dumpNextPointers(tree)
    }
    if let root = tree.root, !root.isPrevCorrect {
        XCTFail("\(id) has incorrect prev pointers")
        print(tree.descriptionWithNext)
        dumpNextPointers(tree)
    }
    let expectedCount = tree.root?.nodeCount ?? 0
    if expectedCount != tree.count {
        XCTFail("\(id) has count of \(tree.count), expected \(expectedCount)")
        print(tree.description)
    }
    let expectedTotalCount = tree.reduce(0) { $0 + $1.count }
    if expectedTotalCount != tree.totalCount {
        XCTFail("\(id) has totalCount of \(tree.totalCount), expected \(expectedTotalCount)")
        print(tree.description)
    }
    let array = tree.toValueArray()
    let expectedSum = array.reduce(0, +)
    if expectedSum != tree.sum {
        XCTFail("\(id) has sum of \(tree.sum), expected \(expectedSum)")
        print(tree.descriptionWithTotalCount)
    }
    var expectedMedians = [Int]()
    if array.count > 0 {
        let medianIndex = (array.count + 1) / 2 - 1
        expectedMedians.append(array[medianIndex])
        if array.count % 2 == 0 && array[medianIndex + 1] != array[medianIndex] {
            expectedMedians.append(array[medianIndex + 1])
        }
    }
    if expectedMedians != tree.medianValues {
        XCTFail("\(id) has medianValues of \(tree.medianValues), expected \(expectedMedians), " +
            "totalCount = \(tree.totalCount)")
        print(tree.descriptionWithTotalCount)
    }
}

class BSNodeAVLTests: XCTestCase {

    func checkDesc(_ desc: String, _ expected: String) {
        if desc != expected {
            XCTFail("\n\nExpected:\n\(expected)\n\nGot:\n\(desc)")
        }
    }

    //         42                70
    //           \     --->     /
    //   nodeB -> 70          42
    func testRotateLeftNodeBisLeaf() {
        let god = BNode()
        let ordered = { (a: Int, b: Int) -> Bool in a < b }
        var root = BSNode(42, ordered: ordered, parent: god, direction: .left)
        root.insert(70, 1)
        var expectedRootDescrip = "42   \n" +
            "  \\  \n" +
        "   70"
        checkDesc(root.description, expectedRootDescrip)
        XCTAssertTrue(root.isHeightCorrect)

        root.rotateLeft()

        expectedRootDescrip = "   70\n" +
            "  /  \n" +
        "42   "
        root = god.leftNode as! BSNode
        checkDesc(root.description, expectedRootDescrip)
        XCTAssertTrue(root.isHeightCorrect)
    }

    //         42
    //           \                  70
    //   nodeB -> 70      --->     /  \
    //              \            42    99
    //               99
    func testRotateLeftNodeBHasRightChild() {
        let god = BNode()
        let ordered = { (a: Int, b: Int) -> Bool in a < b }
        var root = BSNode(42, ordered: ordered, parent: god, direction: .left)
        root.height = 2
        let node70 = BSNode(70, ordered: ordered, parent: root, direction: .right)
        node70.height = 1
        _ = BSNode(99, ordered: ordered, parent: node70, direction: .right)
        var expectedRootDescrip = "42      \n" +
            "  \\     \n" +
            "   70   \n" +
            "     \\  \n" +
        "      99"
        checkDesc(root.description, expectedRootDescrip)
        XCTAssertTrue(root.isHeightCorrect)

        root.rotateLeft()

        expectedRootDescrip = "   70   \n" +
            "  /  \\  \n" +
        "42    99"
        root = god.leftNode as! BSNode
        checkDesc(root.description, expectedRootDescrip)
        XCTAssertTrue(root.isHeightCorrect)
    }

    //         42
    //           \                  66
    //   nodeB -> 70      --->     /  \
    //           /               42    70
    //         66
    func testRotateLeftNodeBHasLeftChild() {
        let god = BNode()
        let ordered = { (a: Int, b: Int) -> Bool in a < b }
        var root = BSNode(42, ordered: ordered, parent: god, direction: .left)
        root.height = 2
        let node70 = BSNode(70, ordered: ordered, parent: root, direction: .right)
        node70.height = 1
        _ = BSNode(66, ordered: ordered, parent: node70, direction: .left)
        var expectedRootDescrip = "42   \n" +
            "  \\  \n" +
            "   70\n" +
            "  /  \n" +
        "66   "
        checkDesc(root.description, expectedRootDescrip)
        XCTAssertTrue(root.isHeightCorrect)

        root.rotateLeft()

        expectedRootDescrip = "   66   \n" +
            "  /  \\  \n" +
        "42    70"
        root = god.leftNode as! BSNode
        checkDesc(root.description, expectedRootDescrip)
        XCTAssertTrue(root.isHeightCorrect)
    }

    //         42                   __70_
    //           \                 /     \
    //   nodeB -> 70      --->   42       99
    //           /  \              \
    //         66    99             66
    func testRotateLeftNodeBHasTwoChildren() {
        let god = BNode()
        let ordered = { (a: Int, b: Int) -> Bool in a < b }
        var root = BSNode(42, ordered: ordered, parent: god, direction: .left)
        root.height = 2
        let node70 = BSNode(70, ordered: ordered, parent: root, direction: .right)
        node70.height = 1
        _ = BSNode(66, ordered: ordered, parent: node70, direction: .left)
        _ = BSNode(99, ordered: ordered, parent: node70, direction: .right)
        var expectedRootDescrip = "42      \n" +
            "  \\     \n" +
            "   70   \n" +
            "  /  \\  \n" +
        "66    99"
        checkDesc(root.description, expectedRootDescrip)
        XCTAssertTrue(root.isHeightCorrect)

        root.rotateLeft()

        expectedRootDescrip = "   __70_   \n" +
            "  /     \\  \n" +
            "42       99\n" +
            "  \\        \n" +
        "   66      "
        root = god.leftNode as! BSNode
        checkDesc(root.description, expectedRootDescrip)
        XCTAssertTrue(root.isHeightCorrect)
    }

    //               42          16
    //              /     --->     \
    //   nodeB -> 16                42
    func testRotateRightNodeBisLeaf() {
        let god = BNode()
        let ordered = { (a: Int, b: Int) -> Bool in a < b }
        var root = BSNode(42, ordered: ordered, parent: god, direction: .left)
        root.insert(16, 1)
        var expectedRootDescrip = "   42\n" +
            "  /  \n" +
        "16   "
        checkDesc(root.description, expectedRootDescrip)
        XCTAssertTrue(root.isHeightCorrect)

        root.rotateRight()

        expectedRootDescrip = "16   \n" +
            "  \\  \n" +
        "   42"
        root = god.leftNode as! BSNode
        checkDesc(root.description, expectedRootDescrip)
        XCTAssertTrue(root.isHeightCorrect)
    }

    //               42
    //              /               16
    //   nodeB -> 16      --->     /  \
    //           /                8    42
    //          8
    func testRotateRightNodeBHasRightChild() {
        let god = BNode()
        let ordered = { (a: Int, b: Int) -> Bool in a < b }
        var root = BSNode(42, ordered: ordered, parent: god, direction: .left)
        root.height = 2
        let node16 = BSNode(16, ordered: ordered, parent: root, direction: .left)
        node16.height = 1
        _ = BSNode(8, ordered: ordered, parent: node16, direction: .left)
        var expectedRootDescrip = "     42\n" +
            "    /  \n" +
            "  16   \n" +
            " /     \n" +
        "8      "
        checkDesc(root.description, expectedRootDescrip)
        XCTAssertTrue(root.isHeightCorrect)

        root.rotateRight()

        expectedRootDescrip = "  16   \n" +
            " /  \\  \n" +
        "8    42"
        root = god.leftNode as! BSNode
        checkDesc(root.description, expectedRootDescrip)
        XCTAssertTrue(root.isHeightCorrect)
    }

    //               42
    //              /               29
    //   nodeB -> 16      --->     /  \
    //              \            16    42
    //               29
    func testRotateRightNodeBHasLeftChild() {
        let god = BNode()
        let ordered = { (a: Int, b: Int) -> Bool in a < b }
        var root = BSNode(42, ordered: ordered, parent: god, direction: .left)
        root.height = 2
        let node16 = BSNode(16, ordered: ordered, parent: root, direction: .left)
        node16.height = 1
        _ = BSNode(29, ordered: ordered, parent: node16, direction: .right)
        var expectedRootDescrip = "   42\n" +
            "  /  \n" +
            "16   \n" +
            "  \\  \n" +
        "   29"
        checkDesc(root.description, expectedRootDescrip)
        XCTAssertTrue(root.isHeightCorrect)

        root.rotateRight()

        expectedRootDescrip = "   29   \n" +
            "  /  \\  \n" +
        "16    42"
        root = god.leftNode as! BSNode
        checkDesc(root.description, expectedRootDescrip)
        XCTAssertTrue(root.isHeightCorrect)
    }

    //               42                _16__
    //              /                 /     \
    //   nodeB -> 16      --->       8       42
    //           /  \                       /
    //          8    29                   29
    func testRotateRightNodeBHasTwoChildren() {
        let god = BNode()
        let ordered = { (a: Int, b: Int) -> Bool in a < b }
        var root = BSNode(42, ordered: ordered, parent: god, direction: .left)
        root.height = 2
        let node16 = BSNode(16, ordered: ordered, parent: root, direction: .left)
        node16.height = 1
        _ = BSNode(8, ordered: ordered, parent: node16, direction: .left)
        _ = BSNode(29, ordered: ordered, parent: node16, direction: .right)
        var expectedRootDescrip = "     42\n" +
            "    /  \n" +
            "  16   \n" +
            " /  \\  \n" +
        "8    29"
        checkDesc(root.description, expectedRootDescrip)
        XCTAssertTrue(root.isHeightCorrect)

        root.rotateRight()

        expectedRootDescrip = "  _16__   \n" +
            " /     \\  \n" +
            "8       42\n" +
            "       /  \n" +
        "     29   "
        root = god.leftNode as! BSNode
        checkDesc(root.description, expectedRootDescrip)
        XCTAssertTrue(root.isHeightCorrect)
    }

    func testRebalanceIfNecessary1() {
        let god = BNode()
        let ordered = { (a: Int, b: Int) -> Bool in a < b }
        var root = BSNode(42, ordered: ordered, parent: god, direction: .left)
        root.height = 5
        let node41 = BSNode(41, ordered: ordered, parent: root, direction: .left)
        node41.height = 4
        let node39 = BSNode(39, ordered: ordered, parent: node41, direction: .left)
        node39.height = 3
        let node34 = BSNode(34, ordered: ordered, parent: node39, direction: .left)
        node34.height = 2
        let node31 = BSNode(31, ordered: ordered, parent: node34, direction: .left)
        node31.height = 1
        let node22 = BSNode(22, ordered: ordered, parent: node31, direction: .left)
        node22.height = 0

        let expectedRootDescrip = "               42\n" +
            "              /  \n" +
            "            41   \n" +
            "           /     \n" +
            "         39      \n" +
            "        /        \n" +
            "      34         \n" +
            "     /           \n" +
            "   31            \n" +
            "  /              \n" +
        "22               "
        checkDesc(root.description, expectedRootDescrip)
        XCTAssertTrue(root.isHeightCorrect)

        node34.rebalanceIfNecessary()

        root = god.leftNode as! BSNode
        XCTAssertTrue(root.isHeightCorrect)
        XCTAssertTrue(root.isValid)
        print(root)
    }

    func testRebalanceIfNecessary2() {
        setSeed(5)
        (0..<numTestTrees).forEach { treeIndex in
            let treeSize = seededRandom(in: 0..<100)
            let tree = BSTree<Int>()
            (0..<treeSize).forEach { _ in
                tree.insert(seededRandom(in: 0..<100))
                validateTree(tree, "Tree \(treeIndex)")
            }
        }
    }

    func testRotateWrongNode() {
        let tree = BSTree(4, -9, 12, 3, 0, 65, -20, 4, 6)
        print(tree)
        let nodeMinus20 = tree.root!.find(-20)!
        nodeMinus20.rotateLeft()
        nodeMinus20.rotateRight()
    }
}

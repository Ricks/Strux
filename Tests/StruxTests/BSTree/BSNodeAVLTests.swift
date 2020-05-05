//
//  BSNodeAVLTests.swift
//  DataStructuresTests
//
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import XCTest
import Foundation
@testable import Strux

func setSeed(_ seed: Int) {
    srand48(seed)
}

func seededRandom(in range: Range<Int>) -> Int {
    let rand = Double(range.upperBound - range.lowerBound) * drand48()
    return min(range.upperBound - 1, Int(floor(rand)) + range.lowerBound)
}

func seededRandom(prob: Double) -> Bool {
    return drand48() < prob
}

func dumpNextPointers<T>(_ tree: BSTree<T>) {
    let elems1 = tree.root?.traverseInOrder() ?? []
    print("traverseInOrder:")
    for elem in elems1 { print(elem.value, terminator: " ") }

    var elems2 = [BSNode<T>.Element]()
    var node: BSNode<T>? = tree.root?.minNode
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

func validateTree<T: Comparable>(_ tree: BSTree<T>, _ id: String) {
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
    let expectedCount = tree.root?.nodeCount ?? 0
    if expectedCount != tree.count {
        XCTFail("\(id) has count of \(tree.count), expected \(expectedCount)")
        print(tree.description)
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
        var root = BSNode(42, parent: god, direction: .left)
        root.insert(70)
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
        var root = BSNode(42, parent: god, direction: .left)
        root.height = 2
        let node70 = BSNode(70, parent: root, direction: .right)
        node70.height = 1
        _ = BSNode(99, parent: node70, direction: .right)
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
        var root = BSNode(42, parent: god, direction: .left)
        root.height = 2
        let node70 = BSNode(70, parent: root, direction: .right)
        node70.height = 1
        _ = BSNode(66, parent: node70, direction: .left)
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
        var root = BSNode(42, parent: god, direction: .left)
        root.height = 2
        let node70 = BSNode(70, parent: root, direction: .right)
        node70.height = 1
        _ = BSNode(66, parent: node70, direction: .left)
        _ = BSNode(99, parent: node70, direction: .right)
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
        var root = BSNode(42, parent: god, direction: .left)
        root.insert(16)
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
        var root = BSNode(42, parent: god, direction: .left)
        root.height = 2
        let node16 = BSNode(16, parent: root, direction: .left)
        node16.height = 1
        _ = BSNode(8, parent: node16, direction: .left)
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
        var root = BSNode(42, parent: god, direction: .left)
        root.height = 2
        let node16 = BSNode(16, parent: root, direction: .left)
        node16.height = 1
        _ = BSNode(29, parent: node16, direction: .right)
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
        var root = BSNode(42, parent: god, direction: .left)
        root.height = 2
        let node16 = BSNode(16, parent: root, direction: .left)
        node16.height = 1
        _ = BSNode(8, parent: node16, direction: .left)
        _ = BSNode(29, parent: node16, direction: .right)
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
        var root = BSNode(42, parent: god, direction: .left)
        root.height = 5
        let node41 = BSNode(41, parent: root, direction: .left)
        node41.height = 4
        let node39 = BSNode(39, parent: node41, direction: .left)
        node39.height = 3
        let node34 = BSNode(34, parent: node39, direction: .left)
        node34.height = 2
        let node31 = BSNode(31, parent: node34, direction: .left)
        node31.height = 1
        let node22 = BSNode(22, parent: node31, direction: .left)
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
        (0..<100).forEach { treeIndex in
            let treeSize = seededRandom(in: 0..<100)
            let tree = BSTree<Int>()
            (0..<treeSize).forEach { _ in
                tree.insert(seededRandom(in: 0..<100))
                validateTree(tree, "Tree \(treeIndex)")
            }
        }
    }
}

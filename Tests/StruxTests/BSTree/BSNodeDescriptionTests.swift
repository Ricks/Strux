//
//  BSNodeDescriptionTests.swift
//  StruxTests
//
//  Created by Richard Clark on 4/25/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import XCTest
import Foundation
@testable import Strux

class BSNodeDescriptionTests: XCTestCase {

    func checkDesc(_ desc: String, _ expected: String) {
        if desc != expected {
            let expectedLines = expected.split(separator: "\n").map { $0 + "|" }
            let expectedTerminated = expectedLines.joined(separator: "\n")
            let descLines = desc.split(separator: "\n").map { $0 + "|" }
            let descTerminated = descLines.joined(separator: "\n")
            XCTFail("\n\nExpected:\n\(expectedTerminated)\n\nGot:\n\(descTerminated)")
        }
    }

    func testDescription1() {
        let god = BNode()
        let ordered = { (a: Int, b: Int) -> Bool in a < b }
        let root = BSNode(42, ordered: ordered, parent: god, direction: .left)
        let expectedRootDescrip = "42"
        XCTAssertEqual(root.description, expectedRootDescrip)
        root.insert(12, 1)
        let expectedRootDescrip2 = "   42\n" +
                                   "  /  \n" +
                                   "12   "
        checkDesc(root.description, expectedRootDescrip2)
    }

    func testDescription2() {
        let god = BNode()
        let ordered = { (a: Int, b: Int) -> Bool in a < b }
        let root = BSNode(42, ordered: ordered, parent: god, direction: .left)
        var expectedRootDescrip = "42"
        XCTAssertEqual(root.description, expectedRootDescrip)
        root.insert(70, 1)
        expectedRootDescrip = "42   \n" +
                              "  \\  \n" +
                              "   70"
        checkDesc(root.description, expectedRootDescrip)
        root.insert(13, 1)
        expectedRootDescrip = "   42   \n" +
                              "  /  \\  \n" +
                              "13    70"
        checkDesc(root.description, expectedRootDescrip)
        root.insert(17, 1)
        expectedRootDescrip = "   __42_   \n" +
                              "  /     \\  \n" +
                              "13       70\n" +
                              "  \\        \n" +
                              "   17      "
        print(root.description)
        checkDesc(root.description, expectedRootDescrip)
        root.insert(69, 1)
        expectedRootDescrip = "   ___42___   \n" +
                              "  /        \\  \n" +
                              "13          70\n" +
                              "  \\        /  \n" +
                              "   17    69   "
        checkDesc(root.description, expectedRootDescrip)
        root.insert(12, 1)
        expectedRootDescrip = "      ___42___   \n" +
                              "     /        \\  \n" +
                              "   13          70\n" +
                              "  /  \\        /  \n" +
                              "12    17    69   "
        checkDesc(root.description, expectedRootDescrip)
        root.insert(68, 1)
        expectedRootDescrip = "      ___42___      \n" +
                              "     /        \\     \n" +
                              "   13          69   \n" +
                              "  /  \\        /  \\  \n" +
                              "12    17    68    70"
        checkDesc(root.description, expectedRootDescrip)
    }

    func testDescription3() {
        let god = BNode()
        let ordered = { (a: Int, b: Int) -> Bool in a < b }
        let root = BSNode(42, ordered: ordered, parent: god, direction: .left)
        let node69 = BSNode(69, ordered: ordered, parent: root, direction: .right)
        _ = BSNode(68, ordered: ordered, parent: node69, direction: .left)
        _ = BSNode(70, ordered: ordered, parent: node69, direction: .right)
        let expectedRootDescrip = "42      \n" +
                                  "  \\     \n" +
                                  "   69   \n" +
                                  "  /  \\  \n" +
                                  "68    70"
        checkDesc(root.description, expectedRootDescrip)
    }

    func testDescription4() {
        let god = BNode()
        let ordered = { (a: Int, b: Int) -> Bool in a < b }
        let root = BSNode(142, ordered: ordered, parent: god, direction: .left)
        let node69 = BSNode(69, ordered: ordered, parent: root, direction: .right)
        _ = BSNode(68, ordered: ordered, parent: node69, direction: .left)
        _ = BSNode(70, ordered: ordered, parent: node69, direction: .right)
        let expectedRootDescrip = "142      \n" +
                                  "   \\     \n" +
                                  "    69   \n" +
                                  "   /  \\  \n" +
                                  " 68    70"
        checkDesc(root.description, expectedRootDescrip)
    }

    func testDescription5() {
        let god = BNode()
        let ordered = { (a: Int, b: Int) -> Bool in a < b }
        let root = BSNode(42, ordered: ordered, parent: god, direction: .left)
        let node69 = BSNode(69, ordered: ordered, parent: root, direction: .right)
        _ = BSNode(168, ordered: ordered, parent: node69, direction: .left)
        _ = BSNode(70, ordered: ordered, parent: node69, direction: .right)
        let expectedRootDescrip = " 42      \n" +
                                  "   \\     \n" +
                                  "    69   \n" +
                                  "   /  \\  \n" +
                                  "168    70"
        checkDesc(root.description, expectedRootDescrip)
    }

    func testDescription6() {
        let god = BNode()
        let ordered = { (a: Int, b: Int) -> Bool in a < b }
        let root = BSNode(42, ordered: ordered, parent: god, direction: .left)
        let node69 = BSNode(69, ordered: ordered, parent: root, direction: .left)
        _ = BSNode(68, ordered: ordered, parent: node69, direction: .left)
        _ = BSNode(70, ordered: ordered, parent: node69, direction: .right)
        let expectedRootDescrip = "      42\n" +
                                  "     /  \n" +
                                  "   69   \n" +
                                  "  /  \\  \n" +
                                  "68    70"
        checkDesc(root.description, expectedRootDescrip)
    }

    func testDescription7() {
        let god = BNode()
        let ordered = { (a: Int, b: Int) -> Bool in a < b }
        let root = BSNode(142, ordered: ordered, parent: god, direction: .left)
        let node69 = BSNode(69, ordered: ordered, parent: root, direction: .left)
        _ = BSNode(68, ordered: ordered, parent: node69, direction: .left)
        _ = BSNode(70, ordered: ordered, parent: node69, direction: .right)
        let expectedRootDescrip = "      142\n" +
                                  "     /   \n" +
                                  "   69    \n" +
                                  "  /  \\   \n" +
                                  "68    70 "
        checkDesc(root.description, expectedRootDescrip)
    }

    func testDescription8() {
        let god = BNode()
        let ordered = { (a: Int, b: Int) -> Bool in a < b }
        let root = BSNode(14, ordered: ordered, parent: god, direction: .left)
        let node69 = BSNode(69, ordered: ordered, parent: root, direction: .left)
        _ = BSNode(68, ordered: ordered, parent: node69, direction: .left)
        _ = BSNode(170, ordered: ordered, parent: node69, direction: .right)
        let expectedRootDescrip = "      14 \n" +
                                  "     /   \n" +
                                  "   69    \n" +
                                  "  /  \\   \n" +
                                  "68    170"
        checkDesc(root.description, expectedRootDescrip)
        let tree2 = BSTree<Int>()
        checkDesc(tree2.description, "")
    }

    func testDescriptionWithHeight() {
        let tree = BSTree(4, -9, 12, 3, 0, 65, -20, 4, 6)
        let expectedHeightDescription = "           _____0-3_____               \n" +
                                        "          /             \\              \n" +
                                        "      -9-1         ______6-2______     \n" +
                                        "     /            /               \\    \n" +
                                        "-20-0          3-1                 65-1\n" +
                                        "                  \\               /    \n" +
                                        "                   4(2)-0     12-0     "
        checkDesc(tree.descriptionWithHeight, expectedHeightDescription)
        let tree2 = BSTree<Int>()
        checkDesc(tree2.descriptionWithHeight, "")
    }

    func testDescriptionWithNext() {
        let tree = BSTree(4, -9, 12, 3, 0, 65, -20, 4, 6)
        let expectedNextDescription =
            "                        _________-9<-0->3__________                               \n" +
            "                       /                           \\                              \n" +
            "             -20<--9->0                  ___________4<-6->12__________            \n" +
            "            /                           /                             \\           \n" +
            "nil<--20->-9                     0<-3->4                               12<-65->nil\n" +
            "                                        \\                             /           \n" +
            "                                         3<-4(2)->6          6<-12->65            "
        checkDesc(tree.descriptionWithNext, expectedNextDescription)
        let tree2 = BSTree<Int>()
        checkDesc(tree2.descriptionWithNext, "")
    }

    func testDescriptionWithNodeCount() {
        let tree = BSTree(4, -9, 12, 3, 0, 65, -20, 4, 6)
        let expectedNodeCountDescription = "           _____0-8_____               \n" +
                                        "          /             \\              \n" +
                                        "      -9-2         ______6-5______     \n" +
                                        "     /            /               \\    \n" +
                                        "-20-1          3-2                 65-2\n" +
                                        "                  \\               /    \n" +
                                        "                   4(2)-1     12-1     "
        checkDesc(tree.descriptionWithNodeCount, expectedNodeCountDescription)
        let tree2 = BSTree<Int>()
        checkDesc(tree2.descriptionWithNodeCount, "")
    }

    func testDescriptionWithTotalCount() {
        let tree = BSTree(4, -9, 12, 3, 0, 65, -20, 4, 6)
        let expectedTotalCountDescription = "           _____0-9_____               \n" +
                                        "          /             \\              \n" +
                                        "      -9-2         ______6-6______     \n" +
                                        "     /            /               \\    \n" +
                                        "-20-1          3-3                 65-2\n" +
                                        "                  \\               /    \n" +
                                        "                   4(2)-2     12-1     "
        checkDesc(tree.descriptionWithTotalCount, expectedTotalCountDescription)
        let tree2 = BSTree<Int>()
        checkDesc(tree2.descriptionWithTotalCount, "")
    }

}

//
//  BSTreeNonNumericTests.swift
//  StruxTests
//  
//  Created by Richard Clark on 5/18/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation

import XCTest
import Foundation
@testable import Strux

class BSTreeNonNumericTests: XCTestCase {

    func helperTestCaseInsensitiveStrings(_ tree: BSTree<String>) {
        tree.insert("AARON")
        tree.insert("BORON", 4)
        print(tree)
        print(Array(tree))
        print(tree.firstValue!)
        print(tree.lastValue!)
        XCTAssertEqual(tree.toValueArray(), ["aaron", "aaron", "Alpha", "Baretta", "BORON", "BORON", "BORON", "BORON", "Fred", "Gamma", "xenon"])
        tree.remove("boron")
        XCTAssertEqual(tree.count(of: "BORON"), 3)
        tree.remove("boron", 2)
        XCTAssertEqual(tree.count(of: "BORON"), 1)
        tree.removeAll("aaron")
        XCTAssertFalse(tree.containsValue("aaron"))
        print(tree)
        tree.insert(["Hepsheba", "Batsheva"])
        print(tree)
        tree.insertMultiple("Joshua", "Elphaba")
        print(tree)
        XCTAssertTrue(tree.containsValue("Hepsheba"))
        XCTAssertTrue(tree.containsValue("Batsheva"))
        XCTAssertTrue(tree.containsValue("Joshua"))
        XCTAssertTrue(tree.containsValue("Elphaba"))
        tree.clear()
        XCTAssertTrue(tree.isEmpty)
    }

    func testStringTree() {
        let tree = BSTree(["aaron", "xenon", "Alpha", "Baretta", "Gamma", "Fred"]) {
            $0.lowercased() < $1.lowercased()
        }
        helperTestCaseInsensitiveStrings(tree)
    }

    func testStringTree2() {
        let tree = BSTree<String>() {
            (s1: String, s2: String) in return s1.lowercased() < s2.lowercased()
        }
        tree.insertMultiple("aaron", "xenon", "Alpha", "Baretta", "Gamma", "Fred")
        helperTestCaseInsensitiveStrings(tree)
    }
}

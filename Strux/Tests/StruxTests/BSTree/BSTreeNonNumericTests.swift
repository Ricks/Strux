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
        tree.insert("BORON", count: 4)
        print(tree)
        print(Array(tree))
        print(tree.firstValue!)
        print(tree.lastValue!)
        XCTAssertEqual(tree.toValueArray(), ["aaron", "aaron", "Alpha", "Baretta", "BORON", "BORON", "BORON", "BORON", "Fred", "Gamma", "xenon"])
        tree.remove("boron")
        XCTAssertEqual(tree.count("BORON"), 3)
        tree.remove("boron", count: 2)
        XCTAssertEqual(tree.count("BORON"), 1)
        tree.removeAll("aaron")
        XCTAssertFalse(tree.contains("aaron"))
        print(tree)
        tree.insert(["Hepsheba", "Batsheva"])
        print(tree)
        tree.insert("Joshua", "Elphaba")
        print(tree)
        XCTAssertTrue(tree.contains("Hepsheba"))
        XCTAssertTrue(tree.contains("Batsheva"))
        XCTAssertTrue(tree.contains("Joshua"))
        XCTAssertTrue(tree.contains("Elphaba"))
        tree.remove("Hepsheba", "Elphaba")
        tree.remove("Billabusta")
        XCTAssertFalse(tree.contains("Hepsheba"))
        XCTAssertTrue(tree.contains("Batsheva"))
        XCTAssertTrue(tree.contains("Joshua"))
        XCTAssertFalse(tree.contains("Elphaba"))
        tree.clear()
        XCTAssertTrue(tree.isEmpty)
        tree.insert(["Ruth", "Esther"])
        XCTAssertTrue(tree.contains("Ruth"))
        XCTAssertTrue(tree.contains("Esther"))
        tree.remove(["Ruth", "Esther"])
        XCTAssertFalse(tree.contains("Ruth"))
        XCTAssertFalse(tree.contains("Esther"))
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
        tree.insert("aaron", "xenon", "Alpha", "Baretta", "Gamma", "Fred")
        helperTestCaseInsensitiveStrings(tree)
    }
}

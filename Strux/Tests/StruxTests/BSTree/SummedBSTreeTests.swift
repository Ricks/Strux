//
//  SummedBSTreeTests.swift
//  StruxTests
//  
//  Created by Richard Clark on 5/13/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import XCTest
import Foundation
@testable import Strux

class SummedBSTreeTests: XCTestCase {

    func test1() {
        let tree: BSTree = [0, 9, 9, 3, 2, 5]
        XCTAssertEqual(tree.sum, 28)
        tree.deleteAll(9)
        XCTAssertEqual(tree.sum, 10)
        tree.delete(3)
        XCTAssertEqual(tree.sum, 7)
        tree.insert(4, 3)
        XCTAssertEqual(tree.sum, 19)
        tree.delete(4, 2)
        XCTAssertEqual(tree.sum, 11)
        tree.insert(42)
        XCTAssertEqual(tree.sum, 53)
    }

}

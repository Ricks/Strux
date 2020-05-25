//
//  IntAndAHalfTests.swift
//  BSTree
//
//  Created by Richard Clark on 5/24/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import XCTest
import Foundation
@testable import Strux

class IntAndAHalfTests: XCTestCase {

    func test1() {
        var a = IntAndAHalf.zero
        XCTAssertEqual(a.description, "0")
        a -= 0.5
        XCTAssertEqual(a.description, "-0.5")
        let b = IntAndAHalf(2)
        XCTAssertEqual(b.description, "2")
        var c = a + b
        XCTAssertEqual(c.description, "1.5")
        let d = IntAndAHalf(-14.5)
        XCTAssertEqual(d.description, "-14.5")
        c += d
        XCTAssertEqual(c, IntAndAHalf(-13))
        c = c.div2()
        XCTAssertEqual(c, IntAndAHalf(-6.5))
        XCTAssertEqual(c.intPortion, -6)
        XCTAssertTrue(c.hasHalf)
        c += 0.5
        XCTAssertEqual(c.intPortion, -6)
        XCTAssertFalse(c.hasHalf)
        XCTAssertEqual(c, IntAndAHalf(-6))
        c += 3
        XCTAssertEqual(c.intPortion, -3)
        XCTAssertFalse(c.hasHalf)
        XCTAssertEqual(c, IntAndAHalf(-3))
        c -= 2
        XCTAssertEqual(c.intPortion, -5)
        XCTAssertFalse(c.hasHalf)
        XCTAssertEqual(c, IntAndAHalf(-5))
        c = a - b
        XCTAssertEqual(c.intPortion, -2)
        XCTAssertTrue(c.hasHalf)
        XCTAssertEqual(c, IntAndAHalf(-2.5))
    }

}

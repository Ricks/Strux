//
//  QueueTests.swift
//  StruxTests
//
//  Created by Richard Clark on 4/25/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import XCTest
import Foundation
@testable import Strux

class QueueTests: XCTestCase {

    func testQueue() {
        var q = Queue<Int>()
        XCTAssertTrue(q.isEmpty)
        XCTAssertEqual(q.count, 0)
        XCTAssertNil(q.peek())
        XCTAssertNil(q.remove())
        q.add(42)
        XCTAssertFalse(q.isEmpty)
        XCTAssertEqual(q.count, 1)
        XCTAssertEqual(q.peek(), 42)
        q.add(99)
        XCTAssertTrue(q.contains(42))
        XCTAssertFalse(q.contains(43))
        XCTAssertEqual(q.count, 2)
        XCTAssertEqual(q[0], 42)
        XCTAssertEqual(q[1], 99)
        XCTAssertEqual(q.peek(), 42)
        XCTAssertEqual(q.remove(), 42)
        XCTAssertEqual(q.count, 1)
        XCTAssertEqual(q.peek(), 99)
    }

    func testQueueDoc() {
        var q = Queue<Int>()
        XCTAssertTrue(q.isEmpty)
        q.add(3)
        q.add(7)
        XCTAssertEqual(q.peek(), 3)
        XCTAssertEqual(q.count, 2)
        XCTAssertEqual(q[0], 3)
        XCTAssertEqual(q[1], 7)
        let val = q.remove()
        XCTAssertEqual(val, 3)
        XCTAssertEqual(q.peek(), 7)
        XCTAssertTrue(q.contains(7))
    }

    func testArrayLiteral() {
        let q: Queue = [1, 2, 99, 42, 6]
        XCTAssertEqual(q.count, 5)
        XCTAssertEqual(q[0], 1)
        XCTAssertEqual(q[1], 2)
        XCTAssertEqual(q[2], 99)
        XCTAssertEqual(q[3], 42)
        XCTAssertEqual(q[4], 6)
    }

    func testRandom() {
        var q = Queue<Int>()
        var array = [Int]()
        setSeed(42)
        for i in 0 ..< 100 {
            print("Queue \(i)")
            for k in 0 ..< 100 {
                if seededRandom(prob: 0.5) {
                    q.add(k)
                    array.append(k)
                } else {
                    q.remove()
                    if !array.isEmpty {
                        array.removeFirst()
                    }
                }
                XCTAssertEqual(Array(q), array)
            }
        }
    }

}

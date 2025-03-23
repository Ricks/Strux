//
//  DisjointSetTests.swift
//  Strux
//
//  Created by Rick Clark on 3/22/25.
//

import XCTest
@testable import Strux

class DisjointSetTests: XCTestCase {
    
    func testDisjointSet1() {
        var ds = DisjointSet<Int>()
        XCTAssertEqual(ds.valueCount, 0)
        XCTAssertEqual(ds.subsetCount, 0)
        XCTAssertTrue(ds.isEmpty)
        XCTAssertEqual(ds.description, "Empty")

        ds.insert(42)
        XCTAssertEqual(ds.valueCount, 1)
        XCTAssertEqual(ds.subsetCount, 1)
        XCTAssertFalse(ds.isEmpty)
        let desc1 = "1 subset, 1 value total\nsubset: 42"
        XCTAssertEqual(ds.description, desc1)

        ds.insert(58)
        XCTAssertEqual(ds.valueCount, 2)
        XCTAssertEqual(ds.subsetCount, 2)
        XCTAssertFalse(ds.isEmpty)
        let desc2 = "2 subsets, 2 values total\nsubset: 42\nsubset: 58"
        XCTAssertEqual(ds.description, desc2)
        XCTAssertFalse(ds.inSameSubset(42, 58))

        ds.merge(58, 42)
        XCTAssertEqual(ds.valueCount, 2)
        XCTAssertEqual(ds.subsetCount, 1)
        XCTAssertFalse(ds.isEmpty)
        let desc3 = "1 subset, 2 values total\nsubset: 42, 58"
        XCTAssertEqual(ds.description, desc3)
        XCTAssertTrue(ds.inSameSubset(42, 58))
    }
    
    // Add a new value by putting it at the beginning, middle, and end of a trio of values passed to merge()
    // Test adding a single value via merge()
    
}

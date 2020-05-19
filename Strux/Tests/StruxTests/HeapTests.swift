//
//  StruxTests.swift
//  StruxTests
//
//  Created by Richard Clark on 4/25/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import XCTest
import Foundation
@testable import Strux

class HeapTests: XCTestCase {

    func testMinHeap1() {
        var pq = Heap<Int>(isMin: true)
        XCTAssertTrue(pq.isEmpty)
        XCTAssertEqual(pq.count, 0)
        for i in 0...5 {
            pq.push(i)
        }
        XCTAssertFalse(pq.isEmpty)
        XCTAssertEqual(pq.count, 6)
        XCTAssertTrue(pq.contains(4))
        XCTAssertFalse(pq.contains(8))
        var actual = [Int]()
        while let val = pq.pop() {
            actual.append(val)
        }
        XCTAssertEqual([0, 1, 2, 3, 4, 5], actual)
    }

    func testMaxHeap1() {
        var pq = Heap<Int>(isMin: false)
        for i in 0...5 {
            pq.push(i)
        }
        var out = [Int]()
        while let val = pq.pop() {
            out.append(val)
        }
        XCTAssertEqual([5, 4, 3, 2, 1, 0], out)
    }

    func testMinHeap2() {
        let array = [5, -1, 3, 42, 69, 99, 72]
        var pq = Heap<Int>(isMin: true, startingValues: array)
        var out = [Int]()
        while let val = pq.pop() {
            out.append(val)
        }
        XCTAssertEqual(out, array.sorted())
    }

    func testMaxHeap2() {
        let array = [5, -1, 3, 42, 69, 99, 72]
        var pq = Heap<Int>(isMin: false, startingValues: array)
        var out = [Int]()
        while let val = pq.pop() {
            out.append(val)
        }
        XCTAssertEqual(out, array.sorted(by: >))
    }

    func testString() {
        var pq = Heap<String>(isMin: false)
        var s = "a"
        while s < "aaaaaa" {
            pq.push(s)
            s += "a"
        }

        let expected: [String] = ["aaaaa", "aaaa", "aaa", "aa", "a"]
        var actual: [String] = []
        while let val = pq.pop() {
            actual.append(val)
        }

        XCTAssertEqual(expected, actual, "Basic 5 String Array Test Pass")
    }

    func testSetEquiv() {
        for _ in 0..<100 {
            var s = Set((0..<(arc4random_uniform(100))).map { _ in arc4random_uniform(1000000) })
            var q = Heap<UInt32>(isMin: false, startingValues: Array(s))
            XCTAssertEqual(s.count, q.count, "Incorrect count with elements: " + s.description)
            while let se = s.max() {
                XCTAssertEqual(se, q.pop(), "Incorrect max item with elements: " + s.description)
                s.remove(se)
            }
            XCTAssertTrue(q.isEmpty)
        }
    }

    func testClear() {
        var pq = Heap<Int>(isMin: false, startingValues: Array(0..<10))
        XCTAssertEqual(pq.count, 10)
        XCTAssertEqual(pq.peek(), 9)
        pq.clear()
        XCTAssertTrue(pq.isEmpty)
    }

    func testPeek() {
        var pq = Heap<Int>(isMin: false)
        pq.push(1)
        pq.push(5)
        pq.push(3)
        XCTAssertEqual(pq.peek(), 5)
    }

    func testRemove() {
        var pq = Heap<Int>(isMin: false)
        for i in 0..<10 {
            pq.push(i)
        }

        pq.remove(4)
        pq.remove(7)

        let expected: [Int] = [9, 8, 6, 5, 3, 2, 1, 0]
        var actual: [Int] = []
        while let val = pq.pop() {
            actual.append(val)
        }

        XCTAssertEqual(expected, actual, "Trouble Removing 4 or 7")

        for i in 0..<10 {
            pq.push(i)
        }

        pq.remove(0)
        pq.remove(9)
        XCTAssertEqual(pq.count, 8)
        XCTAssertFalse(pq.contains(0))
        XCTAssertFalse(pq.contains(9))
        XCTAssertEqual(pq.peek(), 8)
        pq.remove(8)
        XCTAssertEqual(pq.peek(), 7)
        pq.remove(7)
        XCTAssertEqual(pq.peek(), 6)
        pq.remove(6)
        XCTAssertEqual(pq.peek(), 5)
        pq.remove(5)
        XCTAssertEqual(pq.peek(), 4)
        pq.remove(4)
        XCTAssertEqual(pq.peek(), 3)
        pq.remove(4)
        XCTAssertEqual(pq.peek(), 3)
        pq.remove(3)
        XCTAssertEqual(pq.peek(), 2)
        pq.remove(2)
        XCTAssertEqual(pq.peek(), 1)
        pq.remove(1)
        XCTAssertNil(pq.peek())
    }

    func testRemoveAll() {
        var pq = Heap<Int>(isMin: false)
        for i in 0..<10 {
            pq.push(i)
        }

        pq.push(4)
        pq.push(7)
        pq.push(7)

        pq.remove(4)
        pq.removeAll(7)

        let expected: [Int] = [9, 8, 6, 5, 4, 3, 2, 1, 0]
        var actual: [Int] = []
        while let val = pq.pop() {
            actual.append(val)
        }

        XCTAssertEqual(expected, actual, "Trouble Removing 4 or all 7s")

        for i in 0..<10 {
            pq.push(i)
        }

        pq.remove(0)
        pq.remove(9)
        XCTAssertEqual(pq.count, 8)
        XCTAssertFalse(pq.contains(0))
        XCTAssertFalse(pq.contains(9))
        XCTAssertEqual(pq.peek(), 8)
        pq.push(8)
        pq.push(4)
        pq.removeAll(8)
        XCTAssertEqual(pq.peek(), 7)
        pq.removeAll(7)
        XCTAssertEqual(pq.peek(), 6)
        pq.removeAll(6)
        XCTAssertEqual(pq.peek(), 5)
        pq.removeAll(5)
        XCTAssertEqual(pq.peek(), 4)
        pq.removeAll(4)
        XCTAssertEqual(pq.peek(), 3)
        pq.removeAll(4)
        XCTAssertEqual(pq.peek(), 3)
        pq.removeAll(3)
        XCTAssertEqual(pq.peek(), 2)
        pq.removeAll(2)
        XCTAssertEqual(pq.peek(), 1)
        pq.removeAll(1)
        XCTAssertNil(pq.peek())
    }

    func testRemoveLastInHeap() {
        var pq = Heap<Int>(isMin: false)
        pq.push(1)
        pq.push(2)

        pq.remove(1)

        let expected: [Int] = [2]
        var actual: [Int] = []
        while let val = pq.pop() {
            actual.append(val)
        }

        XCTAssertEqual(expected, actual)
    }

    func testHeapDoc() {
         var pq = Heap<Int>(isMin: false, startingValues: [5, -1, 3, 42, 68, 99, 72])     // Max heap
         XCTAssertFalse(pq.isEmpty)
         XCTAssertEqual(pq.count, 7)
         let max = pq.pop()
         XCTAssertEqual(max, 99)
         XCTAssertEqual(pq.count, 6)
         let currentMax = pq.peek()
         XCTAssertEqual(currentMax, 72)
         pq.push(100)
         XCTAssertEqual(pq.peek(), 100)
         XCTAssertTrue(pq.contains(3))
         pq.push(3)
         pq.remove(3)
         XCTAssertTrue(pq.contains(3))
         pq.push(-1)
         pq.removeAll(-1)
         XCTAssertFalse(pq.contains(-1))
         pq.clear()
         XCTAssertTrue(pq.isEmpty)
    }

    func testBSTDoc() {
        let tree = BSTree([1, 2, 3])
        print(tree)
        XCTAssertEqual(tree.root?.value, 2)
        XCTAssertEqual(tree.root?.valueCount, 1)
        tree.insert(4)
        print(tree)
        XCTAssertNil(tree.indexOf(5))
        XCTAssertEqual(tree[tree.indexOf(4)!].value, 4)
        tree.delete(2)
        print("Tree with 2 deleted:")
        print(tree)
        tree.insert(2)
        print(tree)
    }

    func testCollection() {
        var pqMax = Heap<Int>(isMin: false)
        for i in 0..<10 {
            pqMax.push(i)
        }
        pqMax.push(7)
        XCTAssertEqual(Array(pqMax).sorted(by: >), [9, 8, 7, 7, 6, 5, 4, 3, 2, 1, 0])
        XCTAssertEqual(pqMax[0], 9)

        var pqMin = Heap<Int>()
        for i in 0..<10 {
            pqMin.push(i)
        }
        pqMin.push(7)
        XCTAssertEqual(Array(pqMin).sorted(), [0, 1, 2, 3, 4, 5, 6, 7, 7, 8, 9])
        XCTAssertEqual(pqMin[0], 0)
    }
//
//    func testPerformance() {
//        measure {
//            (0..<1).forEach { heapIndex in
//                print("Heap \(heapIndex) ...")
//                let initialValues = [44, -12, 3]
//                let heapSizish = seededRandom(in: 0..<100000)
//                var heap = Heap<Int>(isMin: true, startingValues: initialValues)
//                (0..<heapSizish).forEach { _ in
//                    let val = seededRandom(in: -5..<100)
//                    let choice = seededRandom(in: 0..<10)
//                    switch choice {
//                    case 0:
//                        heap.remove(val)
//                    case 1:
//                        heap.removeAll(val)
//                    case 2:
//                        heap.pop()
//                    default:
//                        heap.push(val)
//                    }
//                }
//            }
//        }
//    }
}

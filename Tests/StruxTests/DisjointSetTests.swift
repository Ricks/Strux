//
//  DisjointSetTests.swift
//  
//
//  Created by Richard Clark on 1/11/21.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import XCTest
@testable import Strux

class Solution {

    func distanceLimitedPathsExist(_ n: Int, _ edgeList: [[Int]], _ queries: [[Int]]) -> [Bool] {
        // Sort edges, queries by distance
        let sortedEdges = edgeList.sorted() { $0[2] < $1[2] }
        let sortedQueries = queries.sorted() { $0[2] < $1[2] }
        let ds = DisjointSet<Int>()
        var resultDict = [[Int]: Bool]()

        var edgeIndex = 0
        for query in sortedQueries {
            while edgeIndex < sortedEdges.count && sortedEdges[edgeIndex][2] < query[2] {
                ds.union(sortedEdges[edgeIndex][0], sortedEdges[edgeIndex][1])
                edgeIndex += 1
            }
            let result = ds.find(query[0]) == ds.find(query[1])
            resultDict[query] = result
        }

        var results = [Bool]()
        for query in queries {
            results.append(resultDict[query] ?? false)
        }
        return results
    }

}

class DisjointSetTests: XCTestCase {

    func testDisjointSet1() {
        let ds = DisjointSet<Int>()
        ds.union(2, 3)
        ds.union(3, 4)
        XCTAssertNotEqual(ds.find(1), ds.find(2))
        XCTAssertEqual(ds.find(2), ds.find(3))
        XCTAssertEqual(ds.find(3), ds.find(4))
        XCTAssertNotEqual(ds.find(4), ds.find(5))

        var expectedLines = Set<String>()
        for i in 2 ... 4 {
            expectedLines.insert("\(i): root = \(ds.find(i))")
        }
        let actualLines = Set("\(ds)".split(separator: "\n").map { String($0) })
        print(actualLines)
        XCTAssertEqual(expectedLines, actualLines)
        print(ds)
    }

    func testDisjointSet2() {
        let ds = DisjointSet<Int>()
        ds.union(1, 2)
        ds.union(2, 3)
        ds.union(3, 2)
        ds.union(3, 4)
        ds.union(4, 5)
        XCTAssertEqual(ds.find(1), ds.find(2))
        XCTAssertEqual(ds.find(2), ds.find(3))
        XCTAssertEqual(ds.find(3), ds.find(4))
        XCTAssertEqual(ds.find(4), ds.find(5))
    }

    func testClear() {
        let ds = DisjointSet<Int>()
        ds.union(1, 2)
        ds.union(2, 3)
        ds.union(3, 4)
        ds.union(4, 5)

        ds.clear()

        XCTAssertEqual("\(ds)", "")
        XCTAssertNotEqual(ds.find(1), ds.find(2))
        XCTAssertNotEqual(ds.find(2), ds.find(3))
        XCTAssertNotEqual(ds.find(3), ds.find(4))
        XCTAssertNotEqual(ds.find(4), ds.find(5))
        ds.union(1, 2)
        ds.union(2, 3)
        ds.union(3, 4)
        ds.union(4, 5)
        XCTAssertEqual(ds.find(1), ds.find(2))
        XCTAssertEqual(ds.find(2), ds.find(3))
        XCTAssertEqual(ds.find(3), ds.find(4))
        XCTAssertEqual(ds.find(4), ds.find(5))
    }

    func testDistanceLimitedPathsExist() {
        let sol = Solution()
        XCTAssertEqual(sol.distanceLimitedPathsExist(3, [[0,1,2],[1,2,4],[2,0,8],[1,0,16]], [[0,1,2],[0,2,5]]),
                       [false,true])
        XCTAssertEqual(sol.distanceLimitedPathsExist(5, [[0,1,10],[1,2,5],[2,3,9],[3,4,13]], [[0,4,14],[1,4,13]]),
                       [true,false])
        XCTAssertEqual(sol.distanceLimitedPathsExist(13,
                                                     [[9,1,53],[3,2,66],[12,5,99],[9,7,26],[1,4,78],[11,1,62],[3,10,50],[12,1,71],[12,6,63],[1,10,63],[9,10,88],[9,11,59],[1,4,37],[4,2,63],[0,2,26],[6,12,98],[9,11,99],[4,5,40],[2,8,25],[4,2,35],[8,10,9],[11,9,25],[10,11,11],[7,6,89],[2,4,99],[10,4,63]],
                                                     [[9,7,65],[9,6,1],[4,5,34],[10,8,43],[3,7,76],[4,2,15],[7,6,52],[2,0,50],[7,6,62],[1,0,81],[4,5,35],[0,11,86],[12,5,50],[11,2,2],[9,5,6],[12,0,95],[10,6,9],[9,4,73],[6,10,48],[12,0,91],[9,10,58],[9,8,73],[2,3,44],[7,11,83],[5,3,14],[6,2,33]]),
                       [true,false,false,true,true,false,false,true,false,true,false,true,false,false,false,true,false,true,false,true,true,true,false,true,false,false])
    }

}

//
//  DisjointSetTests.swift
//  Strux
//
//  Created by Rick Clark on 3/22/25.
//

import XCTest
@testable import Strux

class Solution1 {

    func distanceLimitedPathsExist(_ n: Int, _ edgeList: [[Int]], _ queries: [[Int]]) -> [Bool] {
        // Sort edges, queries by distance
        let sortedEdges = edgeList.sorted() { $0[2] < $1[2] }
        let sortedQueries = queries.sorted() { $0[2] < $1[2] }
        var ds = DisjointSet<Int>()
        var resultDict = [[Int]: Bool]()

        var edgeIndex = 0
        for query in sortedQueries {
            while edgeIndex < sortedEdges.count && sortedEdges[edgeIndex][2] < query[2] {
                ds.merge(sortedEdges[edgeIndex][0], sortedEdges[edgeIndex][1])
                edgeIndex += 1
            }
            let result = ds.inSameSubset(query[0], query[1])
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
        var ds = DisjointSet<Int>()
        XCTAssertEqual(ds.valueCount, 0)
        XCTAssertEqual(ds.subsetCount, 0)
        XCTAssertTrue(ds.isEmpty)
        XCTAssertEqual(ds.description, "Empty")

        ds.insert(9)
        XCTAssertEqual(ds.valueCount, 1)
        XCTAssertEqual(ds.subsetCount, 1)
        XCTAssertFalse(ds.isEmpty)
        XCTAssertEqual(ds.description, "1 subset, 1 value total\nsubset: 9")

        ds.insert(58)
        XCTAssertEqual(ds.valueCount, 2)
        XCTAssertEqual(ds.subsetCount, 2)
        XCTAssertFalse(ds.isEmpty)
        XCTAssertEqual(ds.description, "2 subsets, 2 values total\nsubset: 9\nsubset: 58")
        XCTAssertFalse(ds.inSameSubset(9, 58))
        XCTAssertEqual(ds.subset(with: 9), Set<Int>([9]))
        XCTAssertEqual(ds.subset(with: 58), Set<Int>([58]))

        ds.merge(58, 9)
        XCTAssertEqual(ds.valueCount, 2)
        XCTAssertEqual(ds.subsetCount, 1)
        XCTAssertFalse(ds.isEmpty)
        XCTAssertEqual(ds.description, "1 subset, 2 values total\nsubset: 9, 58")
        XCTAssertTrue(ds.inSameSubset(9, 58))
        XCTAssertEqual(ds.subset(with: 9), Set<Int>([9, 58]))
        XCTAssertEqual(ds.subset(with: 58), Set<Int>([9, 58]))
        
        XCTAssertTrue(ds.contains(9))
        XCTAssertFalse(ds.contains(-1))
        
        ds.merge(58, 58, 99)
        XCTAssertEqual(ds.valueCount, 3)
        XCTAssertEqual(ds.subsetCount, 1)
        XCTAssertFalse(ds.isEmpty)
        XCTAssertEqual(ds.description, "1 subset, 3 values total\nsubset: 9, 58, 99")
        
        ds.merge(77, 77, 9)
        XCTAssertEqual(ds.valueCount, 4)
        XCTAssertEqual(ds.subsetCount, 1)
        XCTAssertFalse(ds.isEmpty)
        XCTAssertEqual(ds.description, "1 subset, 4 values total\nsubset: 9, 58, 77, 99")
    }
    
    func testMerge() {
        // Test adding a single value via merge()
        var ds = DisjointSet<Int>()
        ds.merge([9])
        XCTAssertEqual(ds.valueCount, 1)
        XCTAssertEqual(ds.subsetCount, 1)
        XCTAssertFalse(ds.isEmpty)
        XCTAssertEqual(ds.description, "1 subset, 1 value total\nsubset: 9")

        // Add a new value by putting it at the beginning, middle, and end of values passed to merge()
        
        ds.merge(42, 9)
        XCTAssertEqual(ds.valueCount, 2)
        XCTAssertEqual(ds.subsetCount, 1)
        XCTAssertFalse(ds.isEmpty)
        XCTAssertEqual(ds.description, "1 subset, 2 values total\nsubset: 9, 42")
        XCTAssertTrue(ds.inSameSubset(9, 42))
        
        ds.merge(42, 12)
        XCTAssertEqual(ds.valueCount, 3)
        XCTAssertEqual(ds.subsetCount, 1)
        XCTAssertFalse(ds.isEmpty)
        XCTAssertEqual(ds.description, "1 subset, 3 values total\nsubset: 9, 12, 42")
        XCTAssertTrue(ds.inSameSubset(9, 42))
        XCTAssertTrue(ds.inSameSubset(12, 42))
        XCTAssertTrue(ds.inSameSubset(9, 12))
        
        ds.merge(42, 6, 12)
        XCTAssertEqual(ds.valueCount, 4)
        XCTAssertEqual(ds.subsetCount, 1)
        XCTAssertFalse(ds.isEmpty)
        XCTAssertEqual(ds.description, "1 subset, 4 values total\nsubset: 6, 9, 12, 42")
        XCTAssertTrue(ds.inSameSubset(9, 42))
        XCTAssertTrue(ds.inSameSubset(12, 42))
        XCTAssertTrue(ds.inSameSubset(9, 12))
        XCTAssertTrue(ds.inSameSubset(6, 12))
        
        ds.merge([11, 17, 13])
        XCTAssertEqual(ds.valueCount, 7)
        XCTAssertEqual(ds.subsetCount, 2)
        XCTAssertFalse(ds.isEmpty)
        XCTAssertEqual(ds.description, "2 subsets, 7 values total\nsubset: 6, 9, 12, 42\nsubset: 11, 13, 17")
        XCTAssertFalse(ds.inSameSubset(6, 11))
        XCTAssertFalse(ds.inSameSubset(6, 19))
        
        XCTAssertEqual(ds.subsets, [Set<Int>([6, 9, 12, 42]), Set<Int>([11, 13, 17])])
        ds.merge(-1, 13)
        XCTAssertEqual(ds.subsets, [Set<Int>([-1, 11, 13, 17]), Set<Int>([6, 9, 12, 42])])
        XCTAssertEqual(ds.values, [-1, 6, 9, 11, 12, 13, 17, 42])
        
        ds.clear()
        XCTAssertEqual(ds.valueCount, 0)
        XCTAssertEqual(ds.subsetCount, 0)
        XCTAssertTrue(ds.isEmpty)
        XCTAssertEqual(ds.description, "Empty")

        ds.insert(9)
        XCTAssertEqual(ds.valueCount, 1)
        XCTAssertEqual(ds.subsetCount, 1)
        XCTAssertFalse(ds.isEmpty)
        XCTAssertEqual(ds.description, "1 subset, 1 value total\nsubset: 9")
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

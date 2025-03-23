//
//  File.swift
//  Strux
//
//  Created by Rick Clark on 3/21/25.
//

import Foundation

struct DisjointSet<T: Hashable & Comparable>: CustomStringConvertible {
    private var subsetDict = [Int: Set<T>]()
    private var keyDict = [T: Int]()
    private var maxKey = 0
    
    private func sortedSubsets() -> [Set<T>] {
        let arr: [Set<T>] = Array(subsetDict.values)
        return arr.sorted { (first: Set<T>, second: Set<T>) -> Bool in
            return first.min()! < second.min()!
        }
    }

    var description: String {
        var description = ""
        let subs = sortedSubsets()
        if subs.count == 0 {
            description = "Empty"
        } else {
            description = subs.count == 1 ? "1 subset, " : "\(subs.count) subsets, "
            description += valueCount == 1 ? "1 value total\n" : "\(valueCount) values total\n"
            for i in 0 ..< subs.count {
                description += "subset: "
                description += subs[i].sorted().map { "\($0)" }.joined(separator: ", ")
                 if i < subs.count - 1 {
                    description += "\n"
                }
            }
        }
        return description
    }

    public func subset(of value: T) -> Set<T>? {
        if let value = keyDict[value] {
            return subsetDict[value]
        } else {
            return nil
        }
    }
    
    public func contains(_ value: T) -> Bool {
        return keyDict[value] != nil
    }
    
    mutating private func insertVal(_ value: T) -> Int {
        if let key = keyDict[value] {
            return key
        } else {
            let singleValueSet: Set<T> = [value]
            maxKey += 1
            subsetDict[maxKey] = singleValueSet
            keyDict[value] = maxKey
            return maxKey
        }
    }

    mutating public func insert(_ value: T) {
        _ = insertVal(value)
    }

    mutating public func merge(_ values: [T]) {
        var keyValuePairs = [(Int, T)]()
        for value in values {
            let key = insertVal(value)
            keyValuePairs.append((key, value))
        }
        if keyValuePairs.count > 1 {
            let (mainKey, _) = keyValuePairs.removeFirst()
            var keysMerged: Set<Int> = [mainKey]
            for (key, value) in keyValuePairs {
                if !keysMerged.contains(key) {
                    subsetDict[mainKey] = subsetDict[mainKey]!.union(subsetDict[key]!)
                    subsetDict[key] = nil
                    keysMerged.insert(key)
                }
                keyDict[value] = mainKey
            }
        }
    }
    
    mutating public func merge(_ values: T...) {
        merge(values)
    }
    
    public func inSameSubset(_ value1: T, _ value2: T) -> Bool {
        return keyDict[value1] == keyDict[value2]
    }
    
    public var valueCount: Int {
        return keyDict.keys.count
    }
    
    public var subsetCount: Int {
        return subsetDict.values.count
    }
    
    public var isEmpty: Bool {
        return subsetDict.isEmpty
    }
    
    public var subsets: [Set<T>] {
        return Array(subsetDict.values)
    }
    
    public var values: [T] {
        return Array(keyDict.keys)
    }
    
    mutating public func clear() {
        subsetDict = [:]
        keyDict = [:]
        maxKey = 0
    }
    
}

//
//  DisjointSet.swift
//  Strux
//
//  Created by Rick Clark on 3/21/25.
//

import Foundation

struct DisjointSet<T: Hashable>: CustomStringConvertible {
    private var subsetDict = [Int: Set<T>]()
    private var keyDict = [T: Int]()
    private var maxKey = 0

    var description: String {
        (self as? any DisjointSetOfComparableConvertible)?.customDescription ?? self.normalDescription
    }

    public func subset(with value: T) -> Set<T>? {
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
            let (mainKey, value) = keyValuePairs.removeFirst()
            keyDict[value] = mainKey
            var keysMerged: Set<Int> = [mainKey]
            for (key, _) in keyValuePairs {
                if !keysMerged.contains(key) {
                    subsetDict[mainKey] = subsetDict[mainKey]!.union(subsetDict[key]!)
                    for value in subsetDict[key]! {
                        keyDict[value] = mainKey
                    }
                    subsetDict[key] = nil
                    keysMerged.insert(key)
                }
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
    
    public var subsets: Set<Set<T>> {
        return Set(subsetDict.values)
    }
    
    public var values: Set<T> {
        return Set(keyDict.keys)
    }
    
    mutating public func clear() {
        subsetDict = [:]
        keyDict = [:]
        maxKey = 0
    }
    
}

protocol DisjointSetOfComparableConvertible {
    var customDescription: String { get }
}

extension DisjointSet {
    var normalDescription: String {
        var description = ""
        let subs = subsets
        if subs.count == 0 {
            description = "Empty"
        } else {
            description = subs.count == 1 ? "1 subset, " : "\(subs.count) subsets, "
            description += valueCount == 1 ? "1 value total\n" : "\(valueCount) values total\n"
            let n = subs.count
            var i = 0
            for sub in subs {
                description += "subset: "
                description += sub.map { "\($0)" }.sorted().joined(separator: ", ")
                 if i < n - 1 {
                    description += "\n"
                }
                i += 1
            }
        }
        return description
    }
}

extension DisjointSet: DisjointSetOfComparableConvertible where T: Comparable {
    var customDescription: String {
        var description = ""
        let subs = subsets.sorted { (first: Set<T>, second: Set<T>) -> Bool in
            if let fm = first.min(), let sm = second.min() {
                return fm < sm
            } else {
                return false
            }
        }
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
}

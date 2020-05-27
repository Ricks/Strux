//
//  BSTreeSum.swift
//  Strux
//
//  Created by Richard Clark on 5/26/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation

extension BSTree where T: AdditiveArithmetic {

    private func ensureSumStorageInitialized() {
        if sumStorage == nil {
            sumStorage = T.zero
            for elem in self { addToSumStorage(elem.value, elem.count) }
        }
    }

    /// The sum of each value times its count. Time complexity: *O(1)*
    public var sum: T {
        get {
            ensureSumStorageInitialized()
            return sumStorage!
        }
        set {
            ensureSumStorageInitialized()
            sumStorage = newValue
        }
    }

    private func addToSumStorage(_ val: T, _ n: Int) {
        for _ in 0 ..< n { sum += val }
    }

    private func subtractFromSumStorage(_ val: T, _ n: Int) {
        for _ in 0 ..< n { sum -= val }
    }

    /// :nodoc:
   public func insert(_ val: T, _ n: Int) {
        addToSumStorage(val, n)        // Has to come before performInsertsion() so that sum is initialized correctly.
        performInsertion(val, n)
    }

    /// :nodoc:
    public func insert(_ val: T) {
        addToSumStorage(val, 1)        // Has to come before performInsertsion() so that sum is initialized correctly.
        performInsertion(val, 1)
    }

    /// :nodoc:
    public func clear() {
        performClear()
        sumStorage = T.zero
    }

    /// :nodoc:
    public func remove(_ val: T, _ n: Int) {
        let numRemoved = performRemoval(val, n)
        subtractFromSumStorage(val, numRemoved)
    }

    /// :nodoc:
    public func remove(_ val: T) {
        let numRemoved = performRemoval(val, 1)
        subtractFromSumStorage(val, numRemoved)
    }

    /// :nodoc:
    public func removeAll(_ val: T) {
        let numRemoved = performRemoval(val, Int.max)
        subtractFromSumStorage(val, numRemoved)
    }

}

//
//  BSTreeValueQueries.swift
//  Strux
//
//  Created by Richard Clark on 5/26/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation

extension BSTree {

    // MARK: Value-Specific Queries

    /// Return the index (BSTreeIndex) of the value, or nil if the tree doesn't have the value.
    /// Time complexity: *O(logN)*
    /// - Parameter val: The value to look for
    /// - Returns: index, or nil if not found
    public func indexOf(_ val: T) -> Index? {
        let node = root?.find(val)
        return (node == nil) ? nil : BSTreeIndex(node: node)
    }

    /// Return true if the tree contains the given value, false otherwise.
    /// Time complexity: *O(logN)*
    /// - Parameter value: The value to look for
    /// - Returns: true or false
    public func containsValue(_ value: T) -> Bool {
        return indexOf(value) != nil
    }

    /// Returns the count of the value in the tree. Zero if the tree doesn't contain the value.
    /// Time complexity: *O(logN)*
    /// - Parameter value: The value get the count of
    /// - Returns: Integer count
    public func count(of val: T) -> Int {
        return Int(root?.find(val)?.valueCount ?? 0)
    }

    /// Returns the index of the least value >= the given value, according to the ordering given by the
    /// comparator, or by the '<' operator. Returns nil if there is no ceiling. Time complexity: *O(logN)*
    /// - Parameter val: The value to find the ceiling of
    /// - Returns: The index (nil if there is no ceiling value)
    public func ceilingIndex(_ val: T) -> Index? {
        let ceilingNode = root?.findCeiling(val)
        return (ceilingNode == nil) ? nil : BSTreeIndex(node: ceilingNode)
    }

    /// Returns the least value >= the given value, according to the ordering given by the
    /// comparator, or by the '<' operator. Returns nil if there is no ceiling. Time complexity: *O(logN)*
    /// - Parameter val: The value to find the ceiling of
    /// - Returns: The ceiling value (nil if none)
    public func ceilingValue(_ val: T) -> T? {
        let index = ceilingIndex(val)
        return index == nil ? nil : self[index!].value
    }

    /// Returns the index of the greatest value <= the given value, according to the ordering given by the
    /// comparator, or by the '<' operator. Returns nil if there is no floor. Time complexity: *O(logN)*
    /// - Parameter val: The value to find the floor of
    /// - Returns: The index (nil if there is no floor value)
    public func floorIndex(_ val: T) -> Index? {
        var floorNode: BSNode<T>?
        if let root = root {
            if let node = root.findCeiling(val) {
                floorNode = (node.value == val) ? node : node.prev
            } else {
                floorNode = lastNode
            }
        }
        return (floorNode == nil) ? nil : BSTreeIndex(node: floorNode)
    }

    /// Returns the greatest value <= the given value, according to the ordering given by the
    /// comparator, or by the '<' operator. Returns nil if there is no floor. Time complexity: *O(logN)*
    /// - Parameter val: The value to find the floor of
    /// - Returns: The floor value (nil if none)
    public func floorValue(_ val: T) -> T? {
        let index = floorIndex(val)
        return index == nil ? nil : self[index!].value
    }

    /// Returns the index of the least value > the given value, according to the ordering given by the
    /// comparator, or by the '<' operator. Returns nil if there is no higher value. Time complexity: *O(logN)*
    /// - Parameter val: The value to find the higher value of
    /// - Returns: The index (nil if there is no higher value)
    public func higherIndex(_ val: T) -> Index? {
        var higherNode: BSNode<T>?
        if let root = root {
            if let node = root.findCeiling(val) {
                higherNode = (node.value == val) ? node.next : node
            }
        }
        return (higherNode == nil) ? nil : BSTreeIndex(node: higherNode)
    }

    /// Returns the least value > the given value, according to the ordering given by the
    /// comparator, or by the '<' operator. Returns nil if there is no higher value. Time complexity: *O(logN)*
    /// - Parameter val: The value to find the higher value of
    /// - Returns: The higher value (nil if none)
    public func higherValue(_ val: T) -> T? {
        let index = higherIndex(val)
        return index == nil ? nil : self[index!].value
    }

    /// Returns the index of the greatest value < the given value, according to the ordering given by the
    /// comparator, or by the '<' operator. Returns nil if there is no lower value. Time complexity: *O(logN)*
    /// - Parameter val: The value to find the lower value of
    /// - Returns: The index (nil if there is no lower value)
    public func lowerIndex(_ val: T) -> Index? {
        var lowerNode: BSNode<T>?
        if let root = root {
            if let node = root.findCeiling(val) {
                lowerNode = node.prev
            } else {
                lowerNode = lastNode
            }
        }
        return (lowerNode == nil) ? nil : BSTreeIndex(node: lowerNode)
    }

    /// Returns the greatest value < the given value, according to the ordering given by the
    /// comparator, or by the '<' operator. Returns nil if there is no lower value. Time complexity: *O(logN)*
    /// - Parameter val: The value to find the lower value of
    /// - Returns: The lower value (nil if none)
    public func lowerValue(_ val: T) -> T? {
        let index = lowerIndex(val)
        return index == nil ? nil : self[index!].value
    }
}

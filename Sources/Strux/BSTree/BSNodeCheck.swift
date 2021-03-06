//
//  BSNodeCheck.swift
//  Strux
//
//  Created by Richard Clark on 4/25/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation

/// Note that when only insert and remove are used to modify the tree, the tree should always be valid and
/// balanced. These provide checking.
extension BSNode {

    /// True if the height of the left and right subtrees differ by no more than 1, and the left and right
    /// subtrees are balanced.
    var isBalanced: Bool {
        return abs((left?.height ?? -1) - (right?.height ?? -1)) <= 1 &&
            (left?.isBalanced ?? true) && (right?.isBalanced ?? true)
    }

    private func isValidHelper() -> (isValid: Bool, minVal: T, maxVal: T) {
        var isValid = true
        var minVal: T?
        var maxVal: T?
        if let left = left {
            let res = left.isValidHelper()
            isValid = res.isValid && !ordered(value, res.maxVal)
            minVal = res.minVal
            maxVal = res.maxVal
        }
        if let right = right {
            let res = right.isValidHelper()
            isValid = isValid && res.isValid && ordered(value, res.minVal)
            if minVal == nil || ordered(res.minVal, minVal!) { minVal = res.minVal }
            if maxVal == nil || ordered(maxVal!, res.maxVal) { maxVal = res.maxVal }
        }
        if minVal == nil || ordered(value, minVal!) { minVal = value }
        if maxVal == nil || ordered(maxVal!, value) { maxVal = value }
        return (isValid: isValid, minVal: minVal!, maxVal: maxVal!)
    }

    /// True if the subtree having this node as root is a valid BST, meaning that the value of the root node of
    /// the subtree must be **strictly** greater than any value in the sub-subtree, if any, with its left child
    /// as root, and **strictly** less than any value in the sub-subtree, if any, with its right child as root,
    /// and all sub-subtrees of the subtree must meet the same condition.
    var isValid: Bool {
        return isValidHelper().isValid
    }
}

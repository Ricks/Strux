//
//  ValueIndex.swift
//  BSTree
//
//  Index used to keep track of a specific value in the tree, or a point halfway between two values.
//  Used to track the median.
//
//  Created by Richard Clark on 5/24/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation

struct IntAndAHalf : AdditiveArithmetic, CustomStringConvertible {
    var doubleVal: Int

    init(doubleVal: Int) {
        self.doubleVal = doubleVal
    }

    init(_ val: Int) {
        doubleVal = val * 2
    }

    init(_ val: Double) {
        doubleVal = Int(round(val * 2.0))
    }

    func div2() -> IntAndAHalf {
        return IntAndAHalf(doubleVal: doubleVal / 2)
    }

    static var zero = IntAndAHalf(doubleVal: 0)

    static func + (left: IntAndAHalf, right: IntAndAHalf) -> IntAndAHalf {
        return IntAndAHalf(doubleVal: left.doubleVal + right.doubleVal)
    }

    static func += (left: inout IntAndAHalf, right: Int) {
        left.doubleVal += right * 2
    }

    static func += (left: inout IntAndAHalf, right: Double) {
        left.doubleVal += Int(round(right * 2.0))
    }

    static func - (left: IntAndAHalf, right: IntAndAHalf) -> IntAndAHalf {
        return IntAndAHalf(doubleVal: left.doubleVal - right.doubleVal)
    }

    static func -= (left: inout IntAndAHalf, right: Int) {
        left.doubleVal -= right * 2
    }

    static func -= (left: inout IntAndAHalf, right: Double) {
        left.doubleVal -= Int(round(right * 2.0))
    }

    var intPortion: Int {
        doubleVal / 2
    }

    var hasHalf: Bool {
        doubleVal % 2 != 0
    }

    var description: String {
        let intPart = abs(intPortion)
        var out = String(intPart)
        if hasHalf { out += ".5" }
        if doubleVal < 0 { out = "-" + out }
        return out
    }
}

struct ValueIndex<T: Equatable> {
    weak var node: BSNode<T>?
    var offset = 0

    private static func maxOffset(_ node: BSNode<T>?) -> Int {
        return Int((node?.valueCount ?? 0)) - 1
    }

    var next: ValueIndex<T> {
        var nNode = node
        var nOffset = offset + 1
        if nOffset > ValueIndex.maxOffset(nNode) {
            nNode = nNode?.next
            nOffset = 0
        }
        return ValueIndex(node: nNode, offset: nOffset)
    }

    var prev: ValueIndex<T> {
        var pNode = node
        var pOffset = offset - 1
        if pOffset < 0 {
            pNode = pNode?.prev
            pOffset = ValueIndex.maxOffset(pNode)
        }
        return ValueIndex(node: pNode, offset: pOffset)
    }

    var offsetIsMax: Bool {
        offset == ValueIndex.maxOffset(node)
    }

}


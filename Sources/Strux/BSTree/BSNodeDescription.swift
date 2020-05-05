//
//  BSNodeDescription.swift
//  DataStructures
//
//  Created by Richard Clark on 4/25/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation

func valOrNil(_ val: Any?) -> String {
    return (val == nil) ? "nil" : "\(val!)"
}

extension String {
    func padTo(_ len: Int) -> String {
        var out = self
        if count < len {
            out.append(contentsOf: String(repeating: " ", count: len - count))
        }
        return out
    }
}

enum TreeDescriptionType {
    case plain
    case withHeight
    case withNext
}

extension BSNode: CustomStringConvertible {

    // An ASCII-graphics representation of the subtree having this node as root.
    var description: String {
        return descriptionBox(.plain).lines.joined(separator: "\n")
    }

    var descriptionWithHeight: String {
        return descriptionBox(.withHeight).lines.joined(separator: "\n")
    }

    var descriptionWithNext: String {
        return descriptionBox(.withNext).lines.joined(separator: "\n")
    }

    struct DescriptionBox {
        var lines = [String]()    // All lines same length
        var height: Int { lines.count }
        var width: Int { lines.isEmpty ? 0 : lines[0].count }
        var valueStart = 0
        var valueEnd = 0
    }

    func spaces(_ len: Int) -> String {
        return String(repeating: " ", count: len)
    }

    func descriptionBox(_ type: TreeDescriptionType) -> DescriptionBox {
        var box = DescriptionBox()  // Have to fill in valueStart, valueEnd, lines
        var valueStr = valueCount == 1 ? "\(value)" : "\(value)(\(valueCount))"
        if type == .withHeight {
            valueStr += "-\(height)"
        } else if type == .withNext {
            valueStr += "->\(valOrNil(next?.value))"
        }
        if left == nil && right == nil {
            box.valueStart = 0
            box.valueEnd = valueStr.count - 1
            box.lines.append(valueStr)
        } else if left != nil && right == nil {
            let leftBox = left!.descriptionBox(type)
            let leftArrowPos = leftBox.valueEnd + 1
            box.valueStart = leftArrowPos + 1
            box.valueEnd = box.valueStart + valueStr.count - 1
            let boxWidth = max(leftBox.width, box.valueEnd + 1)
            box.lines.append((spaces(box.valueStart) + valueStr).padTo(boxWidth))
            box.lines.append((spaces(leftArrowPos) + "/").padTo(boxWidth))
            let pad = spaces(boxWidth - leftBox.width)
            for line in leftBox.lines {
                box.lines.append(line + pad)
            }
        } else if left == nil && right != nil {
            let rightBox = right!.descriptionBox(type)
            let rightBoxPos = max(0, valueStr.count + 1 - rightBox.valueStart)
            let rightArrowPos = rightBoxPos + rightBox.valueStart - 1
            box.valueEnd = rightArrowPos - 1
            box.valueStart = box.valueEnd - valueStr.count + 1
            let boxWidth = rightBoxPos + rightBox.width
            box.lines.append((spaces(box.valueStart) + valueStr).padTo(boxWidth))
            box.lines.append((spaces(rightArrowPos) + "\\").padTo(boxWidth))
            let pad = String(repeating: " ", count: rightBoxPos)
            for line in rightBox.lines {
                box.lines.append(pad + line)
            }
        } else {   // Have both children
            let leftBox = left!.descriptionBox(type)
            let rightBox = right!.descriptionBox(type)
            let leftBoxValueInsetRight = leftBox.width - leftBox.valueEnd - 1
//            let boxGap = valueStr.count + max(0, 2 - leftBoxValueInsetRight - rightBox.valueStart)
            let boxGap = valueStr.count + 2
            let rightBoxPos = leftBox.width + boxGap
            let boxWidth = rightBoxPos + rightBox.width
            let leftArrowPos = leftBox.valueEnd + 1
            let rightArrowPos = rightBoxPos + rightBox.valueStart - 1
            // Center the value between arrows
            let valueSpace = rightArrowPos - leftArrowPos - 1
            let valueExtraSpaces = valueSpace - valueStr.count
            var valueLeadingSpaces = valueExtraSpaces / 2
            if valueExtraSpaces % 2 == 1 && leftBoxValueInsetRight > rightBox.valueStart {
                valueLeadingSpaces += 1
            }
            let valueTrailingSpaces = valueExtraSpaces - valueLeadingSpaces
            let leadingUnderscores = String(repeating: "_", count: valueLeadingSpaces)
            let trailingUnderscores = String(repeating: "_", count: valueTrailingSpaces)
            box.valueStart = leftArrowPos + 1 + valueLeadingSpaces
            box.valueEnd = box.valueStart + valueStr.count - 1
            let valueLine = spaces(leftArrowPos + 1) + leadingUnderscores + valueStr + trailingUnderscores
            let arrowLine = spaces(leftArrowPos) + "/" + spaces(rightArrowPos - leftArrowPos - 1) + "\\"
            box.lines.append(valueLine.padTo(boxWidth))
            box.lines.append(arrowLine.padTo(boxWidth))
            var li = 0
            var ri = 0
            let pad = spaces(boxGap)
            while li < leftBox.height && ri < rightBox.height {
                box.lines.append(leftBox.lines[li] + pad + rightBox.lines[ri])
                li += 1
                ri += 1
            }
            if li < leftBox.height {
                let pad = spaces(boxWidth - leftBox.width)
                while li < leftBox.height {
                    box.lines.append(leftBox.lines[li] + pad)
                    li += 1
                }
            }
            if ri < rightBox.height {
                let pad = spaces(boxWidth - rightBox.width)
                while ri < rightBox.height {
                    box.lines.append(pad + rightBox.lines[ri])
                    ri += 1
                }
            }
        }
        return box
    }

}

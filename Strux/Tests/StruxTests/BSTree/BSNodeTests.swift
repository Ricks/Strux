//
//  BSNodeTests.swift
//  
//
//  Created by Richard Clark on 5/14/20.
//

import Foundation

import XCTest
import Foundation
@testable import Strux

class BSNodeTests: XCTestCase {

    func testSwap() {
        let god = BNode()
        let node42 = BSNode(42, parent: god, direction: .left)
        var root = node42
        let node52 = BSNode(52, parent: root, direction: .right)
        let node51 = BSNode(51, parent: node52, direction: .left)
        let node50 = BSNode(50, parent: node51, direction: .left)
        let node66 = BSNode(66, parent: node52, direction: .right)
        root.next = node50
        node50.next = node51
        node51.next = node52
        node52.next = node66
        print("")
        print(root.descriptionWithNext)
        node66.swap(with: node52)
        print("")
        print(root.descriptionWithNext)
        node66.swap(with: node42)
        root = node66
        print("")
        print(root.descriptionWithNext)
        node50.swap(with: node51)
        print("")
        print(root.descriptionWithNext)
        node50.swap(with: node42)
        print("")
        print(root.descriptionWithNext)
        node50.swap(with: node66)
        root = node50
        print("")
        print(root.descriptionWithNext)
    }

}

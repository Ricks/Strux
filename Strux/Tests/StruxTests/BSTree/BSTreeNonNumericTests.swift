//
//  BSTreeNonNumericTests.swift
//  StruxTests
//  
//  Created by Richard Clark on 5/18/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation

import XCTest
import Foundation
@testable import Strux

class BSTreeNonNumericTests: XCTestCase {

    func testStringTree() {
        let tree = BSTree("aaron", "xenon", "Alpha", "Baretta", "Gamma", "Fred")
        print(tree)
        print(Array(tree))
    }
}

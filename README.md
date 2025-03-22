# Strux
[![Swift Versions](https://img.shields.io/badge/Swift-4%2C5-green.svg)](https://swift.org)
[![SPM Compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager/)
[![CocoaPods Version](https://img.shields.io/cocoapods/v/Strux.svg)](https://cocoapods.org/pods/Strux)
[![Test Coverage](http://scipioapps.storage.googleapis.com/mystrux/codecov.svg)](http://scipioapps.storage.googleapis.com/mystrux/codecov.html)
[![Documentation](http://scipioapps.storage.googleapis.com/mystrux/doccov.svg)](https://ricks.github.io/Strux/index.html)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/Ricks/Strux/blob/master/LICENSE)

Well-tested, fully-documented, MIT-licensed data structures written in Swift that are compatible with Swift 4 and Swift 5. Currently it has four data structures:

**[Queue](https://ricks.github.io/Strux/Structs/Queue.html)**: a queue with *O(1)* addition and removal.

**[Heap](https://ricks.github.io/Strux/Structs/Heap.html)**: a min or max heap that can be used as a priority queue.

**[BSTree](https://ricks.github.io/Strux/Classes/BSTree.html)**: a counted, self-balancing (AVL) binary search tree that conforms to the `BidirectionalCollection` protocol, with *O(N)* in-order traversal, and *O(1)* height, count, first, last, median, and (if the type is numeric) sum.

**[DisjointSetTree](https://ricks.github.io/Strux/Classes/DisjointSetTree.html)**: A disjoint set data structure, also known as
union-find, or merge-find.

## Installation

Strux requires Swift 4.0 at a minimum and supports all subsequent Swift versions. Strux can be installed via the Swift Package Manager (SPM) or CocoaPods dependency managers (see below). I recommend SPM if you're not already using CocoaPods.

Add the following line to any Swift files that reference a Strux data structure:
```swift
import Strux
```
Alternatively you can add selected Strux source files to your project.

### Swift Package Manager (SPM)

Use this repository as your dependency. In Xcode, navigate to File -> Swift Packages -> Add Package Dependency...

### CocoaPods

Use the CocoaPod `Strux`. Here is a sample Podfile:
```
target 'MyProject' do
  pod 'Strux'
end
```
With the Podfile at the top-level directory of the project, enter:
```
pod install
```

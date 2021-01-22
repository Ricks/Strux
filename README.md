# Strux
[![Swift Versions](https://img.shields.io/badge/Swift-4%2C5-green.svg)](https://swift.org)
[![SPM Compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager/)

Well-tested, fully-documented, MIT-licensed data structures written in Swift that are compatible with Swift 4 and Swift 5. Currently it has four data structures:

**[Queue](https://ricks.github.io/Strux/Structs/Queue.html)**: a queue with *O(1)* addition and removal.

**[Heap](https://ricks.github.io/Strux/Structs/Heap.html)**: a min or max heap that can be used as a priority queue.

**[BSTree](https://ricks.github.io/Strux/Classes/BSTree.html)**: a counted, self-balancing (AVL) binary search tree that conforms to the `BidirectionalCollection` protocol, with *O(N)* in-order traversal, and *O(1)* height, count, first, last, median, and (if the type is numeric) sum.

**[DisjointSet](https://ricks.github.io/Strux/Classes/DisjointSet.html)**: A disjoint set data structure, also known as
union-find, or merge-find.

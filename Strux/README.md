# Strux

Well-tested, fully-documented, MIT-licensed data structures written in Swift that are compatible with Swift 4 and Swift 5. Currently it has three data structures:

**Queue**: a queue with *O(1)* addition and removal.

**Heap**: a min or max heap that can be used as a priority queue.

**BSTree**: a counted, self-balancing (AVL) binary search tree that conforms to the `BidirectionalCollection` protocol, with *O(n)* in-order traversal, and *O(1)* height, count, min, max, and median.

# Queue

Standard queue (FIFO) - items are added at one end of the queue, and removed from the other.
`add()` and `remove()` are *O(1)* (amortized for `remove()`). Queue conforms to the `Collection` and
`ExpressibleByArrayLiteral` protocols.

```
var q = Queue<Int>()
q.isEmpty             // true
q.add(3)
q.add(7)
q.peek()              // 3
q.count               // 2
q[0]                  // 3
q[1]                  // 7
let val = q.remove()  // val = 3
q.peek()              // 7
q.contains(7)         // true
```

# Heap

Min (default) or max heap. A heap is a tree-based data structure that can be used to efficiently implement a priority queue. It gives *O(1)* read (peek) access to the min or max value, and can be updated via a pop or push in *O(log(n))* time. Removing an arbitrary element takes *O(n)* time. Heap conforms to the `Collection` protocol.
```
var pq = Heap<Int>(isMin: false, startingValues: [5, -1, 3, 42, 68, 99, 72])     // Max heap
pq.isEmpty                 // false
pq.count                   // 7
let max = pq.pop()         // max = 99, removes 99 from the heap
let currentMax = pq.peek() // currentMax = 72, leaves heap the same
pq.push(100)               // Adds 100 to the heap
pq.peek()                  // 100
pq.contains(3)             // true
pq.push(3)                 // Adds another 3
pq.remove(3)               // Removes one of the 3's from the heap
pq.push(-1)                // Adds another -1
pq.removeAll(-1)           // Removes both -1's
pq.clear()                 // Removes all values
pq.isEmpty                 // true
```

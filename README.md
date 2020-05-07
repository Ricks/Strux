# Strux

Strux contains well-tested, fully-documented data structures written in Swift that are compatible with Swift 4 and Swift 5. Currently it has three structures:

**Queue**: a queue with O(1) addition and removal.
**Heap**: a min or max heap that can be used as a priority queue.
**BSTree**: a counted, self-balancing (AVL) binary search tree that conforms to the Collection protocol, with O(n) in-order traversal, and O(1) height, count, min, and max.

# H1 Queue

Standard Queue (FIFO) type - items are added at one end of the queue, and removed from the other.
add() and remove() are O(1) (amortized for remove()). Queue conforms to the Collection and
ExpressibleByArrayLiteral protocols.

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

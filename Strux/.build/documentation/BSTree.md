# BSTree

A counted, self-balancing (AVL) binary search tree. Counted means that there are no duplicate nodes
with the same value, but values have counts associated with them. To be a valid BST, the value of the
root node must be **strictly** greater than any value in the subtree, if any, with its left child as
root, and **strictly** less than any value in the subtree, if any, with its right child as root, and
all subtrees of the tree must meet the same condition.

``` swift
public class BSTree<T: Comparable>: BNode, NSCopying, ExpressibleByArrayLiteral
```

Insertions, deletions, and queries have time complexity O(log(n)). Returning the count (of unique
values), tree height, min (first), and max (last) values are all O(1). Traversing the tree in order,
min to max, is O(n).

BSTree conforms to the Collection protocol, and meets all of Collection's expected performance
requirements (see above). It also conforms to Equatable, NSCopying, and ExpressibleByArrayLiteral.

The elements of the Collection are tuples of the form (value: T, count: Int). The indices of the
Collection are of non-numeric type BSTreeIndex<T>.

``` 
let tree: BSTree = [14, -2, 32, 14]  // BSTree is a class, so it can be a "let"
tree.insert(42, 2)             // Insert 2 of value 42
tree.deleteAll(14)             // Delete both 14's
tree.contains(value: -2)       // true
print(tree)

   32
  /  \
-2    42(2)

tree.height                    // 1
tree.count                     // 3
tree.min.value                 // -2
tree.min.count                 // 1
tree.max.value                 // 42
tree.max.count                 // 2
Array(tree)                    // [(value: -2, count: 1), (value: 32, count: 1), (value: 42, count: 2)]
```

## Inheritance

[`BNode`](BNode), `Collection`, `CustomStringConvertible`, `Equatable`, `ExpressibleByArrayLiteral`, `NSCopying`

## Nested Type Aliases

### `Element`

``` swift
public typealias Element = (value: T, count: Int)
```

### `Index`

``` swift
public typealias Index = BSTreeIndex<T>
```

## Initializers

### `init(countedSet:)`

Initialize with an NSCountedSet.

``` swift
public init(countedSet: NSCountedSet)
```

#### Parameters

  - countedSet: NSCountedSet

### `init(_:)`

Initialize with an array of values, which can contain duplicates.

``` swift
public init(_ values: [T] = [T]())
```

#### Parameters

  - values: Array

### `init(arrayLiteral:)`

Constructor using array literal. The array can contain duplicates.

``` swift
required public init(arrayLiteral values: T)
```

#### Parameters

  - values: Array literal

## Properties

### `count`

The number of elements (values) in the tree (NOT the sum of all value counts).
Time complexity: O(1)

``` swift
var count
```

### `height`

The height of the tree, i.e. the number of levels minus 1. An empty tree has a height of -1, a
tree with just a root node has height 0, and a tree with two nodes has height 1.
Time complexity: O(1)

``` swift
var height: Int
```

### `max`

The maximum element in the tree.
Time complexity: O(1)

``` swift
var max: Element?
```

### `last`

The last (maximum) element of the tree.

``` swift
var last: Element?
```

### `min`

The minimum element in the tree.
Time complexity: O(1)

``` swift
var min: Element?
```

### `isValid`

True if the tree is a valid binary search tree, meaning that the value of the root node is
greater than the value of its left child, and less than that of its right child, and all
subtrees meet the same requirement. Note that if only the public functions (insert and delete)
are used to modify the tree, it should always be valid.

``` swift
var isValid: Bool
```

### `isBalanced`

True if the tree is balanced, meaning that the height of the left subtree of the root is no more
than one different from the height of the right subtree, and all subtrees meet the same
requirement. Note that if only the public functions (insert and delete) are used to modify the
tree, it should always be balanced.

``` swift
var isBalanced: Bool
```

### `description`

An ASCII-graphics depiction of the tree

``` swift
var description: String
```

### `descriptionWithHeight`

An ASCII-graphics depiction of the tree, with the height of each node given

``` swift
var descriptionWithHeight: String
```

### `descriptionWithNext`

An ASCII-graphics depiction of the tree, with the next node for each node shown (i.e. the nodes
in increasing order of value).

``` swift
var descriptionWithNext: String
```

### `startIndex`

``` swift
var startIndex: Index
```

### `endIndex`

``` swift
var endIndex: Index
```

## Methods

### `indexOf(_:)`

Return the index (BSTreeIndex) of the value, or nil if the tree doesn't have the value.
Time complexity: O(log(n))

``` swift
public func indexOf(_ val: T) -> Index?
```

#### Parameters

  - val: The value to look for

#### Returns

index (optional)

### `contains(value:)`

Return true if the tree contains the given value, false otherwise.
Time complexity: O(log(n))

``` swift
public func contains(value: T) -> Bool
```

#### Parameters

  - value: The value to look for

#### Returns

true or false

### `count(of:)`

Returns the count of the value in the tree. Zero if the tree doesn't contain the value.
Time complexity: O(log(n))

``` swift
public func count(of val: T) -> Int
```

#### Parameters

  - value: The value get the count of

#### Returns

Integer count

### `insert(_:_:)`

Insert the given number of the given value into the tree. If the value is already in the tree,
the count is incremented by the given number.
Time complexity: O(log(n))

``` swift
public func insert(_ val: T, _ n: Int)
```

#### Parameters

  - val: The value to insert n of
  - n: The number of val to insert

### `insert(_:)`

Insert one of the given value into the tree. If the value is already in the tree,
the count is incremented by one.
Time complexity: O(log(n))

``` swift
public func insert(_ val: T)
```

#### Parameters

  - val: The value to insert one of

### `delete(_:_:)`

Delete the given number of the given value from the tree. If the given number is \>= the number
of the value in the tree, the value is removed completed.
Time complexity: O(log(n))

``` swift
public func delete(_ val: T, _ n: Int)
```

#### Parameters

  - val: The value to remove n of
  - n: The number of val to remove

### `delete(_:)`

Delete one of the given value from the tree. If the number of the value already in the tree is
more than one, the number is decremented by one, otherwise the value is removed from the tree.
Time complexity: O(log(n))

``` swift
public func delete(_ val: T)
```

#### Parameters

  - val: The value to remove one of

### `deleteAll(_:)`

Delete all occurrences of the given value from the tree.
Time complexity: O(log(n))

``` swift
public func deleteAll(_ val: T)
```

#### Parameters

  - val: The value to remove all occurrences of

### `traverseInOrder()`

Return the elements of the tree "in order" (from min to max).
Time complexity: O(n)

``` swift
public func traverseInOrder() -> [Element]
```

#### Returns

An array of elements

### `traversePreOrder()`

Return the elements of the tree in "pre" order, meaning that the root is the first
element returned.

``` swift
public func traversePreOrder() -> [Element]
```

#### Returns

An array of elements

### `traversePostOrder()`

Return the elements of the tree in "post" order, meaning that the root is the last
element returned.

``` swift
public func traversePostOrder() -> [Element]
```

#### Returns

An array of elements

### `traverseLevelNodes()`

Return the elements of the tree in "level" order, starting with the root and working downward.

``` swift
public func traverseLevelNodes() -> [Element]
```

#### Returns

An array of elements

### `toCountedSet()`

Returns an NSCountedSet with the same values and counts as the tree.

``` swift
public func toCountedSet() -> NSCountedSet
```

#### Returns

NSCountedSet

### `copy(with:)`

Returns a copy of the tree (a shallow copy if T is a reference type).

``` swift
public func copy(with zone: NSZone? = nil) -> Any
```

### `==(lhs:rhs:)`

``` swift
public static func ==(lhs: BSTree<T>, rhs: BSTree<T>) -> Bool
```

### `index(after:)`

``` swift
public func index(after i: Index) -> Index
```

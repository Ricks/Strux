//
//  BSNodeAVL.swift
//  DataStructures
//
//  Created by Richard Clark on 4/25/20.
//  Copyright © 2020 Richard Clark. All rights reserved.
//  MIT License (see LICENSE file).
//

import Foundation

// The AVL algorithm methods
extension BSNode {

    @discardableResult
    func updateHeight() -> Bool {
        let newHeight = 1 + max(leftHeight, rightHeight)
        let changed = newHeight != height
        height = newHeight
        return changed
    }

    // After rotation, the only nodes whose height can be different are the rotated node (previous root
    // of the subtree), and its parent (new root node of the subtree). The height of the sibling node
    // may also have changed, but that's taken care of by the recursive rotation call.
    private func updateHeightAfterRotation() {
        updateHeight()
        let bsParent = parent as! BSNode
        bsParent.updateHeight()
    }

    // Rotate Left
    //
    // Case 1: nodeB is leaf.
    //
    //         42                70
    //           \     --->     /
    //   nodeB -> 70          42
    //
    // Case 2: nodeB has right child only.
    //
    //         42
    //           \                  70
    //   nodeB -> 70      --->     /  \
    //              \            42    99
    //               99
    //
    // Case 3: nodeB has left child only - requires a first (right) rotation of nodeB in which nodeB becomes 66
    // in the example.
    //
    //         42                    42
    //           \                     \                  66
    //   nodeB -> 70   --->    nodeB -> 66      --->     /  \
    //           /                        \            42    70
    //         66                          70
    //
    // Case 4: nodeB has two children - note that 66, the left child of nodeB, becomes the right child of
    // the current node (42). This is handled by the code "right = nodeB.left". In cases 1, 2, and 3, that
    // line nils out the right child of the current node.
    //
    //         42                   __70_
    //           \                 /     \
    //   nodeB -> 70      --->   42       99
    //           /  \              \
    //         66    99             66
    func rotateLeft() {
        guard var nodeB = right else { return }
        if nodeB.leftHeight > nodeB.rightHeight {
            // Special case that needs a double rotation
            nodeB.rotateRight()
            nodeB = right!
        }
        replace(with: nodeB)   // nodeB becomes root of subtree
        right = nodeB.left     // See note for Case 4
        nodeB.left = self
        updateHeightAfterRotation()
    }

    // Rotate Right
    //
    // Case 1: nodeB is leaf.
    //
    //               42          16
    //              /     --->     \
    //   nodeB -> 16                42
    //
    // Case 2: nodeB has left child only.
    //
    //               42
    //              /               16
    //   nodeB -> 16      --->     /  \
    //           /                8    42
    //          8
    //
    // Case 3: nodeB has right child only - requires a first (left) rotation of nodeB in which nodeB becomes 29
    // in the example.
    //
    //               42                      42
    //              /                       /               29
    //   nodeB -> 16      --->   nodeB -> 29      --->     /  \
    //              \                    /               16    42
    //               29                16
    //
    // Case 4: nodeB has two children - note that 29, the right child of nodeB, becomes the left child of
    // the current node (42). This is handled by the code "left = nodeB.right". In cases 1, 2, and 3, that
    // line nils out the left child of the current node.
    //
    //               42                _16__
    //              /                 /     \
    //   nodeB -> 16      --->       8       42
    //           /  \                       /
    //          8    29                   29
    func rotateRight() {
        guard var nodeB = left else { return }
        if nodeB.leftHeight < nodeB.rightHeight {
            // Special case that needs a double rotation
            nodeB.rotateLeft()
            nodeB = left!
        }
        replace(with: nodeB)
        left = nodeB.right
        nodeB.right = self
        updateHeightAfterRotation()
    }

    // If the node has become unbalanced, rotate to balance it. Adjust the height of the subtree having
    // this node as root. If the height changes, invoke this method on the parent.
    func rebalanceIfNecessary() {
        let bsParent = parent as? BSNode  // Save now because rotation will change it
        var rotated = false
        if leftHeight < rightHeight - 1 {
            rotateLeft()
            rotated = true
        } else if rightHeight < leftHeight - 1 {
            rotateRight()
            rotated = true
        }
        if rotated || updateHeight() {   // Rotation takes care of updating height
            bsParent?.rebalanceIfNecessary()
        }
    }

}

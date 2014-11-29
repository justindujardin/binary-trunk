###
   Binary Trunk Test Suite
   Copyright 2012-2014 Justin DuJardin and Contributors
   Licensed under MIT (https://github.com/justindujardin/binary-trunk/blob/master/LICENSE)
###

# This is the test-suite for [binary-trunk](./index.html).

# ## Binary Tree Node
module 'BinaryTrees'

# **should accept children in the constructor**

# check that the children passed in the constructor are properly assigned,
# and that their `parent` variables are also set to the root node properly.
test 'BinaryTreeNode.constructor', ->
  tree = new DJC.BinaryTreeNode new DJC.BinaryTreeNode, new DJC.BinaryTreeNode
  equal tree.left != null and tree.right != null, true,
    'children assigned properly by constructor'
  count = 0 
  tree.visitInorder (node) -> count++
  equal count, 3,
    'expected tree node count'
  equal tree.left.parent is tree, true, 
    'left child parent assigned properly'
  equal tree.right.parent is tree, true, 
    'right child parent assigned properly'

# **should be able to be cloned to form copies of existing trees**

# check to be sure that when we clone off a known node of the tree
# that its children, and only its children, are still searchable 
# from the cloned tree.
test 'BinaryTreeNode.clone', ->
  tree = new DJC.BinarySearchTree 0
  tree.insert i for i in [0..25]
  fifteen = tree.find 15
  equal fifteen != null, true,
    'find isolation node'
  clone = fifteen.clone()
  equal clone.getRoot() == clone, true,
    'clone node becomes root'
  count = 0
  clone.visitInorder -> count++
  equal count, 11, 
    'clone node has expected 11 remaining nodes'

# **should support identifying as a leaf node**

# check that the known extremes of a tree are reported as leaf nodes
# and that all other known non-extremes are not.
test 'BinaryTreeNode.isLeaf', ->
  tree = new DJC.BinarySearchTree 0
  tree.insert i for i in [-1..5]
  equal tree.find(-1).isLeaf(), true, 
    'left leaf'
  equal tree.find(5).isLeaf(), true, 
    'right leaf'    
  equal tree.find(n).isLeaf(), false for n in [0..4]

# **should support node rotations**

# test to ensure that rotations do not compromise the search tree
# by randomly rotating nodes, and verifying that all known numbers
# can still be found.
test 'BinaryTreeNode.rotate', ->
  values = [-5..5]
  tree = new DJC.BinarySearchTree 0
  tree.insert i for i in values
  for i in [1..10000]
    index = Math.floor(Math.random() * values.length)
    node = tree.find values[index]
    node.rotate()
    node.parent.getSide node if node.parent 
  equal tree.find(v) != null, true for v in values

# **should support preorder visiting**

# check the order in which the nodes are visited against what is 
# expected for a preorder tree visit.
test 'BinaryTreeNode.visitPreorder', -> 
  values = [-1,0,1]
  order = [0,-1,1]
  tree = new DJC.BinarySearchTree 0
  tree.insert i for i in values
  tree.visitPreorder (node) -> 
    equal node.key, order.shift()

# check that returning `node.STOP` cancels visits.
test 'BinaryTreeNode.visit[Pre/In/Post]order (Stop)', ->
  values = [-1,0,1]
  tree = new DJC.BinarySearchTree 0
  tree.insert i for i in values

  total = 0
  tree.visitPreorder (node) ->
    total += 1
    return DJC.BT.STOP if node.key == -1
  equal total, 2, 'preorder stops at second node'

  total = 0
  tree.visitInorder (node) ->
    total += 1
    return DJC.BT.STOP if node.key == -1
  equal total, 1, 'inorder stops at first node'

  total = 0
  tree.visitPostorder (node) ->
    total += 1
    return DJC.BT.STOP if node.key == -1
  equal total, 1, 'postorder stops at first node'


# **should support inorder visiting**

# check the order in which the nodes are visited against what is 
# expected for a inorder tree visit.
test 'BinaryTreeNode.visitInorder', ->
  values = [-1,0,1]
  order = [-1,0,1]
  tree = new DJC.BinarySearchTree 0
  tree.insert i for i in values
  tree.visitInorder (node) -> 
    equal node.key, order.shift()

# **should support postorder visiting**

# check the order in which the nodes are visited against what is 
# expected for a postorder tree visit.
test 'BinaryTreeNode.visitPostorder', ->
  values = [-1,0,1]
  order = [-1,1,0]
  tree = new DJC.BinarySearchTree 0
  tree.insert i for i in values
  tree.visitPostorder (node) -> 
    equal node.key, order.shift()

# **should have a convenience for root location**

# verify that `getRoot` is working as expected by checking that
# every node in the tree returns the same value when it is invoked.
test 'BinaryTreeNode.getRoot', ->
  values = [-5..5]
  tree = new DJC.BinarySearchTree 0
  tree.insert i for i in values
  equal tree.find(n).getRoot() is tree, true for n in values

# **should have a left child setter**

# verify that the left child setter properly assigns parent link.
test 'BinaryTreeNode.setLeft', -> 
  one = new DJC.BinaryTreeNode 
  two = new DJC.BinaryTreeNode
  one.setLeft two
  equal one.left is two, true, 
    'left child is expected'
  equal two.parent is one, true,
    'parent is properly assigned'

# **should have a right child setter**

# verify that the right child setter properly assigns parent link.
test 'BinaryTreeNode.setRight', -> 
  one = new DJC.BinaryTreeNode 
  two = new DJC.BinaryTreeNode
  one.setRight two
  equal one.right is two, true, 
    'left child is expected'
  equal two.parent is one, true,
    'parent is properly assigned'


# **should be able to return which side of a parent this node is on**

# check that a node reports the side as expected from a tree with a 
# known structure.  Because of the insertion order all numbers less 
# than 0 should be left children of their parents, and all numbers 
# greater than 0 should be right children of theirs.
#  
# In the event that a node is passed that is not a child, an exception
# will be thrown.
test 'BinaryTreeNode.getSide', ->
  values = [-1,-2,-3,-4,1,2,3,4]
  tree = new DJC.BinarySearchTree 0
  tree.insert i for i in values
  node = tree.find -4
  equal node.parent.getSide(node), 'left', 
    'found child on expected side of parent' 
  node = tree.find 4
  equal node.parent.getSide(node), 'right', 
    'found child on expected side of parent'
  throws -> node.parent.getSide(tree)

# **should be able to set a child to a given side by side name**

# check that a child node, assigned with `setSide` is assigned to 
# the proper left or right node on the new parent.
#  
# check that an exception is thrown when a bad side string is passed.
test 'BinaryTreeNode.setSide', ->
  tree = new DJC.BinaryTreeNode
  one = new DJC.BinaryTreeNode
  two = new DJC.BinaryTreeNode
  tree.setSide one, 'left'
  equal tree.left is one, true, 
    'child assigned to left properly'
  tree.setSide two, 'right'
  equal tree.right is two, true, 
    'child assigned to right properly'
  throws -> tree.setSide node, 'rihgt'

# **should be able to return children as a list**

# check a few permutations of expected results from getChildren.  
test 'BinaryTreeNode.getChildren', ->
  values = [-2,-1,-3,0,1,2]
  tree = new DJC.BinarySearchTree 0
  tree.insert i for i in values 
  neg = tree.find(-2).getChildren()
  equal neg.length, 2, 'expect two children of -1'
  equal neg[0].key, -3, 'expect left child of -1 to first'
  equal neg[1].key, -1, 'expect right child of -1 to second'
  one = tree.find(1).getChildren()
  equal one.length, 1, 'expect one child of 1'
  equal one[0].key, 2, 'expect child of 1 to be 2'
  two = tree.find(2).getChildren()
  equal two.length, 0, 'expect no children for 2'


# **should have a convenience for getting a node's sibling**

# check that siblings are reported properly for a known tree
# structure.
test 'BinaryTreeNode.getSibling', ->
  tree = new DJC.BinaryTreeNode new DJC.BinaryTreeNode, new DJC.BinaryTreeNode
  equal tree.left.getSibling() is tree.right, true,
    'left sibling is right' 
  equal tree.right.getSibling() is tree.left, true,
    'right sibling is left' 
  equal tree.getSibling(), undefined, 
    'root has no sibling'

# ## Binary Search Tree

# **should insert values into tree**

# Check that after a known number of inserts, there are the expected
# number of nodes in the tree.
test 'BinarySearchTree.insert', ->
  tree = new DJC.BinarySearchTree 0
  tree.insert i for i in [-25..25]
  count = 0
  tree.visitInorder (node) -> count++
  equal count, 51,
    'expect 51 nodes in search tree after 51 value inserts'
  
# **should find nodes by key**

# check that after known inserts, find returns the expected results,
# and that invalid finds return null.
test 'BinarySearchTree.find', ->
  tree = new DJC.BinarySearchTree 0
  tree.insert i for i in [-25,1337,2]
  
  equal tree.find(-25)  != null, true
  equal tree.find(1337) != null, true
  equal tree.find(2)    != null, true

  equal tree.find(null) == null, true
  equal tree.find(-33)  == null, true
  equal tree.find(25)   == null, true

# ## Visual Tree Layout

# **should layout tree without error**

# check that the tidier tree layout algorithm succeeds without exception,
# and that it returns a non-null result.
test 'BinaryTreeTidier.layout', ->
  tree = new DJC.BinarySearchTree 0
  tree.insert val for val in [-100..100]
  result = new DJC.BinaryTreeTidier().layout tree
  equal result != null, true,
    'expect a result from tidier layout pass'
  @

# **should satisfy 'y-coordinate sharing' aesthetic**

# check that aesthetic 1 is satisfied by: building a tree, gathering up all 
# the nodes, grouping them by their depth, and then asserting that each node
# in a depth group has the same y-coordinate.
test 'BinaryTreeTidier.layout (Aesthetic 1)', ->
  tree = new DJC.BinarySearchTree 0
  tree.insert val for val in [-5..5]
  tidier = new DJC.BinaryTreeTidier
  tidier.layout tree
  nodeGroups = {}
  tree.visitPreorder (node,depth) -> 
    nodeGroups[depth] = [] if not nodeGroups[depth]
    nodeGroups[depth].push node
  for k, v of nodeGroups
    yCoords = _.map v, (node) -> node.y
    equal _.uniq(yCoords).length, 1, 
      'nodes in depth group share y-coordinate'
  @

# **should satisfy 'children relative position' aesthetic**

# check that aesthetic 2 is satisfied by: building a tree, visiting each 
# node, asserting that its left and right children are positioned to the 
# left and right of it.
test 'BinaryTreeTidier.layout (Aesthetic 2)', ->
  tree = new DJC.BinarySearchTree 0
  tree.insert val for val in [-2,-1,-3,2,3,1]
  tidier = new DJC.BinaryTreeTidier
  tidier.layout tree
  nodes = []
  tree.visitPostorder (node) ->
   parent = node.parent
   return if not parent
   side = node.parent.getSide node
   if side == 'left'
      equal node.x < node.parent.x, true,
         "Left child (#{node.x}) positioned to the left of its parent (#{node.parent.x})"
   else
      equal node.x > node.parent.x, true,
         "Right child (#{node.x}) positioned to the right of its parent (#{node.parent.x})"
  @

# **should satisfy 'equidistant children' aesthetic**

# check that aesthetic 3 is satisfied by: building a tree, visiting each 
# node, and if it's a non-root node, checking that its children are 
# equidistant from it.
test 'BinaryTreeTidier.layout (Aesthetic 3)', ->
  tidier = new DJC.BinaryTreeTidier
  tree = new DJC.BinarySearchTree 0
  tree.insert val for val in [-2,-1,-3,2,3,1]
  tidier.layout tree
  nodes = []
  tree.visitPostorder (node) ->
    children = node.getChildren()
    return if children.length != 2
    left = children[0].x
    right = children[1].x
    expected = left + Math.abs(left - right) / 2
    equal expected, node.x,
      "parent node position (#{node.x}) matches expected"
  @

# **should satisfy 'subtree reflections' aesthetic**

# check that aesthetic 4 reflection is satisfied by: building a tree, visiting
# the nodes in the right side of the tree, and asserting that each mirrored node
# on the left side is the same distance from the root as it.
test 'BinaryTreeTidier.layout (Aesthetic 4.1)', ->
  tree = new DJC.BinarySearchTree 0
  tree.insert val for val in [-2,-1,-4,-3,-5]
  tree.insert val for val in [2,1,4,3,5]
  tidier = new DJC.BinaryTreeTidier
  tidier.layout tree
  nodes = []
  for i in [1...5]
    left = tree.find -i
    right = tree.find i
    leftDist = Math.abs left.x - tree.x
    rightDist = Math.abs right.x - tree.x
    equal leftDist,rightDist,
      'Reflected nodes should be equidistant from root'

# **should satisfy 'subtree identical regardless of position' aesthetic**

# check that aesthetic 4 position independence is satisfied by: building a tree, 
# picking known nodes that are identical but in different positions of the tree,
# and ensuring that their children are positioned the same.
test 'BinaryTreeTidier.layout (Aesthetic 4.2)', ->
  tree = new DJC.BinarySearchTree 0
  tree.insert val for val in [7,4,3,5,13,12,14,-3,-6,-2,-7,-13,-14,-12]
  tidier       = new DJC.BinaryTreeTidier
  result       = tidier.layout tree
  nodes        = []
  lDistance = rDistance = undefined
  tree.visitPreorder (node) ->
    return if node.key != 13 and node.key != -13
    equal node.left.key, node.key - 1, 'expect lesser value to the left'
    equal node.right.key, node.key + 1, 'expect greater value to the right'
    three = node.x
    less = node.left.x
    more = node.right.x
    leftDistance = less - three
    rightDistance = more - three
    if lDistance and rDistance
      equal lDistance, leftDistance,
        'left child distances match'
      equal rDistance, rightDistance,
        'right child distances match'
    lDistance = leftDistance
    rDistance = rightDistance
  @



module 'BinaryTreeNode'

# **should accept children in the constructor**

# check that the children passed in the constructor are properly assigned,
# and that their `parent` variables are also set to the root node properly.
test 'constructor', ->
  tree = new DJC.BinaryTreeNode new DJC.BinaryTreeNode, new DJC.BinaryTreeNode
  equals tree.left != null and tree.right != null, true,
    'children assigned properly by constructor'
  count = 0 
  tree.visitInorder (node) -> count++
  equals count, 3,
    'expected tree node count'
  equals tree.left.parent is tree, true, 
    'left child parent assigned properly'
  equals tree.right.parent is tree, true, 
    'right child parent assigned properly'

# **should be able to be cloned to form copies of existing trees**

# check to be sure that when we clone off a known node of the tree
# that its children, and only its children, are still searchable 
# from the cloned tree.
test 'clone', ->
  tree = new DJC.BinarySearchTree 0
  tree.insert i for i in [0..25]
  fifteen = tree.find 15
  equals fifteen != null, true,
    'find isolation node'
  clone = fifteen.clone()
  equals clone.getRoot() == clone, true,
    'clone node becomes root'
  count = 0
  clone.visitInorder -> count++
  equals count, 11, 
    'clone node has expected 11 remaining nodes'

# **should support identifying as a leaf node**

# check that the known extremes of a tree are reported as leaf nodes
# and that all other known non-extremes are not.
test 'isLeaf', ->
  tree = new DJC.BinarySearchTree 0
  tree.insert i for i in [-1..5]
  equals tree.find(-1).isLeaf(), true, 
    'left leaf'
  equals tree.find(5).isLeaf(), true, 
    'right leaf'    
  equals tree.find(n).isLeaf(), false for n in [0..4]

# **should support node rotations**

# test to ensure that rotations do not compromise the search tree
# by randomly rotating nodes, and verifying that all known numbers
# can still be found.
test 'rotate', ->
  values = [-5..5]
  tree = new DJC.BinarySearchTree 0
  tree.insert i for i in values
  for i in [1..100]
    index = Math.floor(Math.random() * values.length)
    node = tree.find values[index]
    node.rotate()
  equals tree.find(v) != null, true for v in values

# **should support preorder visiting**

# check the order in which the nodes are visited against what is 
# expected for a preorder tree visit.
test 'visitPreorder', -> 
  values = [-1,0,1]
  order = [0,-1,1]
  tree = new DJC.BinarySearchTree 0
  tree.insert i for i in values
  tree.visitPreorder (node) -> 
    equals node.key, order.shift()

# **should support inorder visiting**

# check the order in which the nodes are visited against what is 
# expected for a inorder tree visit.
test 'visitInorder', ->
  values = [-1,0,1]
  order = [-1,0,1]
  tree = new DJC.BinarySearchTree 0
  tree.insert i for i in values
  tree.visitInorder (node) -> 
    equals node.key, order.shift()

# **should support postorder visiting**

# check the order in which the nodes are visited against what is 
# expected for a postorder tree visit.
test 'visitPostorder', ->
  values = [-1,0,1]
  order = [-1,1,0]
  tree = new DJC.BinarySearchTree 0
  tree.insert i for i in values
  tree.visitPostorder (node) -> 
    equals node.key, order.shift()

# **should have a convenience for root location**

# verify that `getRoot` is working as expected by checking that
# every node in the tree returns the same value when it is invoked.
test 'getRoot', ->
  values = [-5..5]
  tree = new DJC.BinarySearchTree 0
  tree.insert i for i in values
  equals tree.find(n).getRoot() is tree, true for n in values

# **should have a left child setter**

# verify that the left child setter properly assigns parent link.
test 'setLeft', -> 
  one = new DJC.BinaryTreeNode 
  two = new DJC.BinaryTreeNode
  one.setLeft two
  equals one.left is two, true, 
    'left child is expected'
  equals two.parent is one, true,
    'parent is properly assigned'

# **should have a right child setter**

# verify that the right child setter properly assigns parent link.
test 'setRight', -> 
  one = new DJC.BinaryTreeNode 
  two = new DJC.BinaryTreeNode
  one.setRight two
  equals one.right is two, true, 
    'left child is expected'
  equals two.parent is one, true,
    'parent is properly assigned'


# **should be able to return which side of a parent this node is on**

# check that a node reports the side as expected from a tree with a 
# known structure.  Because of the insertion order all numbers less 
# than 0 should be left children of their parents, and all numbers 
# greater than 0 should be right children of theirs.
#  
# In the event that a node is passed that is not a child, an exception
# will be thrown.
test 'getSide', ->
  values = [-1,-2,-3,-4,1,2,3,4]
  tree = new DJC.BinarySearchTree 0
  tree.insert i for i in values
  node = tree.find -4
  equals node.parent.getSide(node), 'left', 
    'found child on expected side of parent' 
  node = tree.find 4
  equals node.parent.getSide(node), 'right', 
    'found child on expected side of parent'
  raises -> node.parent.getSide(tree)

# **should be able to set a child to a given side by side name**

# check that a child node, assigned with `setSide` is assigned to 
# the proper left or right node on the new parent.
#  
# check that an exception is thrown when a bad side string is passed.
test 'setSide', ->
  tree = new DJC.BinaryTreeNode
  one = new DJC.BinaryTreeNode
  two = new DJC.BinaryTreeNode
  tree.setSide one, 'left'
  equals tree.left is one, true, 
    'child assigned to left properly'
  tree.setSide two, 'right'
  equals tree.right is two, true, 
    'child assigned to right properly'
  raises -> tree.setSide node, 'rihgt'

# **should be able to return children as a list**

# check a few permutations of expected results from getChildren.  
test 'getChildren', ->
  values = [-2,-1,-3,0,1,2]
  tree = new DJC.BinarySearchTree 0
  tree.insert i for i in values 
  neg = tree.find(-2).getChildren()
  equals neg.length, 2, 'expect two children of -1'
  equals neg[0].key, -3, 'expect left child of -1 to first'
  equals neg[1].key, -1, 'expect right child of -1 to second'
  one = tree.find(1).getChildren()
  equals one.length, 1, 'expect one child of 1'
  equals one[0].key, 2, 'expect child of 1 to be 2'
  two = tree.find(2).getChildren()
  equals two.length, 0, 'expect no children for 2'


# **should have a convenience for getting a node's sibling**

# check that siblings are reported properly for a known tree
# structure.
test 'getSibling', ->
  tree = new DJC.BinaryTreeNode new DJC.BinaryTreeNode, new DJC.BinaryTreeNode
  equals tree.left.getSibling() is tree.right, true,
    'left sibling is right' 
  equals tree.right.getSibling() is tree.left, true,
    'left sibling is right' 
  equals tree.getSibling(), undefined, 
    'root has no sibling'

module 'BinarySearchTree'

test 'insert [value]', ->
	tree = new DJC.BinarySearchTree 0
	tree.insert i for i in [-25..25]
	count = 0
	tree.visitInorder (node) -> count++
	equals count, 51,
		'expect 51 nodes in search tree after 51 value inserts'

test 'insert [array]', ->
  tree = new DJC.BinarySearchTree [-25..25]
  

test 'find', ->
  tree = new DJC.BinarySearchTree 0
  tree.insert i for i in [-25,1337,2]
  
  equals tree.find(-25)  != null, true
  equals tree.find(1337) != null, true
  equals tree.find(2)    != null, true

  equals tree.find(null) == null, true
  equals tree.find(-33)  == null, true
  equals tree.find(25)   == null, true

module 'TreeLayout'

test 'Reingold-Tilford', ->

  tree = new DJC.BinarySearchTree 0
  tree.insert val for val in [-100..100]
  result = new DJC.BinaryTreeTidier().layout tree
  equals result != null, true,
    'expect a result from tidier layout pass'
  @

test 'Aesthetic 1 - all nodes at a given depth share the same y coordinate', ->
  tree = new DJC.BinarySearchTree 0
  tree.insert val for val in [-25..25]
  tidier = new DJC.BinaryTreeTidier
  tidier.layout tree
  nodes = []
  tree.visitPreorder (node) -> nodes.push node
  nodeGroups = _.groupBy nodes, (node) -> node.y
  for k, v of nodeGroups
    yCoords = _.map v, (node) -> node.y
    equals _.uniq(yCoords).length, 1
  @

test 'Aesthetic 2 - left and right children should be to the left and right of the parent in space', ->
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
      equals node.x < node.parent.x, true,
         "Left child (#{node.x}) positioned to the left of its parent (#{node.parent.x})"
   else
      equals node.x > node.parent.x, true,
         "Right child (#{node.x}) positioned to the right of its parent (#{node.parent.x})"
  @

test 'Aesthetic 3 - children should positioned equidistant from parent', ->
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
    equals expected, node.x,
      "parent node position (#{node.x}) matches expected"
  @

test 'Aesthetic 4.1 - mirrored subtrees should be reflections of each other visually', ->
  tree = new DJC.BinarySearchTree 0
  tree.insert val for val in [1..5]
  tree.insert val for val in [-5..-1]
  tidier = new DJC.BinaryTreeTidier
  tidier.layout tree
  nodes = []
  @

test 'Aesthetic 4.2 - identical subtrees should be rendered the identically, regardless of position', ->
  tree = new DJC.BinarySearchTree 0
  tree.insert val for val in [3,2,4,-3,-4,-2]
  tidier       = new DJC.BinaryTreeTidier
  result       = tidier.layout tree
  nodes        = []
  lDistance = rDistance = undefined
  tree.visitPreorder (node) ->
    return if node.key != 3 and node.key != -3
    equals node.left.key, node.key - 1, 'expect lesser value to the left'
    equals node.right.key, node.key + 1, 'expect greater value to the right'
    three = node.x
    less = node.left.x
    more = node.right.x
    leftDistance = less - three
    rightDistance = more - three
    if lDistance and rDistance
      equals lDistance, leftDistance,
        'left child distances match'
      equals rDistance, rightDistance,
        'right child distances match'
    lDistance = leftDistance
    rDistance = rightDistance
  @


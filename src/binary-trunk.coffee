# [github]: https://github.com/justindujardin/binary-trunk
# [issues]: https://github.com/justindujardin/binary-trunk/issues
# [wiki]: https://github.com/justindujardin/binary-trunk/wiki
# [license]: https://github.com/justindujardin/binary-trunk/blob/master/LICENSE
# [binary-trunk]: ./index.html
# [testcode]: ./binary-trunk.test.html
# [tests]: ./tests.html
# [node]: #BinaryTreeNode
# [search]: #BinarySearchTree
# [layout]: #BinaryTreeTidier

# [binary-trunk][] tries to make working with **binary trees** in *CoffeeScript* and 
# *Javascript* easy, by providing a well-equipped *[tree node][node]*, example 
# *[search tree][search]* implementation, and a *[layout algorithm][layout]*
# implementation for visualizing the contents of your trees.
#  
# The [source code][github] is available under the [MIT license][license], there is 
# a [thorough test-suite][tests], with accompanying [annotated test-suite code][testcode]
#  
root = this
DJC = root.DJC = root.DJC or {}

# ## Constants
DJC.BT = BT =
  # Return this from a node visit function to abort a tree visit.
  STOP : 'stop'
  # The constant representing the left child side of a node.
  LEFT : 'left'
  # The constant representing the right child side of a node.
  RIGHT: 'right'

# ## <a id="BinaryTreeNode"></a>BinaryTreeNode


# The binary tree node is the base node for all of our trees, and provides a
# rich set of methods for constructing, inspecting, and modifying them.
#  
# The node itself defines the structure of the binary tree, having left and right
# children, and a parent.
class DJC.BinaryTreeNode

  # Allow specifying children in the constructor
  constructor:(left,right) ->
    @setLeft left if left
    @setRight right if right
    @parent ?= undefined

  # Create a clone of this tree
  clone:() ->
    result = new @.constructor()  
    result.setLeft @left.clone() if @left
    result.setRight @right.clone() if @right
    result

  # Is this node a leaf?  A node is a leaf if it has no children.
  isLeaf:() -> not @left and not @right

  # Serialize the node as a string
  toString:() -> "#{@left} #{@right}"

  # Rotate a node, changing the structure of the tree, without modifying
  # the order of the nodes in the tree.
  rotate:() -> 
    node = @
    parent = @parent
    return if not node or not parent
    grandParent = @parent.parent
    if node == parent.left
      parent.setLeft node.right
      node.right = parent
      parent.parent = node
    else
      parent.setRight node.left
      node.left = parent
      parent.parent = node
    node.parent = grandParent
    return if not grandParent
    if parent is grandParent.left
      grandParent.left = node
    else
      grandParent.right = node
    
  # **Tree Traversal**
  #  
  # Each visit method accepts a function that will be invoked for each node in the 
  # tree.  The callback function is passed three arguments: the node being
  # visited, the current depth in the tree, and a user specified data parameter.
  #  
  # *Traversals may be canceled by returning `DJC.BT.STOP` from any visit function.*

  # Preorder : *Visit -> Left -> Right*
  visitPreorder:(visitFunction, depth=0, data) ->
    return BT.STOP if visitFunction and visitFunction(@, depth, data) == BT.STOP
    return BT.STOP if @left and @left.visitPreorder(visitFunction, depth+1, data) == BT.STOP
    return BT.STOP if @right and @right.visitPreorder(visitFunction, depth+1, data) == BT.STOP
  # Inorder : *Left -> Visit -> Right*
  visitInorder:(visitFunction, depth=0, data) ->
    return BT.STOP if @left and @left.visitInorder(visitFunction, depth+1,data) == BT.STOP
    return BT.STOP if visitFunction and visitFunction(@, depth, data) == BT.STOP
    return BT.STOP if @right and @right.visitInorder(visitFunction, depth+1, data) == BT.STOP
  # Postorder : *Left -> Right -> Visit*
  visitPostorder:(visitFunction, depth=0, data) ->
    return BT.STOP if @left and @left.visitPostorder(visitFunction, depth+1, data) == BT.STOP
    return BT.STOP if @right and @right.visitPostorder(visitFunction, depth+1, data) == BT.STOP
    return BT.STOP if visitFunction and visitFunction(@, depth, data) == BT.STOP
  
  # Return the root element of this tree
  getRoot:() ->
    result = @
    result = result.parent while result.parent
    return result

  # **Child Management**
  #  
  # Methods for setting the children on this expression.  These take care of
  # making sure that the proper parent assignments also take place.

  # Set the left node to the passed `child`
  setLeft:(child) ->
    @left = child
    @left?.parent = this

  # Set the right node to the passed `child`
  setRight:(child) ->
    @right = child
    @right?.parent = this

  # Determine whether the given `child` is the left or right child of this node
  getSide:(child) ->
    return BT.LEFT if child == @left
    return BT.RIGHT if child == @right
    throw new Error "BinaryTreeNode.getSide: not a child of this node"

  # Set a new `child` on the given `side`
  setSide:(child,side) ->
    switch side
      when BT.LEFT then @setLeft(child)
      when BT.RIGHT then @setRight(child)
      else throw new Error "BinaryTreeNode.setSide: Invalid side"

  # Get children as an array.  If there are two children, the first object will 
  # always represent the left child, and the second will represent the right.
  getChildren:() ->
    result = []
    result.push @left if @left
    result.push @right if @right
    result

  # Get the sibling node of this node.  If there is no parent, or the node has no
  # sibling, the return value will be undefined.
  getSibling:() ->
    return if not @parent
    return @parent.right if @parent.left is @
    return @parent.left if @parent.right is @

# ## <a id="BinarySearchTree"></a>BinarySearchTree

# A very simple binary search tree that relies on keys that support 
# operator value comparison.
class DJC.BinarySearchTree extends DJC.BinaryTreeNode
  constructor:(@key) -> super()
  clone:() ->
    result = super()
    result.key = @key
    result

  # Insert a node in the tree with the specified key.
  insert:(key) ->
    node = @getRoot()
    while node
      if key > node.key
        if not node.right
          node.setRight new BinarySearchTree key
          break
        node = node.right
      else if key < node.key 
        if not node.left 
          node.setLeft new BinarySearchTree key
          break
        node = node.left
      else
        break
    @
  # Find a node in the tree by its key and return it.  Return null if the key
  # is not found in the tree.
  find:(key) ->
    node = @getRoot()
    while node 
      if key > node.key
        return null if not node.right
        node = node.right
        continue
      if key < node.key
        return null if not node.left
        node = node.left
        continue
      return node if key == node.key
      return null
    null


# ## <a id="BinaryTreeTidier"></a>BinaryTreeTidier

# Implement a Reingold-Tilford 'tidier' tree layout algorithm.
class DJC.BinaryTreeTidier

  # Assign x/y values to all nodes in the tree, and return an object containing
  # the measurements of the tree.
  layout: (node,unitMultiplier=1) ->
    @measure node
    @transform node, 0, unitMultiplier

  # Computer relative tree node positions
  measure: (node, level=0, extremes) ->
    extremes ?= left: null, right: null, level:0
    # left and right subtree extreme leaf nodes
    leftExtremes = left: null, right: null, level:0
    rightExtremes = left: null, right: null, level:0

    # separation at the root of the current subtree, as well as at the current level.
    currentSeparation = 0
    rootSeparation = 0
    minimumSeparation = 1

    # The offset from left/right children to the root of the current subtree.
    leftOffsetSum = 0
    rightOffsetSum = 0

    # Avoid selecting as extreme
    if not node
      extremes.left?.level = -1
      extremes.right?.level = -1
      return

    # Assign the `node.y`, note the left/right child nodes, and recurse into the tree.
    node.y = level
    left = node.left
    right = node.right
    @measure left, level+1, leftExtremes
    @measure right, level+1, rightExtremes

    # A leaf is both the leftmost and rightmost node on the lowest level of the 
    # subtree consisting of itself.
    if not node.right and not node.left
      node.offset = 0
      extremes.right = extremes.left = node
      return extremes

    # if only a single child, assign the next available offset and return.  
    #
    # TODO: I'm not sure this is correct.  Visual inspection of layout tree is needed to verify. 
    if not node.right or not node.left
      node.offset = minimumSeparation
      extremes.right = extremes.left = if node.left then node.left else node.right
      return

    # Set the current separation to the minimum separation for the root of the
    # subtree.
    currentSeparation = minimumSeparation
    leftOffsetSum = rightOffsetSum = 0

    # Traverse the subtrees until one of them is exhausted, pushing them apart 
    # as needed.
    loops = 0
    while left and right 
      loops++
      throw new Error "An impossibly large tree perhaps?" if loops > 100000
      if currentSeparation < minimumSeparation 
        rootSeparation += (minimumSeparation - currentSeparation)
        currentSeparation = minimumSeparation

      if left.right
        leftOffsetSum += left.offset
        currentSeparation -= left.offset
        left = left.thread or left.right
      else
        leftOffsetSum -= left.offset
        currentSeparation += left.offset
        left = left.thread or left.left

      if right.left
        rightOffsetSum -= right.offset 
        currentSeparation -= right.offset
        right = right.thread or right.left
      else
        rightOffsetSum += right.offset 
        currentSeparation += right.offset
        right = right.thread or right.right

    # Set the root offset, and include it in the accumulated offsets.
    node.offset = (rootSeparation + 1) / 2
    leftOffsetSum -= node.offset
    rightOffsetSum += node.offset

    # Update right and left extremes
    if rightExtremes.left.level > leftExtremes.left.level or not node.left
      extremes.left = rightExtremes.left
      extremes.left.offset += node.offset
    else
      extremes.left = leftExtremes.left
      extremes.left.offset -= node.offset
    if leftExtremes.right.level > rightExtremes.right.level or not node.right
      extremes.right = leftExtremes.right
      extremes.right.offset -= node.offset
    else
      extremes.right = rightExtremes.right
      extremes.right.offset += node.offset

    # If the subtrees have uneven heights, check to see if they need to be 
    # threaded.  If threading is required, it will affect only one node.
    if left and left != node.left
      rightExtremes.right.thread = left
      rightExtremes.right.offset = Math.abs (rightExtremes.right.offset + node.offset) - leftOffsetSum
    else if right and right != node.right
      leftExtremes.left.thread = right
      leftExtremes.left.offset = Math.abs (leftExtremes.left.offset - node.offset) - rightOffsetSum

    # Return this
    @

  # Transform relative to absolute coordinates, and measure the bounds of the tree.
  # Return a measurement of the tree in output units.
  transform: (node, x=0,unitMultiplier=1,measure) ->
    measure = {minX:10000, maxX:0, minY:10000, maxY: 0} if not measure
    return measure if not node
    node.x = x * unitMultiplier
    node.y *= unitMultiplier
    @transform node.left, x - node.offset, unitMultiplier, measure
    @transform node.right, x + node.offset, unitMultiplier, measure
    measure.minY = node.y if measure.minY > node.y
    measure.maxY = node.y if measure.maxY < node.y
    measure.minX = node.x if measure.minX > node.x
    measure.maxX = node.x if measure.maxX < node.x
    measure.width = Math.abs measure.minX - measure.maxX
    measure.height = Math.abs measure.minY - measure.maxY
    measure.centerX = measure.minX + measure.width / 2
    measure.centerY = measure.minY + measure.height / 2
    measure


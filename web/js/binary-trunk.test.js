// binary-trunk.coffee v0.0.1
// Copyright (c) 2012 Justin DuJardin
// binary-trunk is freely distributable under the MIT license.
(function() {

  module('BinaryTrees');

  test('BinaryTreeNode.constructor', function() {
    var count, tree;
    tree = new DJC.BinaryTreeNode(new DJC.BinaryTreeNode, new DJC.BinaryTreeNode);
    equal(tree.left !== null && tree.right !== null, true, 'children assigned properly by constructor');
    count = 0;
    tree.visitInorder(function(node) {
      return count++;
    });
    equal(count, 3, 'expected tree node count');
    equal(tree.left.parent === tree, true, 'left child parent assigned properly');
    return equal(tree.right.parent === tree, true, 'right child parent assigned properly');
  });

  test('BinaryTreeNode.clone', function() {
    var clone, count, fifteen, i, tree, _i;
    tree = new DJC.BinarySearchTree(0);
    for (i = _i = 0; _i <= 25; i = ++_i) {
      tree.insert(i);
    }
    fifteen = tree.find(15);
    equal(fifteen !== null, true, 'find isolation node');
    clone = fifteen.clone();
    equal(clone.getRoot() === clone, true, 'clone node becomes root');
    count = 0;
    clone.visitInorder(function() {
      return count++;
    });
    return equal(count, 11, 'clone node has expected 11 remaining nodes');
  });

  test('BinaryTreeNode.isLeaf', function() {
    var i, n, tree, _i, _j, _results;
    tree = new DJC.BinarySearchTree(0);
    for (i = _i = -1; _i <= 5; i = ++_i) {
      tree.insert(i);
    }
    equal(tree.find(-1).isLeaf(), true, 'left leaf');
    equal(tree.find(5).isLeaf(), true, 'right leaf');
    _results = [];
    for (n = _j = 0; _j <= 4; n = ++_j) {
      _results.push(equal(tree.find(n).isLeaf(), false));
    }
    return _results;
  });

  test('BinaryTreeNode.rotate', function() {
    var i, index, node, tree, v, values, _i, _j, _k, _len, _len1, _results;
    values = [-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5];
    tree = new DJC.BinarySearchTree(0);
    for (_i = 0, _len = values.length; _i < _len; _i++) {
      i = values[_i];
      tree.insert(i);
    }
    for (i = _j = 1; _j <= 10000; i = ++_j) {
      index = Math.floor(Math.random() * values.length);
      node = tree.find(values[index]);
      node.rotate();
      if (node.parent) {
        node.parent.getSide(node);
      }
    }
    _results = [];
    for (_k = 0, _len1 = values.length; _k < _len1; _k++) {
      v = values[_k];
      _results.push(equal(tree.find(v) !== null, true));
    }
    return _results;
  });

  test('BinaryTreeNode.visitPreorder', function() {
    var i, order, tree, values, _i, _len;
    values = [-1, 0, 1];
    order = [0, -1, 1];
    tree = new DJC.BinarySearchTree(0);
    for (_i = 0, _len = values.length; _i < _len; _i++) {
      i = values[_i];
      tree.insert(i);
    }
    return tree.visitPreorder(function(node) {
      return equal(node.key, order.shift());
    });
  });

  test('BinaryTreeNode.visit[Pre/In/Post]order (Stop)', function() {
    var i, total, tree, values, _i, _len;
    values = [-1, 0, 1];
    tree = new DJC.BinarySearchTree(0);
    for (_i = 0, _len = values.length; _i < _len; _i++) {
      i = values[_i];
      tree.insert(i);
    }
    total = 0;
    tree.visitPreorder(function(node) {
      total += 1;
      if (node.key === -1) {
        return DJC.BT.STOP;
      }
    });
    equal(total, 2, 'preorder stops at second node');
    total = 0;
    tree.visitInorder(function(node) {
      total += 1;
      if (node.key === -1) {
        return DJC.BT.STOP;
      }
    });
    equal(total, 1, 'inorder stops at first node');
    total = 0;
    tree.visitPostorder(function(node) {
      total += 1;
      if (node.key === -1) {
        return DJC.BT.STOP;
      }
    });
    return equal(total, 1, 'postorder stops at first node');
  });

  test('BinaryTreeNode.visitInorder', function() {
    var i, order, tree, values, _i, _len;
    values = [-1, 0, 1];
    order = [-1, 0, 1];
    tree = new DJC.BinarySearchTree(0);
    for (_i = 0, _len = values.length; _i < _len; _i++) {
      i = values[_i];
      tree.insert(i);
    }
    return tree.visitInorder(function(node) {
      return equal(node.key, order.shift());
    });
  });

  test('BinaryTreeNode.visitPostorder', function() {
    var i, order, tree, values, _i, _len;
    values = [-1, 0, 1];
    order = [-1, 1, 0];
    tree = new DJC.BinarySearchTree(0);
    for (_i = 0, _len = values.length; _i < _len; _i++) {
      i = values[_i];
      tree.insert(i);
    }
    return tree.visitPostorder(function(node) {
      return equal(node.key, order.shift());
    });
  });

  test('BinaryTreeNode.getRoot', function() {
    var i, n, tree, values, _i, _j, _len, _len1, _results;
    values = [-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5];
    tree = new DJC.BinarySearchTree(0);
    for (_i = 0, _len = values.length; _i < _len; _i++) {
      i = values[_i];
      tree.insert(i);
    }
    _results = [];
    for (_j = 0, _len1 = values.length; _j < _len1; _j++) {
      n = values[_j];
      _results.push(equal(tree.find(n).getRoot() === tree, true));
    }
    return _results;
  });

  test('BinaryTreeNode.setLeft', function() {
    var one, two;
    one = new DJC.BinaryTreeNode;
    two = new DJC.BinaryTreeNode;
    one.setLeft(two);
    equal(one.left === two, true, 'left child is expected');
    return equal(two.parent === one, true, 'parent is properly assigned');
  });

  test('BinaryTreeNode.setRight', function() {
    var one, two;
    one = new DJC.BinaryTreeNode;
    two = new DJC.BinaryTreeNode;
    one.setRight(two);
    equal(one.right === two, true, 'left child is expected');
    return equal(two.parent === one, true, 'parent is properly assigned');
  });

  test('BinaryTreeNode.getSide', function() {
    var i, node, tree, values, _i, _len;
    values = [-1, -2, -3, -4, 1, 2, 3, 4];
    tree = new DJC.BinarySearchTree(0);
    for (_i = 0, _len = values.length; _i < _len; _i++) {
      i = values[_i];
      tree.insert(i);
    }
    node = tree.find(-4);
    equal(node.parent.getSide(node), 'left', 'found child on expected side of parent');
    node = tree.find(4);
    equal(node.parent.getSide(node), 'right', 'found child on expected side of parent');
    return raises(function() {
      return node.parent.getSide(tree);
    });
  });

  test('BinaryTreeNode.setSide', function() {
    var one, tree, two;
    tree = new DJC.BinaryTreeNode;
    one = new DJC.BinaryTreeNode;
    two = new DJC.BinaryTreeNode;
    tree.setSide(one, 'left');
    equal(tree.left === one, true, 'child assigned to left properly');
    tree.setSide(two, 'right');
    equal(tree.right === two, true, 'child assigned to right properly');
    return raises(function() {
      return tree.setSide(node, 'rihgt');
    });
  });

  test('BinaryTreeNode.getChildren', function() {
    var i, neg, one, tree, two, values, _i, _len;
    values = [-2, -1, -3, 0, 1, 2];
    tree = new DJC.BinarySearchTree(0);
    for (_i = 0, _len = values.length; _i < _len; _i++) {
      i = values[_i];
      tree.insert(i);
    }
    neg = tree.find(-2).getChildren();
    equal(neg.length, 2, 'expect two children of -1');
    equal(neg[0].key, -3, 'expect left child of -1 to first');
    equal(neg[1].key, -1, 'expect right child of -1 to second');
    one = tree.find(1).getChildren();
    equal(one.length, 1, 'expect one child of 1');
    equal(one[0].key, 2, 'expect child of 1 to be 2');
    two = tree.find(2).getChildren();
    return equal(two.length, 0, 'expect no children for 2');
  });

  test('BinaryTreeNode.getSibling', function() {
    var tree;
    tree = new DJC.BinaryTreeNode(new DJC.BinaryTreeNode, new DJC.BinaryTreeNode);
    equal(tree.left.getSibling() === tree.right, true, 'left sibling is right');
    equal(tree.right.getSibling() === tree.left, true, 'right sibling is left');
    return equal(tree.getSibling(), void 0, 'root has no sibling');
  });

  test('BinarySearchTree.insert', function() {
    var count, i, tree, _i;
    tree = new DJC.BinarySearchTree(0);
    for (i = _i = -25; _i <= 25; i = ++_i) {
      tree.insert(i);
    }
    count = 0;
    tree.visitInorder(function(node) {
      return count++;
    });
    return equal(count, 51, 'expect 51 nodes in search tree after 51 value inserts');
  });

  test('BinarySearchTree.find', function() {
    var i, tree, _i, _len, _ref;
    tree = new DJC.BinarySearchTree(0);
    _ref = [-25, 1337, 2];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      i = _ref[_i];
      tree.insert(i);
    }
    equal(tree.find(-25) !== null, true);
    equal(tree.find(1337) !== null, true);
    equal(tree.find(2) !== null, true);
    equal(tree.find(null) === null, true);
    equal(tree.find(-33) === null, true);
    return equal(tree.find(25) === null, true);
  });

  test('BinaryTreeTidier.layout', function() {
    var result, tree, val, _i;
    tree = new DJC.BinarySearchTree(0);
    for (val = _i = -100; _i <= 100; val = ++_i) {
      tree.insert(val);
    }
    result = new DJC.BinaryTreeTidier().layout(tree);
    equal(result !== null, true, 'expect a result from tidier layout pass');
    return this;
  });

  test('BinaryTreeTidier.layout (Aesthetic 1)', function() {
    var k, nodeGroups, tidier, tree, v, val, yCoords, _i;
    tree = new DJC.BinarySearchTree(0);
    for (val = _i = -5; _i <= 5; val = ++_i) {
      tree.insert(val);
    }
    tidier = new DJC.BinaryTreeTidier;
    tidier.layout(tree);
    nodeGroups = {};
    tree.visitPreorder(function(node, depth) {
      if (!nodeGroups[depth]) {
        nodeGroups[depth] = [];
      }
      return nodeGroups[depth].push(node);
    });
    for (k in nodeGroups) {
      v = nodeGroups[k];
      yCoords = _.map(v, function(node) {
        return node.y;
      });
      equal(_.uniq(yCoords).length, 1, 'nodes in depth group share y-coordinate');
    }
    return this;
  });

  test('BinaryTreeTidier.layout (Aesthetic 2)', function() {
    var nodes, tidier, tree, val, _i, _len, _ref;
    tree = new DJC.BinarySearchTree(0);
    _ref = [-2, -1, -3, 2, 3, 1];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      val = _ref[_i];
      tree.insert(val);
    }
    tidier = new DJC.BinaryTreeTidier;
    tidier.layout(tree);
    nodes = [];
    tree.visitPostorder(function(node) {
      var parent, side;
      parent = node.parent;
      if (!parent) {
        return;
      }
      side = node.parent.getSide(node);
      if (side === 'left') {
        return equal(node.x < node.parent.x, true, "Left child (" + node.x + ") positioned to the left of its parent (" + node.parent.x + ")");
      } else {
        return equal(node.x > node.parent.x, true, "Right child (" + node.x + ") positioned to the right of its parent (" + node.parent.x + ")");
      }
    });
    return this;
  });

  test('BinaryTreeTidier.layout (Aesthetic 3)', function() {
    var nodes, tidier, tree, val, _i, _len, _ref;
    tidier = new DJC.BinaryTreeTidier;
    tree = new DJC.BinarySearchTree(0);
    _ref = [-2, -1, -3, 2, 3, 1];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      val = _ref[_i];
      tree.insert(val);
    }
    tidier.layout(tree);
    nodes = [];
    tree.visitPostorder(function(node) {
      var children, expected, left, right;
      children = node.getChildren();
      if (children.length !== 2) {
        return;
      }
      left = children[0].x;
      right = children[1].x;
      expected = left + Math.abs(left - right) / 2;
      return equal(expected, node.x, "parent node position (" + node.x + ") matches expected");
    });
    return this;
  });

  test('BinaryTreeTidier.layout (Aesthetic 4.1)', function() {
    var i, left, leftDist, nodes, right, rightDist, tidier, tree, val, _i, _j, _k, _len, _len1, _ref, _ref1, _results;
    tree = new DJC.BinarySearchTree(0);
    _ref = [-2, -1, -4, -3, -5];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      val = _ref[_i];
      tree.insert(val);
    }
    _ref1 = [2, 1, 4, 3, 5];
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      val = _ref1[_j];
      tree.insert(val);
    }
    tidier = new DJC.BinaryTreeTidier;
    tidier.layout(tree);
    nodes = [];
    _results = [];
    for (i = _k = 1; _k < 5; i = ++_k) {
      left = tree.find(-i);
      right = tree.find(i);
      leftDist = Math.abs(left.x - tree.x);
      rightDist = Math.abs(right.x - tree.x);
      _results.push(equal(leftDist, rightDist, 'Reflected nodes should be equidistant from root'));
    }
    return _results;
  });

  test('BinaryTreeTidier.layout (Aesthetic 4.2)', function() {
    var lDistance, nodes, rDistance, result, tidier, tree, val, _i, _len, _ref;
    tree = new DJC.BinarySearchTree(0);
    _ref = [7, 4, 3, 5, 13, 12, 14, -3, -6, -2, -7, -13, -14, -12];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      val = _ref[_i];
      tree.insert(val);
    }
    tidier = new DJC.BinaryTreeTidier;
    result = tidier.layout(tree);
    nodes = [];
    lDistance = rDistance = void 0;
    tree.visitPreorder(function(node) {
      var leftDistance, less, more, rightDistance, three;
      if (node.key !== 13 && node.key !== -13) {
        return;
      }
      equal(node.left.key, node.key - 1, 'expect lesser value to the left');
      equal(node.right.key, node.key + 1, 'expect greater value to the right');
      three = node.x;
      less = node.left.x;
      more = node.right.x;
      leftDistance = less - three;
      rightDistance = more - three;
      if (lDistance && rDistance) {
        equal(lDistance, leftDistance, 'left child distances match');
        equal(rDistance, rightDistance, 'right child distances match');
      }
      lDistance = leftDistance;
      return rDistance = rightDistance;
    });
    return this;
  });

}).call(this);

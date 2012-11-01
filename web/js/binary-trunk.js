// binary-trunk.coffee v0.0.1
// Copyright (c) 2012 Justin DuJardin
// binary-trunk is freely distributable under the MIT license.
(function() {
  var BT, DJC, root,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  root = this;

  DJC = root.DJC = root.DJC || {};

  DJC.BT = BT = {
    STOP: 'stop',
    LEFT: 'left',
    RIGHT: 'right'
  };

  DJC.BinaryTreeNode = (function() {

    function BinaryTreeNode(left, right) {
      var _ref;
      if (left) {
        this.setLeft(left);
      }
      if (right) {
        this.setRight(right);
      }
      if ((_ref = this.parent) == null) {
        this.parent = void 0;
      }
    }

    BinaryTreeNode.prototype.clone = function() {
      var result;
      result = new this.constructor();
      if (this.left) {
        result.setLeft(this.left.clone());
      }
      if (this.right) {
        result.setRight(this.right.clone());
      }
      return result;
    };

    BinaryTreeNode.prototype.isLeaf = function() {
      return !this.left && !this.right;
    };

    BinaryTreeNode.prototype.toString = function() {
      return "" + this.left + " " + this.right;
    };

    BinaryTreeNode.prototype.rotate = function() {
      var grandParent, node, parent;
      node = this;
      parent = this.parent;
      if (!node || !parent) {
        return;
      }
      grandParent = this.parent.parent;
      if (node === parent.left) {
        parent.setLeft(node.right);
        node.right = parent;
        parent.parent = node;
      } else {
        parent.setRight(node.left);
        node.left = parent;
        parent.parent = node;
      }
      node.parent = grandParent;
      if (!grandParent) {
        return;
      }
      if (parent === grandParent.left) {
        return grandParent.left = node;
      } else {
        return grandParent.right = node;
      }
    };

    BinaryTreeNode.prototype.visitPreorder = function(visitFunction, depth, data) {
      if (depth == null) {
        depth = 0;
      }
      if (visitFunction && visitFunction(this, depth, data) === BT.STOP) {
        return BT.STOP;
      }
      if (this.left && this.left.visitPreorder(visitFunction, depth + 1, data) === BT.STOP) {
        return BT.STOP;
      }
      if (this.right && this.right.visitPreorder(visitFunction, depth + 1, data) === BT.STOP) {
        return BT.STOP;
      }
    };

    BinaryTreeNode.prototype.visitInorder = function(visitFunction, depth, data) {
      if (depth == null) {
        depth = 0;
      }
      if (this.left && this.left.visitInorder(visitFunction, depth + 1, data) === BT.STOP) {
        return BT.STOP;
      }
      if (visitFunction && visitFunction(this, depth, data) === BT.STOP) {
        return BT.STOP;
      }
      if (this.right && this.right.visitInorder(visitFunction, depth + 1, data) === BT.STOP) {
        return BT.STOP;
      }
    };

    BinaryTreeNode.prototype.visitPostorder = function(visitFunction, depth, data) {
      if (depth == null) {
        depth = 0;
      }
      if (this.left && this.left.visitPostorder(visitFunction, depth + 1, data) === BT.STOP) {
        return BT.STOP;
      }
      if (this.right && this.right.visitPostorder(visitFunction, depth + 1, data) === BT.STOP) {
        return BT.STOP;
      }
      if (visitFunction && visitFunction(this, depth, data) === BT.STOP) {
        return BT.STOP;
      }
    };

    BinaryTreeNode.prototype.getRoot = function() {
      var result;
      result = this;
      while (result.parent) {
        result = result.parent;
      }
      return result;
    };

    BinaryTreeNode.prototype.setLeft = function(child) {
      var _ref;
      this.left = child;
      return (_ref = this.left) != null ? _ref.parent = this : void 0;
    };

    BinaryTreeNode.prototype.setRight = function(child) {
      var _ref;
      this.right = child;
      return (_ref = this.right) != null ? _ref.parent = this : void 0;
    };

    BinaryTreeNode.prototype.getSide = function(child) {
      if (child === this.left) {
        return BT.LEFT;
      }
      if (child === this.right) {
        return BT.RIGHT;
      }
      throw new Error("BinaryTreeNode.getSide: not a child of this node");
    };

    BinaryTreeNode.prototype.setSide = function(child, side) {
      switch (side) {
        case BT.LEFT:
          return this.setLeft(child);
        case BT.RIGHT:
          return this.setRight(child);
        default:
          throw new Error("BinaryTreeNode.setSide: Invalid side");
      }
    };

    BinaryTreeNode.prototype.getChildren = function() {
      var result;
      result = [];
      if (this.left) {
        result.push(this.left);
      }
      if (this.right) {
        result.push(this.right);
      }
      return result;
    };

    BinaryTreeNode.prototype.getSibling = function() {
      if (!this.parent) {
        return;
      }
      if (this.parent.left === this) {
        return this.parent.right;
      }
      if (this.parent.right === this) {
        return this.parent.left;
      }
    };

    return BinaryTreeNode;

  })();

  DJC.BinarySearchTree = (function(_super) {

    __extends(BinarySearchTree, _super);

    function BinarySearchTree(key) {
      this.key = key;
      BinarySearchTree.__super__.constructor.call(this);
    }

    BinarySearchTree.prototype.clone = function() {
      var result;
      result = BinarySearchTree.__super__.clone.call(this);
      result.key = this.key;
      return result;
    };

    BinarySearchTree.prototype.insert = function(key) {
      var node;
      node = this.getRoot();
      while (node) {
        if (key > node.key) {
          if (!node.right) {
            node.setRight(new BinarySearchTree(key));
            break;
          }
          node = node.right;
        } else if (key < node.key) {
          if (!node.left) {
            node.setLeft(new BinarySearchTree(key));
            break;
          }
          node = node.left;
        } else {
          break;
        }
      }
      return this;
    };

    BinarySearchTree.prototype.find = function(key) {
      var node;
      node = this.getRoot();
      while (node) {
        if (key > node.key) {
          if (!node.right) {
            return null;
          }
          node = node.right;
          continue;
        }
        if (key < node.key) {
          if (!node.left) {
            return null;
          }
          node = node.left;
          continue;
        }
        if (key === node.key) {
          return node;
        }
        return null;
      }
      return null;
    };

    return BinarySearchTree;

  })(DJC.BinaryTreeNode);

  DJC.BinaryTreeTidier = (function() {

    function BinaryTreeTidier() {}

    BinaryTreeTidier.prototype.layout = function(node, unitMultiplier) {
      if (unitMultiplier == null) {
        unitMultiplier = 1;
      }
      this.measure(node);
      return this.transform(node, 0, unitMultiplier);
    };

    BinaryTreeTidier.prototype.measure = function(node, level, extremes) {
      var currentSeparation, left, leftExtremes, leftOffsetSum, loops, minimumSeparation, right, rightExtremes, rightOffsetSum, rootSeparation, _ref, _ref1;
      if (level == null) {
        level = 0;
      }
      if (extremes == null) {
        extremes = {
          left: null,
          right: null,
          level: 0
        };
      }
      leftExtremes = {
        left: null,
        right: null,
        level: 0
      };
      rightExtremes = {
        left: null,
        right: null,
        level: 0
      };
      currentSeparation = 0;
      rootSeparation = 0;
      minimumSeparation = 1;
      leftOffsetSum = 0;
      rightOffsetSum = 0;
      if (!node) {
        if ((_ref = extremes.left) != null) {
          _ref.level = -1;
        }
        if ((_ref1 = extremes.right) != null) {
          _ref1.level = -1;
        }
        return;
      }
      node.y = level;
      left = node.left;
      right = node.right;
      this.measure(left, level + 1, leftExtremes);
      this.measure(right, level + 1, rightExtremes);
      if (!node.right && !node.left) {
        node.offset = 0;
        extremes.right = extremes.left = node;
        return extremes;
      }
      currentSeparation = minimumSeparation;
      leftOffsetSum = rightOffsetSum = 0;
      loops = 0;
      while (left && right) {
        loops++;
        if (loops > 100000) {
          throw new Error("An impossibly large tree perhaps?");
        }
        if (currentSeparation < minimumSeparation) {
          rootSeparation += minimumSeparation - currentSeparation;
          currentSeparation = minimumSeparation;
        }
        if (left.right) {
          leftOffsetSum += left.offset;
          currentSeparation -= left.offset;
          left = left.thread || left.right;
        } else {
          leftOffsetSum -= left.offset;
          currentSeparation += left.offset;
          left = left.thread || left.left;
        }
        if (right.left) {
          rightOffsetSum -= right.offset;
          currentSeparation -= right.offset;
          right = right.thread || right.left;
        } else {
          rightOffsetSum += right.offset;
          currentSeparation += right.offset;
          right = right.thread || right.right;
        }
      }
      node.offset = (rootSeparation + 1) / 2;
      leftOffsetSum -= node.offset;
      rightOffsetSum += node.offset;
      if (rightExtremes.left.level > leftExtremes.left.level || !node.left) {
        extremes.left = rightExtremes.left;
        extremes.left.offset += node.offset;
      } else {
        extremes.left = leftExtremes.left;
        extremes.left.offset -= node.offset;
      }
      if (leftExtremes.right.level > rightExtremes.right.level || !node.right) {
        extremes.right = leftExtremes.right;
        extremes.right.offset -= node.offset;
      } else {
        extremes.right = rightExtremes.right;
        extremes.right.offset += node.offset;
      }
      if (left && left !== node.left) {
        rightExtremes.right.thread = left;
        rightExtremes.right.offset = Math.abs((rightExtremes.right.offset + node.offset) - leftOffsetSum);
      } else if (right && right !== node.right) {
        leftExtremes.left.thread = right;
        leftExtremes.left.offset = Math.abs((leftExtremes.left.offset - node.offset) - rightOffsetSum);
      }
      return this;
    };

    BinaryTreeTidier.prototype.transform = function(node, x, unitMultiplier, measure) {
      if (x == null) {
        x = 0;
      }
      if (unitMultiplier == null) {
        unitMultiplier = 1;
      }
      if (!measure) {
        measure = {
          minX: 10000,
          maxX: 0,
          minY: 10000,
          maxY: 0
        };
      }
      if (!node) {
        return measure;
      }
      node.x = x * unitMultiplier;
      node.y *= unitMultiplier;
      this.transform(node.left, x - node.offset, unitMultiplier, measure);
      this.transform(node.right, x + node.offset, unitMultiplier, measure);
      if (measure.minY > node.y) {
        measure.minY = node.y;
      }
      if (measure.maxY < node.y) {
        measure.maxY = node.y;
      }
      if (measure.minX > node.x) {
        measure.minX = node.x;
      }
      if (measure.maxX < node.x) {
        measure.maxX = node.x;
      }
      measure.width = Math.abs(measure.minX - measure.maxX);
      measure.height = Math.abs(measure.minY - measure.maxY);
      measure.centerX = measure.minX + measure.width / 2;
      measure.centerY = measure.minY + measure.height / 2;
      return measure;
    };

    return BinaryTreeTidier;

  })();

}).call(this);

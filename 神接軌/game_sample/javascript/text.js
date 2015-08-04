// Generated by CoffeeScript 1.7.1
(function() {
  var textController,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  textController = (function(_super) {
    __extends(textController, _super);

    function textController() {
      this.text = [];
      this.msgs = [];
      this.interval(this.move, 50);
    }

    textController.prototype.showDamage = function(damage, map, x, y, color) {
      if (color == null) {
        color = "#FFFFFF";
      }
      return this.showText(damage, color, map, x, y, [0, 0], [Math.random() * 2 - 1, -2], 30);
    };

    textController.prototype.showText = function(text, color, map, x, y, offset, v, time) {
      return this.text.push([text, color, map, x, y, offset, v, time]);
    };

    textController.prototype.msg = function(text, self) {
      return this.msgs.push([text, self, 50]);
    };

    textController.prototype.move = function() {
      var deleteList, i, text, _i, _j, _k, _l, _len, _len1, _len2, _len3, _ref, _ref1, _results;
      deleteList = [];
      _ref = this.text;
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        text = _ref[i];
        if (--this.text[i][7] === 0) {
          deleteList.push(i);
        }
        this.text[i][5][0] += this.text[i][6][0];
        this.text[i][5][1] += this.text[i][6][1];
      }
      deleteList.sort(function(a, b) {
        return b - a;
      });
      for (_j = 0, _len1 = deleteList.length; _j < _len1; _j++) {
        i = deleteList[_j];
        this.text.splice(i, 1);
      }
      deleteList = [];
      _ref1 = this.msgs;
      for (i = _k = 0, _len2 = _ref1.length; _k < _len2; i = ++_k) {
        text = _ref1[i];
        if (--this.msgs[i][2] === 0) {
          deleteList.push(i);
        }
      }
      deleteList.sort(function(a, b) {
        return b - a;
      });
      _results = [];
      for (_l = 0, _len3 = deleteList.length; _l < _len3; _l++) {
        i = deleteList[_l];
        _results.push(this.msgs.splice(i, 1));
      }
      return _results;
    };

    textController.prototype.redraw = function() {
      var context, metrics, position, text, _i, _j, _len, _len1, _ref, _ref1, _results;
      context = game.canvas.context;
      _ref = this.text;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        text = _ref[_i];
        if (text[2] === game.role.map) {
          position = getRealPosition(text[3], text[4], text[5]);
          context.font = "14px Arial";
          context.fillStyle = "#000";
          context.textAlign = 'center';
          context.fillText(text[0], position[0] + 21, position[1] + 21);
          context.fillStyle = text[1];
          context.fillText(text[0], position[0] + 20, position[1] + 20);
        }
      }
      _ref1 = this.msgs;
      _results = [];
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        text = _ref1[_j];
        if (text[1].mapname === game.role.mapname) {
          context.beginPath();
          context.font = "14px Arial";
          context.textAlign = 'center';
          position = getRealPosition(text[1].position[0], text[1].position[1], [0, -45]);
          context.globalAlpha = .3;
          context.fillStyle = '#333';
          metrics = context.measureText(text[1].name + " : " + text[0]);
          context.fillRect(text[1].offset[0] + position[0] + 20 - metrics.width / 2 - 5, text[1].offset[1] + position[1] - 17, metrics.width + 10, 24);
          context.globalAlpha = 1;
          context.fillStyle = "#000";
          context.fillText(text[1].name + " : " + text[0], text[1].offset[0] + position[0] + 21, text[1].offset[1] + position[1] + 1);
          context.fillStyle = "#FFF";
          context.fillText(text[1].name + " : " + text[0], text[1].offset[0] + position[0] + 20, text[1].offset[1] + position[1]);
          context.strokeStyle = "#FC0";
          context.rect(text[1].offset[0] + position[0] + 20 - metrics.width / 2 - 5, text[1].offset[1] + position[1] - 17, metrics.width + 10, 24);
          _results.push(context.stroke());
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    return textController;

  })(window.Base);

  game.text = new textController();

}).call(this);

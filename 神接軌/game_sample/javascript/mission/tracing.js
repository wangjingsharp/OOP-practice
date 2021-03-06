// Generated by CoffeeScript 1.7.1
(function() {
  window.Tracing = (function() {
    function Tracing() {
      this.npcs = [];
    }

    Tracing.prototype.addNpc = function(name) {
      var npc;
      npc = {
        name: name,
        complete: false
      };
      return this.npcs.push(npc);
    };

    Tracing.prototype.tracingComplete = function(npc_name) {
      var npc, _i, _len, _ref, _results;
      _ref = this.npcs;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        npc = _ref[_i];
        if (npc.name === npc_name) {
          _results.push(npc.complete = true);
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    Tracing.prototype.isComplete = function() {
      var npc, _i, _len, _ref;
      _ref = this.npcs;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        npc = _ref[_i];
        if (!npc.complete) {
          return false;
        }
      }
      return true;
    };

    Tracing.prototype.schedule = function() {
      var checkbox, label, npc, row, rows, _i, _len, _ref;
      rows = [];
      _ref = this.npcs;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        npc = _ref[_i];
        row = new Row;
        checkbox = new Checkbox;
        checkbox.complete(npc.complete);
        label = new Label(npc.name);
        checkbox.appendTo(row);
        label.appendTo(row);
        rows.push(row);
      }
      return rows;
    };

    return Tracing;

  })();

}).call(this);

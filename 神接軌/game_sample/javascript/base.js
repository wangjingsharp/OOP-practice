// Generated by CoffeeScript 1.7.1
(function() {
  window.Base = (function() {
    function Base() {}

    Base.prototype.timeout = function(fn, time) {
      var args, i, that;
      that = this;
      args = (function() {
        var _i, _ref, _results;
        _results = [];
        for (i = _i = 2, _ref = arguments.length; 2 <= _ref ? _i <= _ref : _i >= _ref; i = 2 <= _ref ? ++_i : --_i) {
          _results.push(arguments[i]);
        }
        return _results;
      }).apply(this, arguments);
      return setTimeout(function() {
        return fn.apply(that, args);
      }, time);
    };

    Base.prototype.interval = function(fn, time) {
      var args, i, that;
      that = this;
      args = (function() {
        var _i, _ref, _results;
        _results = [];
        for (i = _i = 2, _ref = arguments.length; 2 <= _ref ? _i <= _ref : _i >= _ref; i = 2 <= _ref ? ++_i : --_i) {
          _results.push(arguments[i]);
        }
        return _results;
      }).apply(this, arguments);
      return setInterval(function() {
        return fn.apply(that, args);
      }, time);
    };

    return Base;

  })();

}).call(this);

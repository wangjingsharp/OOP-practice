// Generated by CoffeeScript 1.7.1
(function() {
  window.BaseWindow = (function() {
    function BaseWindow(cls) {
      this.html = document.createElement('div');
      this.addClass(cls);
      this.events = [];
      this.init();
    }

    BaseWindow.prototype.init = function() {
      return this.childrens = [];
    };

    BaseWindow.prototype.setMsg = function(msg) {
      return this.html.innerHTML = msg;
    };

    BaseWindow.prototype.addClass = function(cls) {
      return this.html.className += " " + cls;
    };

    BaseWindow.prototype.removeClass = function(cls) {
      var clsname, _i, _len, _results;
      clsname = this.html.className.split(cls);
      this.html.className = "";
      _results = [];
      for (_i = 0, _len = clsname.length; _i < _len; _i++) {
        cls = clsname[_i];
        _results.push(this.html.className += cls);
      }
      return _results;
    };

    BaseWindow.prototype.appendTo = function(parent) {
      parent.childrens.push(this);
      return parent.html.appendChild(this.html);
    };

    BaseWindow.prototype.show = function() {
      return this.html.style.display = "block";
    };

    BaseWindow.prototype.hide = function() {
      return this.html.style.display = "none";
    };

    BaseWindow.prototype.isHide = function() {
      return this.html.style.display === "none";
    };

    BaseWindow.prototype.close = function() {
      return this.html.remove();
    };

    BaseWindow.prototype.setHeight = function(height) {
      this.height = height;
      return this.html.style.height = "" + this.height + "px";
    };

    BaseWindow.prototype.addEvent = function(handler, fn, that) {
      if (that == null) {
        that = this;
      }
      if (!this.isEvent(handler)) {
        this.html.addEventListener(handler, function() {
          return fn.call(that);
        }, false);
        return this.events.push(handler);
      }
    };

    BaseWindow.prototype.removeEvent = function(handler) {
      return this.html.removeEventListener(handler);
    };

    BaseWindow.prototype.isEvent = function(handler) {
      return this.events.indexOf(handler) !== -1;
    };

    return BaseWindow;

  })();

}).call(this);

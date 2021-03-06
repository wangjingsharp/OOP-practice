// Generated by CoffeeScript 1.7.1
(function() {
  window.ItemManager = (function() {
    function ItemManager() {
      this.packLimit = 50;
      this.items = [];
    }

    ItemManager.prototype.addItem = function(item) {
      var idx;
      idx = this.items.map(function(ele) {
        return ele.item.name;
      }).indexOf(item.name);
      if (idx === -1) {
        this.items.push({
          item: item,
          amount: 1
        });
      } else {
        this.items[idx].amount++;
      }
      if (this.mission_manager == null) {
        this.mission_manager = game.role.mission_manager;
      }
      this.mission_manager.collectItem(item.name);
      if (this.windows_manager == null) {
        this.windows_manager = game.windows_manager;
      }
      if (this.windows_manager.findWindow('背包')) {
        return this.reviewItems();
      }
    };

    ItemManager.prototype.removeItem = function(item) {
      return this.items["delete"](item);
    };

    ItemManager.prototype.showItems = function() {
      var block, i, win, _i, _ref;
      if (this.windows_manager == null) {
        this.windows_manager = game.windows_manager;
      }
      if (win = this.windows_manager.findWindow('背包')) {
        if (win.isHide()) {
          win.show();
          return this.reviewItems();
        } else {
          return win.hide();
        }
      } else {
        this.win = new Windows(350, 400, '背包');
        for (i = _i = 0, _ref = this.packLimit - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
          block = new Block('');
          block.appendTo(this.win.main);
        }
        return this.reviewItems();
      }
    };

    ItemManager.prototype.reviewItems = function() {
      var block, i, item, key, label, money, that, _i, _j, _len, _ref, _ref1;
      that = this;
      for (i = _i = 0, _ref = this.packLimit - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        block = this.win.main.childrens[i];
        block.setMsg('');
        block.removeEvent('dblclick');
      }
      _ref1 = this.items;
      for (key = _j = 0, _len = _ref1.length; _j < _len; key = ++_j) {
        item = _ref1[key];
        block = this.win.main.childrens[key];
        item.label = new Label;
        item.label.html.style.backgroundImage = "url(images/" + item.item.icon + ")";
        item.label.html.style.backgroundSize = "auto 100%";
        item.label.html.style.backgroundPosition = "center";
        item.label.html.style.backgroundRepeat = "no-repeat";
        item.label.html.style.width = "100%";
        item.label.html.style.height = "100%";
        item.label.appendTo(block);
        if (!item.label.isEvent('dblclick')) {
          item.label.addEvent('dblclick', game.role.hotkey_manager.set, [item.item]);
        }
        label = new Label(item.amount);
        label.html.style.position = "absolute";
        label.html.style.bottom = 0;
        label.html.style.right = 0;
        label.appendTo(block);
      }
      money = $("<div class='item-money'>");
      money.html(game.role.money);
      return $(this.win.footer.html).html("").css("background-color", "#FFF").append(money);
    };

    return ItemManager;

  })();

}).call(this);

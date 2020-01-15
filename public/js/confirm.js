// Generated by CoffeeScript 2.5.0
(function() {
  this.Confirm = class Confirm {
    constructor() {
      var $items;
      this._handleClick = this._handleClick.bind(this);
      $items = $('[data-confirm]');
      $items.on('click', this._handleClick);
    }

    _handleClick(e) {
      var $item, message;
      $item = $(e.currentTarget);
      message = $item.data('confirm');
      if (message && !confirm(message)) {
        return e.preventDefault();
      }
    }

  };

}).call(this);

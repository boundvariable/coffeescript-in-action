(function() {
  var List, View;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  View = require('./view').View;

  List = (function() {

    __extends(List, View);

    function List(posts) {
      this.posts = posts;
    }

    List.prototype.render = function() {
      var all, post;
      all = ((function() {
        var _i, _len, _ref, _results;
        _ref = this.posts;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          post = _ref[_i];
          _results.push("<li><a href='" + post.slug + "'>" + post.title + "</a></li>");
        }
        return _results;
      }).call(this)).join('');
      return this.wrap("<ul>" + all + "</ul>");
    };

    return List;

  })();

  exports.List = List;

}).call(this);

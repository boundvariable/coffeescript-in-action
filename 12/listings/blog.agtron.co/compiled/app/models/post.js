(function() {
  var Model, Post;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  Model = require('./model').Model;

  Post = (function() {
    var posts;

    __extends(Post, Model);

    posts = [];

    function Post(title, body) {
      this.title = title;
      this.body = body;
      if (!this.title) throw 'requires title';
      this.comments = [];
      Post.__super__.constructor.apply(this, arguments);
      this.slug = this.dirify(this.title);
      posts.push(this);
    }

    Post.all = function() {
      return posts;
    };

    Post.get = function(slug) {
      var post;
      return ((function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = posts.length; _i < _len; _i++) {
          post = posts[_i];
          if (post.slug === slug) _results.push(post);
        }
        return _results;
      })())[0];
    };

    Post.purge = function() {
      return posts = [];
    };

    return Post;

  })();

  exports.Post = Post;

}).call(this);

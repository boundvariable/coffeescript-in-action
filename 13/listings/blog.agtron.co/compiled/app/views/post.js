(function() {
  var Post, View;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  View = require('./view').View;

  Post = (function() {

    __extends(Post, View);

    function Post(post) {
      this.post = post;
    }

    Post.prototype.render = function() {
      return this.wrap("<h1>" + this.post.title + "</h1>\n<div class='content'>\n" + this.post.body + "\n</div>\n<div class='comments'>\n" + this.post.comments + "\n</div>\n<form method='post' id='comment' action=''>\nEnter your comment here:\n<textarea></textarea>\n<input type='submit' value='Comment'>\n</form>");
    };

    return Post;

  })();

  exports.Post = Post;

}).call(this);

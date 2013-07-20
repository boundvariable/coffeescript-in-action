(function() {
  var Blog, Controller, Post, fs, views;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  Controller = require('./controller').Controller;

  Post = require('../models').Post;

  views = require('../views').views;

  fs = require('fs');

  Blog = (function() {

    __extends(Blog, Controller);

    function Blog() {
      this.js = __bind(this.js, this);
      this.list_comments = __bind(this.list_comments, this);
      this.insert_comment = __bind(this.insert_comment, this);
      this.show = __bind(this.show, this);
      this.index = __bind(this.index, this);
      Blog.__super__.constructor.apply(this, arguments);
    }

    Blog.route('/', 'index');

    Blog.prototype.index = function(request, response) {
      this.request = request;
      this.response = response;
      this.posts = Post.all();
      return this.render(views('list', this.posts));
    };

    Blog.route('/([a-zA-Z0-9-]+)', 'show');

    Blog.prototype.show = function(request, response, id) {
      this.request = request;
      this.response = response;
      this.post = Post.get(id);
      if (this.post) {
        return this.render(views('post', this.post));
      } else {
        return '';
      }
    };

    Blog.route('/([a-zA-Z0-9-]+)[/]comments[?]insert=(.*)', 'insert_comment');

    Blog.prototype.insert_comment = function(request, response, id, comment) {
      var _this = this;
      this.request = request;
      this.response = response;
      this.post = Post.get(id);
      if (this.request.method === 'POST') this.post.comments.push(comment);
      return this.render({
        render: function() {
          return JSON.stringify(_this.post.comments, 'text/json');
        }
      });
    };

    Blog.route('/([a-zA-Z0-9-]+)[/]comments', 'list_comments');

    Blog.prototype.list_comments = function(request, response, id) {
      var _this = this;
      this.request = request;
      this.response = response;
      this.post = Post.get(id);
      return this.render({
        render: function() {
          return JSON.stringify(_this.post.comments, 'text/json');
        }
      });
    };

    Blog.route('/(.*\.js)', 'js');

    Blog.prototype.js = function(request, response, file) {
      this.request = request;
      this.response = response;
      return this.render(views('js', file), 'application/javascript');
    };

    return Blog;

  })();

  exports.Blog = Blog;

}).call(this);

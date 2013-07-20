var __hasProp = Object.prototype.hasOwnProperty;

(function() {
  var cache, modules;
  modules = {};
  cache = {};
  this.require = function(raw_name) {
    var module, name;
    name = raw_name.replace(/[^a-z]/gi, '');
    if (cache[name]) return cache[name].exports;
    if (modules[name]) {
      module = {
        exports: {}
      };
      cache[name] = module;
      modules[name](function(name) {
        return require(name);
      }, module.exports);
      return module.exports;
    } else {
      throw "No such module " + name;
    }
  };
  return this.defmodule = function(bundle) {
    var key, _results;
    _results = [];
    for (key in bundle) {
      if (!__hasProp.call(bundle, key)) continue;
      _results.push(modules[key] = bundle[key]);
    }
    return _results;
  };
})();


defmodule({comments: function (require, exports) {
  var Comments;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Comments = (function() {

  function Comments(url, out, http_request) {
    this.url = url;
    this.out = out;
    this.http_request = http_request;
    this.render = __bind(this.render, this);
    this.http_request("" + this.url + "/comments", this.render);
  }

  Comments.prototype.post = function(comment) {
    return this.http_request("" + this.url + "/comments?insert=" + comment, this.render);
  };

  Comments.prototype.bind = function(element, event) {
    var comment;
    var _this = this;
    comment = element.querySelector('textarea');
    return element["on" + event] = function() {
      _this.post(comment.value);
      return false;
    };
  };

  Comments.prototype.render = function(data) {
    var comments, formatted, in_li;
    in_li = function(text) {
      return "<li>" + text + "</li>";
    };
    if (data !== '') {
      comments = JSON.parse(data);
      if (comments.map != null) {
        formatted = comments.map(in_li).join('');
        return this.out.innerHTML = "<ul>" + formatted + "</ul>";
      }
    }
  };

  return Comments;

})();

exports.Comments = Comments;

}});

defmodule({main: function (require, exports) {
  var http_request, init;

http_request = function(url, callback) {
  var http;
  http = new XMLHttpRequest;
  http.open('POST', url, true);
  http.onreadystatechange = function() {
    if (http.readyState === 4) return callback(http.responseText);
  };
  return http.send();
};

init = function() {
  var Comments, comment_form, comments, comments_node;
  comment_form = document.querySelector('#comment');
  if (comment_form != null) {
    Comments = require('./comments').Comments;
    comments_node = document.querySelector('.comments');
    comments = new Comments(window.location.href, comments_node, http_request);
    return comments.bind(comment_form, 'submit');
  }
};

exports.init = init;

}});
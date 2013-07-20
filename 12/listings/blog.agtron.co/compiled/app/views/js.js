(function() {
  var Js, View, fs;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  View = require('./view').View;

  fs = require('fs');

  Js = (function() {
    var src;

    __extends(Js, View);

    src = {};

    function Js(file) {
      this.file = file;
      if (!src[this.file]) {
        src[this.file] = fs.readFileSync("" + __dirname + "/../client/" + this.file, 'utf-8');
      }
    }

    Js.prototype.render = function() {
      return src[this.file];
    };

    return Js;

  })();

  exports.Js = Js;

}).call(this);

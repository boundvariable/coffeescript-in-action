(function() {
  var Controller, Static, fs;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  Controller = require('../framework/lib').Controller;

  fs = require('fs');

  Static = (function() {

    __extends(Static, Controller);

    function Static() {
      Static.__super__.constructor.apply(this, arguments);
    }

    /*
        fs.readFile "../client/#{file}", 'utf-8', (err, data) ->
          if err then throw err
          @reponse.writeHead 200, 'Content-Type': 'text/html'
          data
    */

    return Static;

  })();

  exports.Static = Static;

}).call(this);

(function() {
  var Post, fs, load;
  var __slice = Array.prototype.slice;

  fs = require('fs');

  Post = require('./models/post').Post;

  load = function(dir) {
    return fs.readdir(dir, function(err, files) {
      var file, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = files.length; _i < _len; _i++) {
        file = files[_i];
        if (/.*[.]txt$/.test(file)) {
          _results.push(fs.readFile("" + dir + "/" + file, 'utf-8', function(err, data) {
            var content, title, _ref;
            _ref = data.split('\n'), title = _ref[0], content = 2 <= _ref.length ? __slice.call(_ref, 1) : [];
            return new Post(title, content.join('\n'));
          }));
        }
      }
      return _results;
    });
  };

  exports.load = load;

}).call(this);

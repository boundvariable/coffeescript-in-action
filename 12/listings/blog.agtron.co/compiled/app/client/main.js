(function() {
  var http_request, init;

  http_request = function(url, callback) {
    var http;
    http = new XMLHttpRequest;
    http.open('POST', url, true);
    http.onreadystatechange = function() {
      if (http.readyState === 4) {
        return callback(http.responseText);
      }
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

}).call(this);

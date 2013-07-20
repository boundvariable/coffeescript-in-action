(function() {
  var Comments, describe, it, _ref;

  _ref = require('chromic'), describe = _ref.describe, it = _ref.it;

  Comments = require('../../app/client/comments').Comments;

  describe('Comments', function() {
    it('should post a comment to the server', function() {
      var comment, comments, http_request, requested;
      requested = false;
      http_request = function(url) {
        return requested = url;
      };
      comments = new Comments('http://the-url', {}, http_request);
      comment = 'Hey Agtron. Nice site.';
      comments.post(comment);
      return requested.should_be("http://the-url/comments?insert=" + comment);
    });
    it('should fetch the comments when constructed', function() {
      var comments, http_request, requested;
      requested = false;
      http_request = function(url) {
        return requested = url;
      };
      comments = new Comments('http://the-url', {}, http_request);
      return requested.should_be("http://the-url/comments");
    });
    it('should bind to event on the element', function() {
      var comments, element, post_received;
      comments = new Comments('http://the-url', {}, function() {});
      element = {
        querySelector: function() {
          return element;
        },
        value: 'A comment from Scruffy'
      };
      comments.bind(element, 'post');
      post_received = false;
      comments.post = function(comment) {
        return post_received = comment;
      };
      element.onpost();
      return post_received.should_be(element.value);
    });
    return it('should render comments to the page as a list', function() {
      var comments, out;
      out = {
        innerHTML: function(content) {
          var rendered_content;
          return rendered_content = content;
        }
      };
      comments = new Comments('http://the-url', out, function() {});
      comments.render('["One", "Two", "Three"]');
      return out.innerHTML.should_be("<ul><li>One</li><li>Two</li><li>Three</li></ul>");
    });
  });

}).call(this);

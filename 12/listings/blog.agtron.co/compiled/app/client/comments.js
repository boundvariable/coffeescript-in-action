(function() {
  var Comments,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

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
      var comment,
        _this = this;
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

}).call(this);

(function() {
  var View;

  View = (function() {

    function View() {}

    View.prototype.render = function() {
      return 'Lost?';
    };

    View.prototype.wrap = function(content) {
      if (content == null) content = '';
      return "<!DOCTYPE html>\n<html dir='ltr' lang='en-US'>\n<head>\n<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>\n<script src='/application.js'></script>\n<title>Agtron's blog</title>\n\n" + content + "\n\n<script>require('main').init();</script>";
    };

    return View;

  })();

  exports.View = View;

}).call(this);

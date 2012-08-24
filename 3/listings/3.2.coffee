# CoffeeScript

count_words = (s, del) ->
  if s
    words = s.split del
    words.length
  else
    0

### JavaScript

var count_words = function (s, del) {
  var words;
  if (s) {
    words = s.split(del);
    return words.length;
  } else {
    return 0;
  }
}
###
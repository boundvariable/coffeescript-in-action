var countWords = function (s, del) {
  var words;
  if (s) {
    words = s.split(del);
    return words.length;
  } else {
    return 0;
  }
};

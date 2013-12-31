## Rot13
A simple letter substitution cipher that replaces a letter
with the letter 13 letters after it in the alphabet.

    charRot13 = (char) ->

The built-in string utility for getting character codes can be used

      charCode = char.charCodeAt 0

If the character is in the alphabet up to 'm' then
add 13 to the character code

      charCodeRot13 = if charInRange char, 'a', 'm'
        charCode + 13

If the character is after 'm' in the alphabet then
subtract 13 from the character code

      else if charInRange char, 'n', 'z'
        charCode - 13
      else
        charCode

Characters can be converted back using the built-in string method

      String.fromCharCode charCodeRot13

A character is in a specific range regardless of whether
it's uppercase or lowercase

    charInRange = (char, first, last) ->
      lowerCharCode = char.toLowerCase().charCodeAt(0)
      first.charCodeAt(0) <=  lowerCharCode <= last.charCodeAt(0)


Converting a string is done by converting all the characters
and joining the result

    stringRot13 = (string) ->
      (charRot13 char for char in string).join ''


    assert = require 'assert'

    assert.equal stringRot13('Some Rot13 for you'), 'Fbzr Ebg13 sbe lbh'
    assert.equal stringRot13('Fbzr Ebg13 sbe lbh'), 'Some Rot13 for you'

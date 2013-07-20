
{add_word, remove_word} = require './word_utils'

{describe, it} = require 'chromic'

#curry = curry '../6/curry'

make_document = ->
  node =
    className: ""

  nodes = {}

  querySelector: (selector) ->
    unless nodes[selector]?
      nodes[selector] = Object.create node
    nodes[selector]

# you will recognise this pattern.
# These two functions are the same
# except for the strategy they use.

modify_class = (selector, modifier, new_class) ->
  element = document.querySelector selector
  element.className = modifier(element.className, new_class)

modify_class = (seeker, selector, modifier, new_class) ->
  element = seeker(selector)
  element.className = modifier(element.className, new_class)

add_class = (selector, new_class) ->
  modify_class(selector, add_word, new_class)

remove_class = (selector, old_class) ->
  modify_class(selector, remove_word, old_class)

# perhaps should use curry here instead?

describe "adding and removing classes", ->
  document = make_document()

  assert_class = (selector, expected) ->
    document.querySelector(selector).className.should_be expected

  it "should add a class", ->
    add_class "#sel", "def"
    assert_class "#sel", "def"

    add_class "#sel", "jkl"
    assert_class "#sel", "def jkl"

    remove_class "#sel", "def"
    assert_class "#sel", "jkl"


exports.add_class = add_class
exports.remove_class = remove_class

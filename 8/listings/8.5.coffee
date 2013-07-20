css = (raw) ->
  hyphenate = (property) ->
    dashThenUpperAsLower = (match, pre, upper) ->
      "#{pre}-#{upper.toLowerCase()}"
    property.replace /([a-z])([A-Z])/g, dashThenUpperAsLower


  output = (for selector, rules of raw
    rules = (for ruleName, ruleValue of rules
      "#{hyphenate ruleName}: #{ruleValue};"
    ).join '\n'
    """
    #{selector} {
      #{rules}
    }
    """
  ).join '\n'


assert = require 'assert'

emphasis = ->
    fontWeight: 'bold'

raw =
  'ul':
    emphasis()
  '.x':
    fontSize: '2em'

console.log css(raw)

assert css(raw) is '''
ul {
  font-weight: bold;
}
.x {
  font-size: 2em;
}'''

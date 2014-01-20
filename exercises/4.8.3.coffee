class GranTurismo
  constructor: (options) ->
    @options = options
  summary: ->
    ("#{key}: #{value}" for key, value of @options).join "\n"

options =
  wheels: 'phat'
  dice: 'fluffy'

scruffysGranTurismo = new GranTurismo options

scruffysGranTurismo.summary()
# wheels: phat
# dice: fluffy

# The constructor could use the shorthand for arguments:
class GranTurismo
  constructor: (@options) ->
   summary: ->
     ("#{key}: #{value}" for key, value of @options).join "\n"

scruffysGranTurismo.summary()
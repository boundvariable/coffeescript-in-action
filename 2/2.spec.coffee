chapter2 = require './2'

{it, stub, describe} = require 'chromic'

describe "chapter 2", ->
  it "should evaluate on, yes, off and no to true, true, false and true", ->
    on.shouldBe true
    yes.shouldBe true
    off.shouldBe false
    no.shouldBe false

  it "should do assignment", ->
    texasRanger = {actor: 'Chuck Norris'}
    texasRanger.shouldBe {actor: 'Chuck Norris'}
    texasRanger = true
    texasRanger.shouldBe true

  it "should demonstrate reference error for undefined", ->
    (-> pegasus).shouldThrow "pegasus is not defined"


  it "should demonstrate negation", ->
    (!true).shouldBe false

  it "should demonstrate different strings not being equal", ->
    wuss = 'A weak or ineffectual person'
    chuckNorris = 'Chuck Norris'
    (chuckNorris is wuss).shouldBe false
    (chuckNorris isnt wuss).shouldBe true

  it "should demonstrate 'isnt' and 'is not' have different meaning", ->
    (5 isnt 6).shouldBe true
    (5 is not 6).shouldBe false


  it "should demonstrate no type coercion with equality operator", ->
    ('' == false).shouldBe false

  it "should demonstrate addition", ->
    (3 + 3).shouldBe 6

  it "should demonstrate coercing a number with + operator", ->
    (4 + '3').shouldBe 43

  it "should demonstrate coercing a string with * operator", ->
    ('3'*3).shouldBe 9
    ('bork'*3).shouldBe NaN

  it "should demonstrate modulo", ->
    (3%2).shouldBe 1
    (4%2).shouldBe 0
    (not (3%2)).shouldBe false
    (not (4%2)).shouldBe true

  it "should demonstrate comparison", ->
    (42 > 0).shouldBe true
    (42 >= 42).shouldBe true
    time = 13
    (time > 12).shouldBe true
    ('Aardvark' < 'Zebra').shouldBe true
    (2 > 'giraffe').shouldBe false

  it "should demonstrate guard", ->
    wuss = 'A weak or ineffectual person'
    chuckNorris = 'Chuck Norris'
    (chuckNorris is wuss and pickFight).shouldBe false

  it "should demonstrate default", ->
    wuss = 'A weak or ineffectual person'
    chuckNorris = 'Chuck Norris'
    runAway = 'Running away!'
    (chuckNorris is wuss or runAway).shouldBe 'Running away!'

  it "should demonstrate defining a function with default", ->
    makeCoffee = (style) -> style || 'Espresso'
    (makeCoffee()).shouldBe 'Espresso'
    makeCoffee('Cappuccino').shouldBe 'Cappuccino'

  it "should demonstrate object property access", ->
    texasRanger = {actor: 'Chuck Norris'}
    texasRanger.actor.shouldBe 'Chuck Norris'

    movie = {title: 'Way of the Dragon', star: 'Bruce Lee'}
    myPropertyName = 'title'
    movie[myPropertyName].shouldBe 'Way of the Dragon'

  it "should demonstrate evaluation to 'object' for typeof null", ->
    (typeof null).shouldBe 'object'

  it "should demonstrate dynamic and weak typing", ->
    dynamicAndWeak = '3'
    weakAndDynamic = 5
    (dynamicAndWeak + weakAndDynamic).shouldBe 35

    dynamicAndWeak = 3
    (dynamicAndWeak + weakAndDynamic).shouldBe 8

  it "should demonstrate existence", ->
    pegasus?.shouldBe false
    roundSquare?.shouldBe false
    pegasus = 'Horse with wings'
    (pegasus?).shouldBe true


it "should demonstrate if statement", ->
   raining = true
   activity = if raining
     'Stay inside'
   else
     'Go out'

   activity.shouldBe 'Stay inside'

it "should demonstrate switch statement", ->
  connectJackNumber = (number) ->
    "Connecting jack #{number}"

  receiver = 'Betty'

  (switch receiver
    when 'Betty'
      connectJackNumber 4
    when 'Sandra'
      connectJackNumber 22
    when 'Toby'
      connectJackNumber 9
    else
      'I am sorry, your call cannot be connected').shouldBe 'Connecting jack 4'

it "should demonstrate switch statement as expression", ->
  month = 3
  monthName = switch month
    when 1
      'January'
    when 2
      'February'
    when 3
      'March'
    when 4
      'April'
    else
      'Some other month'

  monthName.shouldBe 'March'

it "should demonstrate latte example", ->
  style = 'latte'
  milk = switch style
    when "latte", "cappucino"
      yes
    else
      no

  milk.shouldBe true

it "should demonstrate returning the last expression in a switch", ->
  hasMilk = (style) ->
    switch style
      when "latte", "cappucino"
        yes
      else
        no

  hasMilk('espresso').shouldBe false

it "should demonstrate the value of a switch being undefined", ->
  pseudonym = 'Thomas Veil'
  identity = switch pseudonym
    when 'Richard Bachman'
      'Stephen King'
    when 'Ringo Starr'
      'Richard Starkey'

  (typeof identity).shouldBe 'undefined'

it "should demonstrate loop", ->
  clean = (what) ->
    if what is 'House'
      'Now cleaning house'
    else
      'Now cleaning everything'
  clean('House').shouldBe 'Now cleaning house'

  messy = true
  while messy
    clean 'House'
    messy = false

it "should demonstrate exception blocks", ->
  flyAway = (animal) ->
    if animal is 'pig'
      throw new Error 'Pigs cannot fly'

  peter = 'pig'
  (-> flyAway(peter)).shouldThrow "Pigs cannot fly"

it "should demonstrate inline blocks", ->
  year = 1983
  if year is 1983 then hair = 'perm'
  hair.shouldBe 'perm'

  day = 23
  lastDigit = 3
  daySuffix = switch lastDigit
    when 1 then 'st'
    when 2 then 'nd'
    when 3 then 'rd'
    else 'th'

  "#{day}#{daySuffix}".shouldBe '23rd'

  time = 15
  allowed = if time < 12 then 'Yes' else 'No!'
  allowed.shouldBe 'No!'

it "should demonstrate string searching", ->
  'haystack'.search('needle').shouldBe -1
  'haystack'.search('hay').shouldBe 0
  'haystack'.search('stack').shouldBe 3

it "should demonstrate string replacement", ->
  'haystack'.replace('hay', 'needle').shouldBe 'needlestack'

it "should demonstrate string splitting", ->
  'Banana,Banana'.split(/,/).shouldBe [ 'Banana', 'Banana' ]

it "should demonstrate string interpolation", ->
  coffee = 'Ristresso'
  "Enjoy your #{coffee}!".shouldBe 'Enjoy your Ristresso!'

it "should demonstrate interpolation with a switch", ->
  userName = 'Scruffy'

  Date.stub("getDay") -> 3

  dayOfWeek = new Date().getDay()

  dayName = switch dayOfWeek
    when 0 then 'Sunday'
    when 1 then 'Monday'
    when 2 then 'Tuesday'
    when 3 then 'Wednesday'
    when 4 then 'Thursday'
    when 5 then 'Friday'
    when 6 then 'Saturday'

  "Hi, my name is #{userName}. Today is #{dayName}.".shouldBe "Hi, my name is Scruffy. Today is Wednesday."

it "should demonstrate array access", ->
  macgyverTools = ['Swiss Army knife', 'duct tape']
  macgyverTools[0].shouldBe 'Swiss Army knife'
  macgyverTools[1].shouldBe 'duct tape'

it "should demonstrate array length", ->
  fence = ['fence pail', 'fence pail']
  fence.length.shouldBe 2

it "should demonstrate sparse arrays", ->
  fence = ['fence pail', 'fence pail']
  fence[999] = 'fence pail'
  fence.length.shouldBe 1000

it "should demonstrate array joining", ->
  ['double', 'barreled'].join('-').shouldBe 'double-barreled'

it "should demonstrate array slicing", ->
  ['good', 'bad', 'ugly'].slice(0, 2).shouldBe ['good', 'bad']
  [0,1,2,3,4,5].slice(0, 1).shouldBe [0]
  [0,1,2,3,4,5].slice(3, 5).shouldBe [3,4]


it "should demonstrate array concat", ->
  concatenated = ['mythril', 'energon'].concat ['nitron', 'durasteel', 'unobtanium']
  concatenated.shouldBe [ 'mythril', 'energon', 'nitron', 'durasteel', 'unobtanium' ]

it "should demonstrate slice as non-modifying", ->
  potatoes = ['coliban', 'desiree', 'kipfler']
  saladPotatoes = potatoes.slice 2,3
  saladPotatoes.shouldBe ['kipfler']

  potatoes.shouldBe ['coliban', 'desiree', 'kipfler']

it "should demonstrate in operator", ->
  ('to be' in ['to be', 'not to be']).shouldBe true

  living = 'the present'
  (living in ['the past', 'the present']).shouldBe true

it "should demonstrate ranges", ->
  [1..10].shouldBe [ 1,2,3,4,5,6,7,8,9,10 ]
  [5..1].shouldBe [ 5,4,3,2,1 ]
  [1...10].shouldBe [ 1,2,3,4,5,6,7,8,9 ]
  ['good', 'bad', 'ugly'][0..1].shouldBe ['good', 'bad']

it "should demonstrate comprehension", ->
  (number for number in [9,0,2,1,0]).shouldBe [9,0,2,1,0]
  (number + 1 for number in [9,0,2,1,0]).shouldBe [10,1,3,2,1]
  (0 for number in [9,0,2,1,0]).shouldBe [0,0,0,0,0]
  letter for letter in ['x','y','z']
  letter.shouldBe 'z'


it "should demonstrate comprehension on recipe", ->
  recipe = [
    'block of dark chocolate'
    'stick butter'
    'cup of water'
    'cup of brown sugar'
    'packet of flour'
    'egg'
  ]

  bigRecipe = ("2x #{ingredient}" for ingredient in recipe)
  bigRecipe.shouldBe [
    '2x block of dark chocolate'
    '2x stick butter'
    '2x cup of water'
    '2x cup of brown sugar'
    '2x packet of flour'
    '2x egg'
  ]

it "should demonstrate function invocation inside comprehension", ->
  recipe = [
    'block of dark chocolate'
    'stick butter'
    'cup of water'
    'cup of brown sugar'
    'packet of flour'
    'egg'
  ]

  mix = (ingredient) ->
    "Put #{ingredient} in the bowl"

  instructions = (mix ingredient for ingredient in recipe)

  instructions.shouldBe [
    "Put block of dark chocolate in the bowl"
    "Put stick butter in the bowl"
    "Put cup of water in the bowl"
    "Put cup of brown sugar in the bowl"
    "Put packet of flour in the bowl"
    "Put egg in the bowl"
  ]

it "should demonstrate comprehension with when guard", ->
  recipe = [
    'block of dark chocolate'
    'stick butter'
    'cup of water'
    'cup of brown sugar'
    'packet of flour'
    'egg'
  ]

  mix = (ingredient) ->
    "Put #{ingredient} in the bowl"

  flourlessInstructions = (mix ingredient for ingredient in recipe when ingredient.search 'flour' == -1)

  flourlessInstructions.shouldBe [
    "Put block of dark chocolate in the bowl"
    "Put stick butter in the bowl"
    "Put cup of water in the bowl"
    "Put cup of brown sugar in the bowl"
    "Put packet of flour in the bowl"
    "Put egg in the bowl"
  ]

it "should demonstrate even number comprehension", ->
  (num for num in [1..10] when not (num%2)).shouldBe [2, 4, 6, 8, 10]

it "should demonstrate guarded comprehension", ->
  (num for num in [1..10] when num < 4).shouldBe [ 1, 2, 3 ]


it "should demonstrate taking every second item in array using by", ->
  (person for person in ['Kingpin', 'Galactus', 'Thanos', 'Doomsday'] by 2).shouldBe ['Kingpin', 'Thanos']
  person.shouldBe 'Thanos'

it "should show the wrong way to multiply an array", ->
  luckyNumbers = [3,4,8,2,1,8]
  i = 0
  twiceAsLucky = []
  while i != luckyNumbers.length
    twiceAsLucky[i] = luckyNumbers[i]*2
    i = i + 1

  twiceAsLucky.shouldBe [6,8,16,4,2,16]

it "should show the comprehension way to multiply an array", ->
  luckyNumbers = [3,4,8,2,1,8]
  (number * 2 for number in luckyNumbers).shouldBe [6,8,16,4,2,16]

it "should demonstrate heredoc interpolation", ->
  title = "test"
  """
  <!doctype html>
  <title>#{title}</title>
  <body>
  """.shouldBe "<!doctype html>\n<title>test</title>\n<body>"

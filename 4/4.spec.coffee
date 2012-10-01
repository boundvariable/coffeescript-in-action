chapter4 = require './4'

fs = require 'fs'
{it, stub, describe} = require 'chromic'

jsdom = require 'jsdom'

describe "chapter 4", ->
  it "should demonstrate basic class", ->
    class Book
    coffeescriptInAction = new Book
    (coffeescriptInAction instanceof Book).shouldBe true

  it "should demonstrate ex-nihilo object creation", ->
    brandSpankingNewObject = {}
    anotherOne = {}

    exists = brandSpankingNewObject?
    exists.shouldBe true
    anotherOne?.shouldBe {}

  it "should demonstrate object property", ->
    {title: 'Way of the Dragon'}.title.shouldBe 'Way of the Dragon'
    {title: 'Way of the Dragon', star: 'Bruce Lee'}.star.shouldBe 'Bruce Lee'
    {title: 'Way of the Dragon', actors: ['Bruce Lee', 'Chuck Norris']}.actors.shouldBe ['Bruce Lee', 'Chuck Norris']
    {title: 'Way of the Dragon', info: {budget: '$130000', released: '1972'}}.info.shouldBe {budget: '$130000', released: '1972'}
    movie = {title: 'Way of the Dragon'}
    movie.shouldBe {title: 'Way of the Dragon'}

  it "should demonstrate yaml syntax is equivalent", ->
    exNihiloUsingYaml =
      title: 'Enter the Dragon'
      info:
        budget: '$850000'
        released: '1973'

    exNihiloUsingYaml.shouldBe {title: 'Enter the Dragon', info: {budget: '$850000', released: '1973'}}


  phoneNumbers =
    hannibal: '555-5551'
    darth: '555-5552'
    hal9000: 'disconnected'
    freddy: '555-5554'
    'T-800': '555-5555'

  it "should show phone numbers in object", ->
    phoneNumbers.darth.shouldBe '555-5552'
    phoneNumbers.hal9000.shouldBe 'disconnected'
    (phoneNumbers.T-800).shouldBeNull
    phoneNumbers['T-800'].shouldBe '555-5555'
    phoneNumbers['freddy'].shouldBe '555-5554'

  it "should show property name from variable", ->
    friendToCall = 'hannibal'
    phoneNumbers[friendToCall].shouldBe '555-5551'

    friendToCall = 'darth'
    phoneNumbers[friendToCall].shouldBe '555-5552'

  it "should show adding properties", ->
    phoneNumbers.kevin = '555-5556'
    phoneNumbers['Agent Smith'] = '555-5557'

    expectedPhoneNumbers =
      hannibal:'555-5551'
      darth:'555-5552'
      hal9000:'disconnected'
      freddy: '555-5554'
      'T-800': '555-5555'
      'kevin': '555-5556'
      'Agent Smith': '555-5557'

    phoneNumbers.shouldBe expectedPhoneNumbers

  it "should show changing a property", ->
    phoneNumbers.hannibal = '555-5525'

    phoneNumbers.hannibal.shouldBe '555-5525'

  it "should demonstrate of operator", ->
  ('hal9000' of phoneNumbers).shouldBe true
  ('skeletor' of phoneNumbers).shouldBe false

  it "should demonstrate arguments", ->
    orderMaserati = (colour) ->
      """Order summary
      - Make: Gran Turismo S
      - Colour: #{colour}
      """

    orderMaserati("Nero Carbonio").shouldBe """Order summary
      - Make: Gran Turismo S
      - Colour: Nero Carbonio
      """

  it "should demonstrate multiple named arguments", ->
    orderMaserati = (exteriorColour, interiorColour) ->
      """Order summary:
      - Make: Gran Turismo

      Options:
      - Exterior colour: #{exteriorColour}
      - Interior colour: #{interiorColour}
      """

    orderMaserati('x', 'y').shouldBe """Order summary:
    - Make: Gran Turismo

    Options:
    - Exterior colour: x
    - Interior colour: y
    """

  it "should demonstrate named arguments", ->
    orderMaserati = (options) ->
      """Order summary:
      Make: Gran Turismo

      Options:
      Exterior colour: #{options.exterior}
      Interior colour: #{options.interior}
      Interior trim: #{options.trim}
      Wheel rims: #{options.wheels}
      """


    p = orderMaserati(exterior:'red',interior:'red',trim:'walnut',wheels:'18')

    p.shouldBe """Order summary:
    Make: Gran Turismo

    Options:
    Exterior colour: red
    Interior colour: red
    Interior trim: walnut
    Wheel rims: 18"""

  it "should show adding one to view", ->
    views =
      'ren': 30
      'stimpy': 10

    views.ren = views.ren + 1
    views.ren.shouldBe 31

  it "show array comprehension", ->
    (number + 1 for number in [1,2,3,4,5]).shouldBe [2,3,4,5,6]

  # see also listing 4.3 and 4.4
  it "should show equivalent result for comprehension and JS for...in loop", ->
    movie =
      title: 'From Dusk till Dawn'
      released: '1996'
      director: 'Robert Rodriguez'
      writer: 'Quentin Tarantino'

    properties = (property for property of movie)

    `
    propertiesJs = []
    for (var property in movie) {
      propertiesJs.push(property);
    }`

    properties.shouldBe propertiesJs

  it "should demonstrate comprehending properties", ->
    comprehended = (name for name of {bob: 152, john: 139, tracy: 209})
    comprehended.shouldBe ['bob', 'john', 'tracy']

  views =
      '/reviews/pool-of-radiance': 121
      '/reviews/summer-games': 90
      '/reviews/wasteland': 139
      '/reviews/impossible-mission': 76

  it "should demonstrate getting urls from views", ->
    (url for url of views).shouldBe [
      '/reviews/pool-of-radiance'
      '/reviews/summer-games'
      '/reviews/wasteland'
      '/reviews/impossible-mission' ]

  it "should demonstrate comprehending values", ->
    comprehended = (score for name, score of {bob: 152, john: 139, tracy: 209})
    comprehended.shouldBe [152, 139, 209]


  it "should demonstrate getting counts from views", ->
    views =
      '/reviews/pool-of-radiance': 121
      '/reviews/summer-games': 90
      '/reviews/wasteland': 139
      '/reviews/impossible-mission': 76

    (count for url, count of views).shouldBe [ 121, 90, 139, 76 ]
chapter3 = require './3'

fs = require 'fs'
{it, stub, describe} = require 'chromic'

jsdom = require 'jsdom'

describe "chapter 3", ->

  it "should demonstrate function that returns a string", ->
    vendor = -> 'cola'
    vendor().shouldBe 'cola'

  it "should demonstrate multiplication", ->
    (3 * 4).shouldBe 12

  it "should demonstrate a function that multiples 3 and 4", ->
    threeTimesFour = -> 3 * 4
    (typeof threeTimesFour).shouldBe "function"
    threeTimesFour().shouldBe 12

  it "should demonstrate a generic multiplication function", ->
    multiply = (a,b) -> a * b
    multiply(2,7).shouldBe 14

  it "should demonstrate a function to convert GB to MB", ->
    gigabytesToMegabytes = (gigabytes) -> gigabytes * 1024
    gigabytesToMegabytes(7).shouldBe 7168

  it "should demonstrate text splitting", ->
    text = 'Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday'
    daysInWeek = text.split /,/
    daysInWeek.length.shouldBe 7
    text = 'Spring,Summer,Autumn,Winter'
    seasons = text.split /,/
    seasons.length.shouldBe 4

  it "should demonstrate a function that counts comma separated words", ->
    countWords = (text) -> text.split(/,/).length
    countWords('sight,smell,taste,touch,hearing').shouldBe 5
    countWords('morning,noon,night').shouldBe 3
    directions = countWords 'north,east,south,west'
    directions.shouldBe 4
    planets = 'Mercury,Venus,Earth,Mars,Jupiter,Saturn,Uranus,Neptune,Pluto'
    countWords(planets).shouldBe 9

  it "should demonstrate saying hello", ->
    sayHello = -> 'Hello!'
    sayHello().shouldBe 'Hello!'

  it "should demonstrate a function that takes the delimiter as an argument", ->
    beerStyles = 'Pale Ale:Pilsner:Stout:Lager:Bock'

    countWords = (text, delimiter) ->
      words = text.split delimiter
      words.length

    countWords('Josie:Melody:Valerie:Alexandra', ':').shouldBe 4
    countWords('halloween/scream/maniac', '/').shouldBe 3
    countWords('re#brown#tag#table', '#').shouldBe 4
    countWords(beerStyles, ':').shouldBe 5

  it "should demonstrate that the existing count words breaks on an empty string", ->
    countWords = (text, delimiter) ->
      words = text.split(delimiter || /,/)
      words.length
    countWords('').shouldBe 1


  it "should demonstrate a new version that works for empty string", ->
    countWords = (text, delimiter) ->
      if text
        words = text.split(delimiter || /,/)
        words.length
      else
        0

    countWords('a,b,c').shouldBe 3

    countWords('').shouldBe 0

  it "should demonstrate a version with explicit return", ->
    count = (text, delimiter) ->
      return 0 unless text
      words = text.split(delimiter || /,/)
      words.length

    count().shouldBe 0


  it "should demonstrate adding a click handler via jquery", ->
    html = """
      <!doctype html>
      <html>
      <title>How many people are coming?</title>
      <body>
      <div id='how-many-attendees'>How many attendees?</div>
    """

    jsdom.env
      html: html
      scripts: [ "http://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js" ],
      done: (errors, window) ->
        try
          window.$("#how-many-attendees").html().shouldBe "How many attendees?"
        catch e
          console.log e


  it "should demonstrate setTimeout", ->
    res = ""
    log = (value) -> res = value

    # Overriding a host object. Not recommended as a general practice.
    setTimeout = @immediately

    partyMessage = -> log "It's party time!"
    setTimeout partyMessage, 1000

    res.shouldBe "It's party time!"






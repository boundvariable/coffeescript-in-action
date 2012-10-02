chapter5 = require './5'

fs = require 'fs'
{it, stub, describe} = require 'chromic'

jsdom = require 'jsdom'


evalWithDom = (html, executer) ->
  jsdom.env
    html: html
    done: (errors, window) ->
      try
        executer window
      catch e
        console.log e

describe "chapter 5", ->

  data = JSON.parse '''{
    "Fuji-X100": {
      "description": "a camera",
      "stock":5
    },
    "Leica-X1": {
      "description": "a camera",
      "stock":6
    }
  }'''

  it "should demonstrate property access from JSON", ->
    data["Fuji-X100"].stock.shouldBe 5

  it "should demonstrate stringifying in a for comprehension", ->
    res = for own name, info of data
      "#{name}: #{info.description} (#{info.stock} in stock)"
    res.shouldContain "Fuji-X100: a camera (5 in stock)"

  it "should demonstrate rendering to HTML", ->
    res = for own name, info of data
      "<li>#{name}: #{info.description} (#{info.stock} in stock)</li>"
    res.shouldContain "<li>Fuji-X100: a camera (5 in stock)</li>"

  it "should demonstrate a way to use that to create an event handler for each", ->
    for own name, info of data
      called = false
      evalWithDom "<html><body>", (dom) ->
        li = dom.document.createElement "li"
        li.innerHTML = "#{name}: #{info.description} (#{info.stock} in stock)"
        li.onclick = -> called = true
        dom.document.body.appendChild li
        #called = dom.document.getElementsByTagName("li")[0]

      #called.shouldBe true

  it "should demonstrate a camera class", ->
    class Camera
      constructor: (name, info) ->
        @name = name
        @info = info
      render: ->
        "#{@name}: #{@info.description} (#{@info.stock} in stock)"

    leicaX1 = new Camera "Leica-X1", {
      description: "An awesome camera", stock: 5
    }

    leicaX1.render().shouldBe "Leica-X1: An awesome camera (5 in stock)"

  it "should demonstrate extends", ->
    class Product
    class Camera extends Product
      constructor: ->
        super

  it "should demonstrate extending a built in", ->
    Date::daysFromToday = ->
      millisecondsInDay = 86400000
      today = Date.now()
      diff = @ - today
      Math.floor diff/millisecondsInDay

    christmas = new Date "December 25, 2012 00:00"

    Date.now = -> christmas

    christmas.daysFromToday().shouldBe 0

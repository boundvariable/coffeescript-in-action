{ Views } = require './4.8'

{it, stub, describe} = require 'chromic'

describe "listing 4.8", ->

  it "should increment views", ->
    views = new Views
    for n in [1..31]
      views.increment "ABCDEF"
    views.pages["ABCDEF"].shouldBe 31

  it "should have total", ->
    views = new Views
    for n in [1..20]
      views.increment "A"
    for n in [1..10]
      views.increment "B"
    views.total().shouldBe 30
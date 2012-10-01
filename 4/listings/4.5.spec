{views, viewsIncrement, total} = require './4.5'

{it, stub, describe} = require 'chromic'

describe "listing 4.5", ->
  for n in [1..31]
    viewsIncrement "ABCDEF"
  for n in [1..20]
    viewsIncrement "A"
  for n in [1..10]
    viewsIncrement "B"

  it "should increment views object", ->
    views["ABCDEF"].shouldBe 31

  it "should have total", ->
    total().shouldBe 61

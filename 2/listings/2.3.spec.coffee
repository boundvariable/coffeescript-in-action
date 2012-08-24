{divisibleBy} = require './2.3'
{it, stub, describe} = require 'chromic'

describe "divisibleBy" , ->
  it "should return empty array for no range", ->
    divisibleBy(null, 5).shouldBe []

  it "should include boundaries", ->
    divisibleBy([1..40], 5).shouldBe [5,10,15,20,25,30,35,40]
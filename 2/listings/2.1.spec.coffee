
listing21 = require './2.1'
{it, stub, describe} = require 'chromic'

describe "listing 2.1", ->
  describe "hasMilk", ->
    it "should return true for a latte or cappucino", ->
      listing21.hasMilk("latte").shouldBe true

  describe "make_coffee", ->
    it "should return a given style", ->
      listing21.makeCoffee("Zorb").shouldBe "Zorb"

    it "should return the default style", ->
      listing21.makeCoffee().shouldBe "Espresso"

    it "should use the house roast", ->
      listing21.specifyHouseRoast "Yirgacheffe"
      listing21.makeCoffee().shouldBe "Yirgacheffe Espresso"

  describe "barista", ->
    it "should deny a milky coffee after midday", ->
      Date.stub("getHours") -> 15
      listing21.barista("latte").shouldBe "No!"

    it "should allow a milky coffee before midday", ->
      listing21.specifyHouseRoast "Yirgacheffe"
      Date.stub("getHours") -> 9
      listing21.barista("latte").shouldBe "Enjoy your Yirgacheffe latte!"


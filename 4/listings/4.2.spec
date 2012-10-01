listing42 = require './4.2'

{it, stub, describe} = require 'chromic'


describe "phonebook", ->
  phonebook = listing42.phonebook

  it "should add a number", ->
    phonebook.numbers = {}
    phonebook.add("Xenomorph", "123-1234")
    phonebook.numbers.shouldContain "Xenomorph": "123-1234"

  it "should get a number that is present", ->
    phonebook.add "Frank Booth", "999-9999"
    phonebook.get("Frank Booth").shouldBe "Frank Booth: 999-9999"

  it "should not get a number that is not present", ->
    phonebook.get("!").shouldBe "! not found"
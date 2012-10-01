{ personalViews, businessViews, views } = require './4.7'

{it, stub, describe} = require 'chromic'

describe "listing 4.7", ->

  it 'should increment business views', ->
    for n in [1..10]
      businessViews.increment()

    businessViews.total().shouldBe 10

  it 'should not increment personal views when incrementing business views', ->
    businessViews.increment()
    personalViews.total().shouldBe 0

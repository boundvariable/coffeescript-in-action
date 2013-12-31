chapter11 = require './10'

{it, stub, describe} = require 'chromic'

describe 'chapter 10', ->

  it 'should show that require.assert has an ok method', ->
    assert = require 'assert'
    (assert.ok.call?).shouldBe true

  it 'should show assert used on numbers', ->
    try
      assert = require 'assert'
      assert.ok 4 == 5
    catch e
      e.shouldBe "AssertionError: false == true"

  it 'should show do wrapped assertion', ->
    assert = require 'assert'
    do assert4Equals4 = ->
      assert.ok 4 == 4

  it 'should require word_utils.spec without assertion error', ->
    require './word_utils.spec'

  it 'should test word utils addword', ->
    {addWord} = require './word_utils'

    addWord('product special', 'popular').shouldBe 'product special popular'

  describe 'removeWord', ->
    tests = [
        initial: "product special"
        replace: "special"
        expected: "product"
      ,
        initial: "product special"
        replace: "spec"
        expected: "product special"
    ]

    it 'should show a remove_word that fails', ->
      removeWord = (text, word) ->
        text.replace word, ''
      removeWord('product special', 'special').shouldntBe 'product'
      removeWord('product special', 'special').shouldBe 'product '

    it 'should show a regex based remove_word that fails', ->
      removeWord = (text, word) ->
        replaced = text.replace word, ''
        replaced.replace(/^\s\s*/, '').replace(/\s\s*$/, '')

      try
        for { initial, replace, expected } in tests
          actual = removeWord initial, replace
          actual.shouldBe expected
      catch e
        e.shouldBe 'AssertionError: "product ial" == "product special"'

    it 'should show a working remove word', ->
      removeWord = (text, toRemove) ->
        words = text.split /\s/
        (word for word in words when word isnt toRemove).join ' '

      for { initial, replace, expected } in tests
        actual = removeWord initial, replace
        actual.shouldBe expected

  describe 'A scene', ->
    class Actor
      soliloquy: ->
        'To be or not to be...'
      stunt: ->
        'My arm! Call an ambulance.'

    it 'should complete with the star actor', ->
      scene = ->
        imaStarr = new Actor
        imaStarr.soliloquy()
        imaStarr.stunt()
        'Scene completed'

      scene().should_be 'Scene completed'

    it 'should complete with an injected actor', ->
      scene = (actor) ->
        actor.soliloquy()
        actor.stunt()
        'Scene completed'

      scene(new Actor).shouldBe 'Scene completed'

    it 'should complete with a hand-rolled double', ->
      scene = (actor) ->
        actor.soliloquy()
        actor.stunt()
        'Scene completed'

      double =
        soliloquy: ->
        stunt: ->

      scene(double).shouldBe 'Scene completed'


  describe 'extractData', ->
    extractData = (topic, http, callback) ->
      options =
        host: 'www.agtronsemporium.com'
        port: 80
        path: "/data/#{topic}"

      http.get(options, (res) ->
        callback res
      ).on 'error', (e) ->
        console.log e


    it 'should work with an http double', ->
      http =
        get: (options, callback) ->
          callback 'canned response'
          @
        on: (event, callback) ->
          # do nothing

      extractData 'some/topic', http, (response) ->
        response.shouldBe 'canned response'

  describe 'visits', ->

    database = userIdFor: -> 0
    permissions = allowDataFor: -> false
    http = hitsFor: -> 0
    user = name: 'Fred'

    it 'should demonstrate first version with 4 dependencies injected', ->
      visits = (database, http, user, permissions) ->
        if permissions.allowDataFor user
          http.hitsFor database.userIdFor(user.name)
        else
          'private'

      visits(database, http, user, permissions).shouldBe 'private'

    it 'should demonstrate second version with dependencies object', ->
      visits = (dependencies) ->
        if dependencies.permissions.allowDataFor user
          dependencies.http.hitsFor dependencies.database.userIdFor(user.name)
        else
          'private'

      dependencies = {database, permissions, http, user}
      visits(dependencies).shouldBe 'private'

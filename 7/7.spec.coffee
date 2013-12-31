assert = require 'assert'

{it, stub, describe} = require 'chromic'

describe 'Chapter 7', ->

  color = (it, color) -> "#{it} #{color}"
  find = (it) ->  it

  it 'should demonstrate the highlight function', ->
    highlight = (name) ->
      color find(name), 'yellow'

    highlight('x').shouldBe 'x yellow'

  it 'should demonstrate highlight function with array as arg', ->
    highlight = (names) ->
      for name in names
        color find(name), 'yellow'

    highlight(['x', 'y']).shouldBe ['x yellow', 'y yellow']

  it 'should demonstrate highlight with rest', ->
    highlight = (names...) ->
      (for name in names
        color find(name), 'yellow')

    highlight('x', 'y').shouldBe ['x yellow', 'y yellow']

  it 'should show that arguments does not have slice', ->
    names = []
    highlight = (names) ->
      (arguments.slice == undefined).shouldBe true

    highlight 'x', 'y'

  it 'should demonstrate need for spread', ->
  insert = (teams...) ->
    teams

  initialize = (teams...) ->
    insert teams

  res = initialize('wolverines', 'sabertooths', 'mongooses')
  res.shouldBe [ [ 'wolverines','sabertooths', 'mongooses' ] ]

  initialize = (teams...) ->
    insert teams...

  res = initialize 'wolverines', 'sabertooths', 'mongooses'
  res.shouldBe [ 'wolverines','sabertooths', 'mongooses' ]

  it 'should demonstrate the toggler', ->
    makeToggler = (active, inactive) ->
      ->
        temporary = active
        active = inactive
        inactive = temporary
        [active, inactive]

    toggler = makeToggler 'komodos', 'raptors'

    toggler().shouldBe ['raptors', 'komodos']
    toggler().shouldBe ['komodos', 'raptors']

  it 'should demonstrate destructuring array', ->
    active = 'komodos'
    inactive = 'raptors'

    [active, inactive] = [inactive, active]

    active.shouldBe 'raptors'
    inactive.shouldBe 'komodos'

  it 'should demonstrate destructuring toggler', ->
    makeToggler = (a, b) ->
      -> [a,b] = [b,a]

    toggler = makeToggler 'on', 'off'

    toggler().shouldBe ['off', 'on']
    toggler().shouldBe ['on', 'off']

  it 'should show array destructuring array', ->
    relegate = (team) -> "#{team.name} got relegated"

    rank = (array, using) ->
      array.sort (first, second) ->
        first[using] < second[using]

    competitors = [
      name: 'wildcats'
      points: 5
    ,
      name: 'leopards'
      points: 15
    ,
      name: 'bobcats'
      points: 3
    ]

    [first, field..., last] = rank competitors, 'points'

    relegate(last).shouldBe 'bobcats got relegated'

  it 'should demonstrate object destructuring', ->
    data =
      team2311:
        name: 'Honey Badgers'
        stats:
          scored: 22
          conceded: 22
          points: 11
      team4326:
        name: 'Mongooses'
        stats:
          scored: 14
          conceded: 19
          points: 8

    res = for id, team of data
      name = team.name
      points = team.stats.points
      {
        name: name
        points: points
      }

    res.shouldBe [{"name":"Honey Badgers","points":11},{"name":"Mongooses","points":8}]

    res = for id, team of data
      { name: team.name,  points: team.stats.points }

    res.shouldBe  [ { name: 'Honey Badgers', points: 11 }, { name: 'Mongooses', points: 8 } ]


  it 'should demonstrate a module pattern', ->
    competition = do ->
      find = ->
      color = ->
      highlight = -> 'highlight'
      initialize = ->

      highlight: highlight,
      initialize: initialize

    competition.highlight().shouldBe 'highlight'


  it 'should demonstrate a module pattern with object shorthand', ->
    makeCompetition = ->
      find = ->
      color = ->
      highlight = ->
      initialize = -> 'initialized'

      {highlight, initialize}

    competition = makeCompetition()
    competition.initialize().shouldBe 'initialized'


  it 'should show object for named parameters', ->
    sorter = ->

    makeCompetition = ({max, sort}) ->
      {max, sort}

    out = makeCompetition max: 11, sort: sorter
    out.shouldBe max: 11, sort: sorter

    out = makeCompetition sort: sorter, max: 5
    out.shouldBe max:5, sort: sorter


  it 'should demonstrate property access', ->
    user =
      name:
        title: 'Mr'
        first: 'Data'
        last: 'Object'
      contact:
        phone:
          home: '555 2234'
          mobile: '555 7766'
        email:
          primary: 'mrdataobject@coffeescriptinaction.com'

    user.contact.phone.home.shouldBe '555 2234'

  it 'should show exception when no null soak', ->
    s = 'unchanged'
    user =
      name:
        first: 'Haveno'
        middle: 'Contact'
        last: 'Details'

  assert.throws -> user.contact.phone.home

  it 'should show null soak preventing view error', ->
    render = (user) ->
      """
      <html>
      Home phone for #{user?.name?.first}: #{user?.contact?.phone?.home}
      """

    user =
      name:
        first: 'Donot'
        last: 'Callme'

    render(user: null).shouldBe """
    <html>
    Home phone for undefined: undefined
    """

  it 'should show guard preventing undefined in view', ->
    render = (user) ->
      """
      <html>
      Home phone for #{user?.name?.first||'user'}: #{user?.contact?.phone?.home||'N/A'}
      """

    user =
      name:
        first: 'Donot'
        last: 'Callme'

    render(user: null).should_be """
    <html>
    Home phone for user: N/A
    """

  it 'should show about ducks and races', ->
    class Duck
      walk: ->
      quack: (distance) ->

    daffy = new Duck

    class DuckRace
      constructor: (applicants) ->
        @ducks = (d for d in applicants when d instanceof Duck)
      go: ->
        duck.walk() for duck in @ducks

    class Hare
      run: ->
      walk: -> run()

    hare = new Hare
    race = new DuckRace [hare]

    (typeof daffy).should_be 'object'

    (daffy instanceof Duck).shouldBe true

    duck = new Duck
    ultraDuckMarathon = new DuckRace [duck]

    turnDuckIntoSomethingElse = ->
      duck.walk = null

    turnDuckIntoSomethingElse duck

    assert.throws -> ultraDuckMarathon.go()
    # TypeError: Property walk of object #<AsianDuck> is not a function


  it 'should show that instanceof is fragile', ->
    class A
    a = new A
    A:: = class Y

    (a instanceof A).shouldBe false

  it 'should show map', ->
    paid = [10, 50, 200]

    taxes = (price*0.1 for price in paid)
    taxes.shouldBe [1, 5, 20]

    taxes = paid.map (item) -> item*0.1
    taxes.shouldBe [1, 5, 20]

  it 'should show filter', ->
    friends = [
      { name: 'bob', location: 'CoffeeVille' }
      { name: 'tom', location: 'JavaLand' }
      { name: 'tom', location: 'PythonTown' }
      { name: 'tom', location: 'RubyCity' }
    ]

    filter = friends.filter (friend) -> friend.location is 'CoffeeVille'
    comprehension = (friend for friend in friends when friend.location is 'CoffeeVille')

    filter.shouldBe comprehension

  it 'should show reduce', ->
    friends = [
      { name: 'bob', owes: 10 }
      { name: 'sam', owes: 15 }
    ]

    owed = 0
    for friend in friends
      owed += friend.owes

    owing = (initial, friend) ->
      if initial.owes then initial.owes + friend.owes

    owed.shouldBe friends.reduce owing


  it 'should show creating function in comprehension', ->
    people = [ 'bill', 'ted' ]
    greetings = {}

    for person in people
      greetings[person] = ->
        "My name is #{person}"

    greetings.bill().shouldBe 'My name is ted'

  it 'should show do -> form inside comprehension', ->
    people = [ 'bill', 'ted' ]
    greetings = {}

    for person in people
      do ->
        name = person
        greetings[name] = ->
          "My name is #{name}"

    greetings.bill().shouldBe 'My name is bill'

    greetings = {}
    people.forEach (name) ->
      greetings[name] = -> "My name is #{name}"
    greetings.bill().shouldBe 'My name is bill'

  it 'should demonstrate using', ->
    using = (object, fn) -> fn.apply object

    turtle =
      position: [0,0]
      heading: 0
      forward: (distance) ->
        switch @heading
          when 0 then @position[1] += distance
          when 90 then @position[0] += distance
          when 180 then @position[0] -= distance
          when 270 then @position[1] -= distance
      rotate: (degrees) ->
        if @heading is 270 then @heading = 0
        else @heading += 90

    using turtle, ->
      @forward 2
      @rotate 90
      @forward 4

    turtle.position.should_be [4,2]


  it 'should demonstrate chain', ->
    turtle =
      position: [0,0]
      heading: 0
      forward: (distance) ->
        switch @heading
          when 0 then @position[1] += distance
          when 90 then @position[0] += distance
          when 180 then @position[0] -= distance
          when 270 then @position[1] -= distance
      rotate: (degrees) ->
        if @heading is 270 then @heading = 0
        else @heading += 90

    chain = (receiver) ->
      wrapper = Object.create receiver
      for key, value of wrapper
        if value?.call
          do ->
            proxied = value
            wrapper[key] = (args...) ->
              proxied.call receiver, args...
              wrapper

      wrapper


    chain(turtle)
    .forward(2)
    .rotate(90)
    .forward(4)

    turtle.position.shouldBe [4,2]

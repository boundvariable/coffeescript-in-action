
{it, stub, describe} = require 'chromic'

describe 'Chapter 7', ->

  color = (it, color) -> "#{it} #{color}"
  find = (it) ->  it

  it 'should demonstrate the highlight function', ->
    highlight = (name) ->
      color find(name), 'yellow'

    highlight('x').should_be 'x yellow'

  it 'should demonstrate highlight function with array as arg', ->
    highlight = (names) ->
      for name in names
        color find(name), 'yellow'

    highlight(['x', 'y']).should_be ['x yellow', 'y yellow']

  it 'should demonstrate highlight with rest', ->
    highlight = (names...) ->
      (for name in names
        color find(name), 'yellow')

    highlight('x', 'y').should_be ['x yellow', 'y yellow']

  it 'should show that arguments does not have slice', ->
    names = []
    highlight = (names) ->
      (arguments.slice == undefined).should_be true

    highlight 'x', 'y'

  it 'should demonstrate need for spread', ->
  insert = (teams...) ->
    teams

  initialize = (teams...) ->
    insert teams

  res = initialize('wolverines', 'sabertooths', 'mongooses')
  res.should_be [ [ 'wolverines','sabertooths', 'mongooses' ] ]

  initialize = (teams...) ->
    insert teams...

  res = initialize 'wolverines', 'sabertooths', 'mongooses'
  res.should_be [ 'wolverines','sabertooths', 'mongooses' ]

  it 'should demonstrate the toggler', ->
    make_toggler = (active, inactive) ->
      ->
        temporary = active
        active = inactive
        inactive = temporary
        [active, inactive]

    toggler = make_toggler 'komodos', 'raptors'

    toggler().should_be ['raptors', 'komodos']
    toggler().should_be ['komodos', 'raptors']

  it 'should demonstrate destructuring array', ->
    active = 'komodos'
    inactive = 'raptors'

    [active, inactive] = [inactive, active]

    active.should_be 'raptors'
    inactive.should_be 'komodos'

  it 'should demonstrate destructuring toggler', ->
    make_toggler = (a, b) ->
      -> [a,b] = [b,a]

    toggler = make_toggler 'on', 'off'

    toggler().should_be ['off', 'on']
    toggler().should_be ['on', 'off']

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

    relegate(last).should_be 'bobcats got relegated'

  it 'should demonstrate a module pattern', ->
    competition = do ->
      find = ->
      color = ->
      highlight = -> 'highlight'
      initialize = ->

      highlight: highlight,
      initialize: initialize

    competition.highlight().should_be 'highlight'

  it 'should show object for named parameters', ->
    make_competition = ({max_competitors, sort_order}) ->
      max_competitors
      sort_order

    make_competition(competitors: 3, sort_order: 'ascending')

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

    render(user: null).should_be """
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

    (daffy instanceof Duck).should_be true

    duck = new Duck
    ultra_duck_marathon = new DuckRace [duck]

    turn_duck_into_something_else = ->
      duck.walk = null

    turn_duck_into_something_else duck

    #ultra_duck_marathon.go()
    # TypeError: Property walk of object #<AsianDuck> is not a function


  it 'should show that instanceof is fragile', ->
    class A
    a = new A
    A:: = class Y

    (a instanceof A).should_be false

  it 'should show map', ->
    paid = [10, 50, 200]

    taxes = (price*0.1 for price in paid)
    taxes.should_be [1, 5, 20]

    taxes = paid.map (item) -> item*0.1
    taxes.should_be [1, 5, 20]

  it 'should show filter', ->
    friends = [
      { name: 'bob', location: 'CoffeeVille' }
      { name: 'tom', location: 'JavaLand' }
      { name: 'tom', location: 'PythonTown' }
      { name: 'tom', location: 'RubyCity' }
    ]

    filter = friends.filter (friend) -> friend.location is 'CoffeeVille'
    comprehension = (friend for friend in friends when friend.location is 'CoffeeVille')

    filter.should_be comprehension

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

    owed.should_be friends.reduce owing


  it 'should show creating function in comprehension', ->
    people = [ 'bill', 'ted' ]
    greetings = {}

    for person in people
      greetings[person] = ->
        "My name is #{person}"

    greetings.bill().should_be 'My name is ted'

  it 'should show do -> form inside comprehension', ->
    people = [ 'bill', 'ted' ]
    greetings = {}

    for person in people
      do ->
        name = person
        greetings[name] = ->
          "My name is #{name}"

    greetings.bill().should_be 'My name is bill'

    greetings = {}
    people.forEach (name) ->
      greetings[name] = -> "My name is #{name}"
    greetings.bill().should_be 'My name is bill'

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

    turtle.position.should_be [4,2]

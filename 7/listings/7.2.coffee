
makeCompetition = ({max, sort}) ->       #A
  find = (name) ->
    document.querySelector ".#{name}"

  color = (element, color) ->
    element.style.background = color

  insert = (teams...) ->
    root = document.querySelector '.teams'
    for team in teams
      element = document.createElement 'li'
      element.innerHTML = "#{team.name} (#{team.points})"
      element.className = team.name
      root.appendChild element

  highlight = (first, rest...) ->
    color find(first.name), 'gold'
    for team in rest
      color find(team.name), 'blue'

  rank = (unranked) ->                        #B
    unranked.sort(sort).slice(0, max)         #B


  initialize: (unranked) ->
    ranked = rank unranked
    insert ranked...
    first = ranked.slice(0, 1)[0]
    rest = ranked.slice 1
    highlight first, rest...

  { initialize }


sortOnPoints = (a, b) ->     #D
  a.points > b.points        #D

window.onload = ->
  competition = makeCompetition max: 5, sort: sortOnPoints     #E
  competition.initialize [
    { name: 'wolverines', points: 22 }
    { name: 'wildcats', points: 11 }
    { name: 'mongooses', points: 33 }
    { name: 'raccoons', points: 12 }
    { name: 'badgers', points: 19 }
    { name: 'baboons', points: 16 }
  ]

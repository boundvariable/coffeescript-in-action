
makeCompetition = ({max, sort}) ->

  POINTS_FOR_WIN = 3
  POINTS_FOR_DRAW = 1
  GOALS_FOR_FORFEIT = 3

  render = (team) ->
    """
    <tr class='#{team?.name||''}'>
    <td>#{team?.name||''}</td>
    <td>#{team?.points||''}</td>
    <td>#{team?.goals?.scored||''}</td>
    <td>#{team?.goals?.conceded||''}</td>
    </tr>
    """

  find = (name) ->
    console.log name
    document.querySelector ".#{name}"

  backgroundColor = (element, color) ->
    element.style.background = color

  textColor = (element, color) ->
    element.style.color = color

  insert = (teams...) ->
    root = document.querySelector '.teams'
    for team in teams
      root.innerHTML += render team

  highlight = (first, rest...) ->
    backgroundColor find(first.name), 'gold'
    textColor find(first.name), 'black'
    for team in rest
      backgroundColor find(team.name), 'blue'
      textColor find(team.name), 'white'

  rank = (unranked) ->
    unranked.sort(sort).slice(0, max).reverse()

  competitive = (team) ->
    team?.players is 5 and team?.compete()?

  blankTally = (name) ->
    name: name
    points: 0
    goals:
      scored: 0
      conceded: 0

  roundRobin = (teams) ->
    results = {}
    for teamName, team of teams
      results[teamName] ?= blankTally teamName
      for opponentName, opponent of teams when opponent isnt team
        console.log "#{teamName} #{opponentName}"
        results[opponentName] ?= blankTally opponentName
        if competitive(team) and competitive(opponent)
          home = team.compete()
          away = opponent.compete()
          results[teamName].goals.scored += home
          results[teamName].goals.conceded += away
          results[opponentName].goals.scored += away
          results[opponentName].goals.conceded += home
          if home > away
            results[teamName].points += POINTS_FOR_WIN
          else if home < away
            results[opponentName].points += POINTS_FOR_WIN
          else
            results[teamName].points += POINTS_FOR_DRAW
            results[opponentName].points += POINTS_FOR_DRAW
        else if competitive team
            results[teamName].points += POINTS_FOR_WIN
            results[teamName].goals.scored += GOALS_FOR_FORFEIT
            results[opponentName].goals.conceded -= GOALS_FOR_FORFEIT
        else if competitive opponent
          results[opponentName].points += POINTS_FOR_WIN
          results[opponentName].goals.conceded += GOALS_FOR_FORFEIT
          results[teamName].goals.scored -= GOALS_FOR_FORFEIT
    results

  run = (teams) ->
    scored = (results for team, results of roundRobin(teams))
    ranked = rank scored
    console.log ranked
    insert ranked...
    first = ranked.slice(0, 1)[0]
    rest = ranked.slice 1
    highlight first, rest...

  { run }

sortOnPoints = (a, b) ->
  a.points > b.points

class Team
  constructor: (@name) ->

  players: 5
  compete: ->
    Math.floor Math.random()*3


window.onload = ->
  competition = makeCompetition max:5, sort: sortOnPoints

  injured = new Team "Injured"
  injured.players = 3

  bizarros = ->
  bizarros.players = 5
  bizarros.compete = -> 9

  competition.run
    wolverines: new Team "Wolverines"
    penguins:
      players: 5
      compete: -> Math.floor Math.random()*3
    injured: injured
    sparrows: new Team "Sparrows"
    bizarros: bizarros

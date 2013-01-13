
make_competition = ({max, sort}) ->

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

  color = (element, color) ->
    element.style.background = color

  insert = (teams...) ->
    root = document.querySelector '.teams'
    for team in teams
      root.innerHTML += render team

  highlight = (first, rest...) ->
    color find(first.name), 'gold'
    for team in rest
      color find(team.name), 'blue'

  rank = (unranked) ->
    unranked.sort(sort).slice(0, max).reverse()

  competitive = (team) ->
    team?.players is 5 and team?.compete()?

  blank_tally = (name) ->
    name: name
    points: 0
    goals:
      scored: 0
      conceded: 0

  round_robin = (teams) ->
    results = {}
    for team_name, team of teams
      results[team_name] ?= blank_tally team_name
      for opponent_name, opponent of teams when opponent isnt team
        console.log "#{team_name} #{opponent_name}"
        results[opponent_name] ?= blank_tally opponent_name
        if competitive(team) and competitive(opponent)
          home = team.compete()
          away = opponent.compete()
          results[team_name].goals.scored += home
          results[team_name].goals.conceded += away
          results[opponent_name].goals.scored += away
          results[opponent_name].goals.conceded += home
          if home > away
            results[team_name].points += POINTS_FOR_WIN
          else if home < away
            results[opponent_name].points += POINTS_FOR_WIN
          else
            results[team_name].points += POINTS_FOR_DRAW
            results[opponent_name].points += POINTS_FOR_DRAW
        else if competitive team
            results[team_name].points += POINTS_FOR_WIN
            results[team_name].goals.scored += GOALS_FOR_FORFEIT
            results[opponent_name].goals.conceded -= GOALS_FOR_FORFEIT
        else if competitive opponent
          results[opponent_name].points += POINTS_FOR_WIN
          results[opponent_name].goals.conceded += GOALS_FOR_FORFEIT
          results[team_name].goals.scored -= GOALS_FOR_FORFEIT
    results

  run = (teams) ->
    scored = (results for team, results of round_robin(teams))
    ranked = rank scored
    console.log ranked
    insert ranked...
    first = ranked.slice(0, 1)[0]
    rest = ranked.slice 1
    highlight first, rest...

  { run }

sort_on_points = (a, b) ->
  a.points > b.points

class Team
  constructor: (@name) ->

  players: 5
  compete: ->
    Math.floor Math.random()*3


window.onload = ->
  competition = make_competition(max:5, sort: sort_on_points)

  injured = new Team "Injured"
  injured.players = 3

  bizarros = ->
  bizarros.players = 5
  bizarros.compete = -> 9

  competition.run {
    wolverines : new Team "Wolverines"
    penguins: { players: 5, compete: -> Math.floor Math.random()*3 }
    injured: injured
    sparrows: new Team "Sparrows"
    bizarros: bizarros
  }

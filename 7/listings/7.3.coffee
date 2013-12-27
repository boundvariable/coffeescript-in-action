
makeCompetition = ({max, sort}) ->
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


  initialize: (unranked) ->
    ranked = rank unranked
    insert ranked...
    first = ranked.slice(0, 1)[0]
    rest = ranked.slice 1
    highlight first, rest...

sortOnPoints = (a, b) ->
  a.points > b.points

window.onload = ->
  competition = makeCompetition(max:5, sort: sortOnPoints)
  competition.initialize [
      name: 'wolverines'
      points: 56
      goals:
        scored: 26
        conceded: 8
    ,
      name: 'wildcats'
      points: 53
      goals:
        scored: 32
        conceded: 19
    ,
      name: 'mongooses'
      points: 34
      goals:
        scored: 9
        conceded: 9
    ,
      name: 'racoons'               # disqualified
      points: 0
  ]

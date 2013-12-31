W B Yeats
The Wild Swans at Coole

The trees are in their autumn beauty,

    trees = [{}, {}]
    for tree in trees
      tree.inAutumnBeauty = yes

The woodland paths are dry,

    paths = [{}, {}, {}]
    for path in paths
      path.dry = yes

Under the October twilight the water
Mirrors a still sky;

    octoberTwilight = {}
    stillSky = {}
    water =
      placeUnder: ->

    water.placeUnder octoberTwilight
    water.mirrors = stillSky

Upon the brimming water among the stones
Are nine-and-fifty swans.

    water.brimming = true
    water.stones = [{}, {}, {}, {}]

    class Swan
      x: 3

    for n in [1..59]
      water.stones.push new Swan

# Use accumulate to create a sumFractions function that will sum fractions
# supplied as strings and return a fraction as a string.

accumulate = (initial, items, accumulator) ->
  total = initial
  for item in items
    total = accumulator total, item
  total

sumFractions = (fractions) ->
  accumulator = (lhs, rhs) ->
    if lhs is '0/0'
      rhs
    else if rhs is '0/0'
      lhs
    else
      lhsSplit = lhs.split /\//gi
      rhsSplit = rhs.split /\//gi
      lhsNumer = 1*lhsSplit[0]
      lhsDenom = 1*lhsSplit[1]
      rhsNumer = 1*rhsSplit[0]
      rhsDenom = 1*rhsSplit[1]
      if lhsDenom isnt rhsDenom
        commonDenom = lhsDenom*rhsDenom
      else
        commonDenom = lhsDenom

      sumNumer = lhsNumer*(commonDenom/lhsDenom) + rhsNumer*(commonDenom/rhsDenom)
      "#{sumNumer}/#{commonDenom}"

  accumulate '0/0', fractions, accumulator


console.log sumFractions ['2/6', '1/4']
# '14/24'

sumFractions ['4/2', '5/2', '1/3']
# 29/6


keep = (arr, cond) ->
  item for item in arr when cond item

greaterThan3 = (n) -> n > 3
keep [1,2,3,4], greaterThan3

console.log keep [1,2,3,4], greaterThan3

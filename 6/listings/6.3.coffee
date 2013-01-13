numberSold = 0                                          #A

calculateNumberSold = (salePrice) ->
  numberSold = 50 + 20/10 * (200 - salePrice)

calculateRevenue = (callback) ->
  callback numberSold * salePrice

revenueBetween = (start, finish) ->
  totals = []                                           #B
  for price in [start..finish]
    calculateNumberSold price
    addToTotals = (result) ->
      totals.push result
    calculateRevenue salePrice, addToTotals
  totals

revenueBetween 140, 145
# [1400,1410,1420,1430,1440,1450]
#A shared state
#B local state

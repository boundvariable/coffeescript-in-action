profit = (salePrice) ->
  overhead = 140                         #A
  costPrice = 100                        #A
  numberSold = (salePrice) ->            #A
    50 + 20/10 * (200 - salePrice)       #A
  revenue = (salePrice) ->
    (numberSold salePrice) * salePrice
  cost = (salePrice) ->
    overhead + (numberSold salePrice) * costPrice

  (revenue salePrice) - (cost salePrice)


assert = require 'assert'
assert.ok (profit 200) == 4860

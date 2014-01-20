###
Suppose you just obtained two items, a torch and an umbrella.
One of the items you purchased, and the other was a gift,
but you’re not sure which is which. Both of these are objects:
   torch = {}
   umbrella = {}
Either the torch or the umbrella has a price property, but the other does not.
Write an expression for the combined cost of the torch and umbrella. Hint: use the default operator.
###

torch = price: 21 # torch has a price
umbrella = {}     # umbrella does not

combinedCost = (torch.price || 0) + (umbrella.price || 0)
# 21

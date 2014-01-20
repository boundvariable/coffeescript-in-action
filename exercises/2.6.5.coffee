###
Suppose you have a string containing animal names.
animals = 'baboons badgers antelopes cobras crocodiles'
Write a program to output the following:
   ['A rumpus of baboons',
    'A cete of badgers',
    'A herd of antelopes',
    'A quiver of cobras',
    'A bask of crocodiles']
###

animals = 'baboons badgers antelopes cobras crocodiles'
result = for animal in animals.split " "
  collective = switch animal
    when "antelopes" then "herd"
    when "baboons" then "rumpus"
    when "badgers" then "cete"
    when "cobras" then "quiver"
    when "crocodiles" then "bask"
  "A #{collective} of #{animal}"
#   ['A rumpus of baboons',
#    'A cete of badgers',
#    'A herd of antelopes',
#    'A quiver of cobras',
#    'A bask of crocodiles']

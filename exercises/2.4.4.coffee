###
Suppose you have a variable animal that contains a string with the
singular name for one of the animals: antelope, baboon, badger, cobra,
or crocodile.

Write some code to get the collective name for the animal. The collective
names for the possible animals in the same order areherd, rumpus,
cete, quiver, and bask.
###

animal = 'crocodile'                          # The variable animal
collective = switch animal                    # Switch expression to get the collective
  when "antelope" then "herd"
  when "baboon" then "rumpus"
  when "badger" then "cete"
  when "cobra" then "quiver"
  when "crocodile" then "bask"
# bask

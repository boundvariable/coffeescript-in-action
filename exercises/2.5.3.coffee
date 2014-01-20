###
Get the collective animal name to be output in a string like the following.
"The collective of cobra is quiver"
###
animal = "cobra"
collective = switch animal
  when "antelope" then "herd"
  when "baboon" then "rumpus"
  when "badger" then "cete"
  when "cobra" then "quiver"
  when "crocodile" then "bask"

"The collective of #{animal} is #{collective}"
# The collectibe of cobra is quiver

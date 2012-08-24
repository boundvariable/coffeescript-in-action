noRemainder = (number, divisor) ->     #1
  not (number%divisor)                  #1

divisibleBy = (range, divisor) ->                         #2
  if not range then []
  else
    num for num in range when noRemainder(num, divisor)     #2

arg = process.argv[2]

if arg then console.log divisibleBy [1..100], arg      #3


exports.divisibleBy = divisibleBy

Challenge.destroy_all

TheAnswer = Challenge.new(
  name: 'TheAnswer',
  description: 'type 42',
  language: 'Ruby',
  tests: 'blank'
)

NotEvenOdd = Challenge.new(
  name: 'Not even odd',
  description: 'Write a function taking a number as an argument. The function should return "even steven" if the number is even and "that was odd..." if the number is odd',
  language: 'Ruby',
  tests: 'blank'
)

ArrayArrayArray = Challenge.new(
  name: 'Array Array Array',
  description: 'You are given an initial 2-value array (x). You will use this to calculate a score.
  If both values in (x) are numbers, the score is the sum of the two. If only one is a number, the score is that number.
  If neither is a number, return "Void!".
  Once you have your score, you must return an array of arrays. Each sub array will be the same as (x) and the number
  of sub arrays should be equal to the score.
  For example: if (x) == ["a", 3] you should return [["a", 3], ["a", 3], ["a", 3]].',
  language: 'Ruby',
  tests: 'blank'
)

PrintedErrors = Challenge.new(
  name: 'Printed errors',
  description: 'In a factory a printer prints labels for boxes. For one kind of boxes the printer has to use colors
  which, for the sake of simplicity, are named with letters from a to m.
  The colors used by the printer are recorded in a control string. For example a "good" control string would
  be aaabbbbhaijjjm meaning that the printer used three times color a, four times color b, one time color h then
  one time color a...
  Sometimes there are problems: lack of colors, technical malfunction and a "bad" control string is produced e.g.
  aaaxbbbbyyhwawiwjjjwwm with letters not from a to m.
  You have to write a function printer_error which given a string will return the error rate of the printer as a string
  representing a rational whose numerator is the number of errors and the denominator the length of the control string. Do not reduce this fraction to a simpler expression.
  The string has a length greater or equal to one and contains only letters from ato z.',
  language: 'Ruby',
  tests: 'blank'
)

Arrays = Challenge.new(
  name: 'Arrays',
  description: '
  You are given an array (which will have a length of at least 3, but could be very large) containing integers. The array is either entirely comprised of odd integers or entirely comprised of even integers except for a single integer N. Write a method that takes the array as an argument and returns this "outlier" N.
  Examples
  [2, 4, 0, 100, 4, 11, 2602, 36]
  Should return: 11 (the only odd number)
  [160, 3, 1719, 19, 11, 13, -21]
  Should return: 160 (the only even number)',
  language: 'Ruby',
  tests: 'blank'
)

SortNumbers = Challenge.new(
  name: 'Sort numbers',
  description: 'You are given an array of integers. Your task is to sort odd numbers within the array in ascending order
  , and even numbers in descending order.
  Note that zero is an even number. If you have an empty array, you need to return it.
  For example:
  [5, 3, 2, 8, 1, 4]  -->  [1, 3, 8, 4, 5, 2]
  odd numbers ascending:   [1, 3,       5   ]
  even numbers descending: [      8, 4,    2]',
  language: 'Ruby',
  tests: 'blank'
)

DescendingOrder = Challenge.new(
  name: 'Descending order',
  description: 'Your task is to make a function that can take any non-negative integer as an argument and return
  it with its digits in descending order. Essentially, rearrange the digits to create the highest possible number.
  Examples:
  Input: 42145 Output: 54421
  Input: 145263 Output: 654321
  Input: 123456789 Output: 987654321',
  language: 'Ruby',
  tests: 'blank'
)

puts "Yep, that worked, stop sweating"

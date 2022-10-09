Game.destroy_all
Challenge.destroy_all
User.destroy_all

puts "creating Katas erm... Challenges !"
TheAnswer = Challenge.create(
  name: 'TheAnswer',
  description: 'type 42',
  language: 'Ruby',
  tests: {
    42 => 42
  },
  method_template: 'def type_42\n\nend'
)

NotEvenOdd = Challenge.create(
  name: 'Not even odd',
  description: 'Write a function taking a number as an argument. The function should return "even steven" if the number is even and "that was odd..." if the number is odd',
  language: 'Ruby',
  tests: {
    4 => 'even steven',
    5 => 'that was odd...'
  },
  method_template: 'def not_even_odd(number)\n\nend'
)

ArrayArrayArray = Challenge.create(
  name: 'Array Array Array',
  description: 'You are given an initial 2-value array. You will use this to calculate a score.
  If both values in (array) are numbers, the score is the sum of the two. If only one is a number, the score is that number.
  If neither is a number, return "Void!".
  Once you have your score, you must return an array of arrays. Each sub array will be the same as (x) and the number
  of sub arrays should be equal to the score.
  For example: if (array) == ["a", 3] you should return [["a", 3], ["a", 3], ["a", 3]].',
  language: 'Ruby',
  tests: {
    ['a', 3] => [['a', 3], ['a', 3], ['a', 3]],
    [2, 4] => [[2, 4], [2, 4], [2, 4], [2, 4], [2, 4], [2, 4]]
  },
  method_template: 'def array_array_array(array)\n\nend'
)

PrintedErrors = Challenge.create(
  name: 'Printed errors',
  description: 'In a factory a printer prints labels for boxes. For one kind of boxes the printer has to use colors
  which, for the sake of simplicity, are named with letters from a to m.
  The colors used by the printer are recorded in a control string. For example a "good" control string would
  be aaabbbbhaijjjm meaning that the printer used three times color a, four times color b, one time color h then
  one time color a...
  Sometimes there are problems: lack of colors, technical malfunction and a "bad" control string is produced e.g.
  aaaxbbbbyyhwawiwjjjwwm with letters not from a to m.
  You have to write a function printer_error which given a string will return the error rate of the printer as a string
  representing a rational whose numerator is the number of errors and the denominator the length of the control string. e.g. "1/15" (1 error, 15 control string length) Do not reduce this fraction to a simpler expression.
  The string has a length greater or equal to one and contains only letters from a to z.',
  language: 'Ruby',
  tests: {
    'aaabbbbhaijjjm' => '0/14',
    'aaaxbbbbyyhwawiwjjjwwm' => '8/22'
  },
  method_template: 'def printer_error(string)\n\nend'
)

Arrays = Challenge.create(
  name: 'Arrays',
  description: '
  You are given an array (which will have a length of at least 3, but could be very large) containing integers. The array is either entirely comprised of odd integers or entirely comprised of even integers except for a single integer N. Write a method that takes the array as an argument and returns this "outlier" N.
  Examples
  [2, 4, 0, 100, 4, 11, 2602, 36]
  Should return: 11 (the only odd number)
  [160, 3, 1719, 19, 11, 13, -21]
  Should return: 160 (the only even number)',
  language: 'Ruby',
  tests: {
    [2, 4, 0, 100, 4, 11, 2602, 36] => 11,
    [160, 3, 1719, 19, 11, 13, -21] => 160
  },
  method_template: 'def find_the_outlier(array)\n\nend'
)

SortNumbers = Challenge.create(
  name: 'Sort numbers',
  description: 'You are given an array of integers. Your task is to sort odd numbers within the array in ascending order, and even numbers in descending order.
  Note that zero is an even number. If you have an empty array, you need to return it.
  For example:
  [5, 3, 2, 8, 1, 4]  -->  [1, 3, 5, 8, 4, 2]',
  language: 'Ruby',
  tests: {
    [5, 3, 2, 8, 1, 4] => [1, 3, 5, 8, 4, 2],
    [21, 7, 35, 1, 8, 12, 2, 0] => [1, 7, 21, 35, 12, 8, 2, 0]
  },
  method_template: 'def up_and_down(array)\n\nend'
)

DescendingOrder = Challenge.create(
  name: 'Descending order',
  description: 'Your task is to make a function that can take any non-negative integer as an argument and return
  it with its digits in descending order. Essentially, rearrange the digits to create the highest possible number.
  Examples:
  Input: 42145 Output: 54421
  Input: 145263 Output: 654321
  Input: 123456789 Output: 987654321',
  language: 'Ruby',
  tests: {
    42145 => 54421,
    145263 => 654321,
    123456789 => 987654321
  },
  method_template: 'def descending_order(number)\n\nend'
)

puts "Creating Users"
user0 = User.create!(username: "4ar0n", email: "aaron@mail.com", password: '123456', avatar: "cool-emote.png", score: rand(1..100))
user1 = User.create!(username: "Ch4r1y", email: "charly@mail.com", password: '123456', avatar: "cool-doge.png", score: rand(1..100))
user2 = User.create!(username: "W1ll", email: "william@mail.com", password: '123456', avatar: "cool-cactus", score: rand(1..100))
user3 = User.create!(username: "N1c0l4", email: "nicola@mail.com", password: '123456', avatar: "cool-duck.png", score: rand(1..100))
user4 = User.create!(username: "UltimateRival", email: "DuncanMcLeod@mail.com", admin: true, password: 'Highlander', avatar: "coolest-duck.jpg", score: rand(1..100))


puts  "
        __          __          __          __
      <(o )___    <(o )___    <(o )___    <(o )___
       ( ._> /     ( ._> /     ( ._> /     ( ._> /
        `---'       `---'       `---'       `---'
"
puts " The four ducks of luck grant you safe passage, dont linger, they could change their mind."

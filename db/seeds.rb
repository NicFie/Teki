Challenge.destroy_all

TheAnswer = Challenge.new(
  name: 'TheAnswer',
  description: 'type 42',
  language: 'Ruby',
  test: 'blank'
)

NotEvenOdd = Challenge.new(
  name: 'Not even odd',
  description: 'Write a function taking a number as an argument. The function should return "even steven" if the number is even and "that was odd..." if the number is odd',
  language: 'Ruby',
  test: 'blank'
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
  test: 'blank'
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
  test: 'blank'
)

MatrixMultiplier = Challenge.new(
  name: 'Matrix Multiplier',
  description: 'In mathematics, a matrix (plural matrices) is a rectangular array of numbers. Matrices have many
  applications in programming, from performing transformations in 2D space to machine learning.
  One of the most useful operations to perform on matrices is matrix multiplication, which takes a pair of matrices
  and produces another matrix – known as the dot product. Multiplying matrices is very different to multiplying real
  numbers, and follows its own set of rules.
  Unlike multiplying real numbers, multiplying matrices is non-commutative: in other words, multiplying matrix a by
  matrix b will not give the same result as multiplying matrix b by matrix a.
  Additionally, not all pairs of matrix can be multiplied. For two matrices to be multipliable, the number of columns
  in matrix a must match the number of rows in matrix b.
  There are many introductions to matrix multiplication online, including at Khan Academy, and in the classic MIT
  lecture series by Herbert Gross.
  To complete this kata, write a function that takes two matrices - a and b - and returns the dot product of those
  matrices. If the matrices cannot be multiplied, return -1 for JS/Python, or null for Java.
  Each matrix will be represented by a two-dimensional list (a list of lists). Each inner list will contain one or more
  numbers, representing a row in the matrix.
  For example, the following matrix:

  |1 2|
  |3 4|

  Would be represented as:

  [[1, 2], [3, 4]]

  It can be assumed that all lists will be valid matrices, composed of lists with equal numbers of elements, and which
   contain only numbers. The numbers may include integers and/or decimal points.',
  language: 'Ruby',
  test: 'blank'
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
  test: 'blank'
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
  test: 'blank'
)

puts "Yep, that worked, stop sweating"

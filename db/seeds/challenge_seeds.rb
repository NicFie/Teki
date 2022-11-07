puts "Creating just challenge seeds..."
puts "Creating 10 easy challenges"

# These are some easy challenges

NumbersGreaterThanFive = Challenge.create(
  name: 'Numbers Greater Than Five',
  description: 'Given an array of numbers, count how many items are greater than 5.
  The method should return an integer.

  For example:
    [1, 4, 2, 70, 45, -2] --> 2',
  language: 'Ruby',
  tests: {
    [1, 48, 32, 6, 90, 2, 3] => 4,
    [32, 3, 1, 8, 5, 4] => 2
  },
  method_template: 'def numbers_greater_than_five(array)\n  \nend'
)

PrimeNumberAlgorithm = Challenge.create(
  name: 'Prime Number Algorith',
  description: 'Given an array of numbers, count how many items are prime numbers.
  The method should return an integer.

  For example:
    [15, 53, 117, 487, 1212, 1213] --> 3',
  language: 'Ruby',
  tests: {
    [1303, 41, 86, 997, 100] => 3,
    [120, 2, 1, 60, -1, 80] => 1
  },
  method_template: 'def prime_number_algorithm(array)\n  \nend'
)

SumOfPrimeNumbers = Challenge.create(
  name: 'Sum of Prime Numbers',
  description: 'Given an array of numbers, calculate the sum of the prime numbers.
  The method should return an integer.

  For example:
    [15, 53, 117, 487, 1212, 1213] --> 1753',
  language: 'Ruby',
  tests: {
    [1303, 41, 86, 997, 100] => 2341,
    [120, 2, 1, 60, -1, 80] => 2
  },
  method_template: 'def sum_of_prime_numbers(array)\n  \nend'
)

FactorialNumbers = Challenge.create(
  name: 'Factorial Numbers',
  description: 'Given an integer, calculate its factorial.
  The method should return an integer.

  The factorial of a number is the product of all the positive integers that are less than or equal to the number in question.

  For example:
    6 --> 720
    (1 x 2 x 3 x 4 x 5 x 6 = 720',
  language: 'Ruby',
  tests: {
    8 => 40320,
    2 => 2,
    4 => 24
  },
  method_template: 'def factorial_numbers(number)\n  \nend'
)

RepeatedDigitChecker = Challenge.create(
  name: 'Repeated Digit Checker',
  description: 'Given an integer, check to see if it has repeated digits in it.
  The method should return a boolean.

  For example:
    554 -> true
    1085 -> false
    888888 -> true',
  language: 'Ruby',
  tests: {
    1103 => true,
    4230 => false,
    666 => true
  },
  method_template: 'def repeated_digit_checker(integer)\n  \nend'
)

FibonacciAlgorithm = Challenge.create(
  name: 'FibonacciAlgorithm',
  description: 'Given an integer (n), give the (n)th number of the fibonacci sequence.
  The method should return an integer.

  The sequence will start at 0, and the first few numbers are 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144.

  For example:
    1 --> 0
    5 --> 3
    20 --> 4181',
  language: 'Ruby',
  tests: {
    10 => 34,
    2 => 1
    14 => 233
  },
  method_template: 'def fibonacci_algorithm(integer)\n  \nend'
)

MissingNumberGame = Challenge.create(
  name: 'Missing Number Game',
  description: 'Given an array of numbers 1 - 10 that is missing one number, find the missing number.
  The method should return an integer.

  For example:
    [2, 1, 5, 4, 6, 9, 7, 8, 10] --> 3',
  language: 'Ruby',
  tests: {
    [2, 1, 3, 4, 6, 7, 9, 8, 10] => 5,
    [1, 9, 4, 10, 2, 3, 8, 5, 7] => 6,
    [9, 3, 2, 4, 7, 10, 5, 6, 1] => 8
  },
  method_template: 'def missing_number_game(array)\n  \nend'
)

FourPassengersAndDriver = Challenge.create(
  name: 'Four Passengers And Driver',
  description: 'Given a number of people, calculate how many cars are needed to seat everyone comfortably.
  A typical car can hold four passengers and one driver, allowing five people to travel around.
  The method should return an integer.

  For example:
    5 --> 1
    11 --> 3',
  language: 'Ruby',
  tests: {
    0 => 0,
    21 => 5,
    30 => 6
  },
  method_template: 'def four_passengers_and_driver(integer)\n  \nend'
)

MultiplyNumbersInAString = Challenge.create(
  name: 'Multiply Numbers in a String',
  description: 'Given a string which contains some numbers, return the product of all the numbers.
  The method should return an integer.

  For example:
    "1 l1v3 l1f3 2 th3 full!" --> 54
    "I need to buy 4 oranges and 3 tomatoes" --> 12',
  language: 'Ruby',
  tests: {
    "123456helloeveryone!" => 720,
    "h3k h3p .;/#';" => 9,
    "1" => 1
  },
  method_template: 'def multiply_numbers_in_a_string(string)\n  \nend'
)

LastLetterSort = Challenge.create(
  name: 'Last Letter Sort',
  description: 'Given a string of words, sort it alphabetically by the last character of each word.
  If two words have the same last character, sort by the order they originally appeared.
  The method should return an string of words.

  For example:
    "herb camera dynamic" --> "camera herb dynamic"
    "brick moral institution loud talk resign worth" --> "loud worth brick talk moral institution resign"',
  language: 'Ruby',
  tests: {
    "stab traction artist approach" => "stab approach traction artist",
    "sample partner autonomy swallow trend" => "trend sample partner swallow autonomy",
    "introduce fashionable cause sacrifice reality" => "introduce fashionable cause sacrifice reality"
  },
  method_template: 'def multiply_numbers_in_a_string(string)\n  \nend'
)
puts "Finished creating 10 easy challenges"

puts "Creating 10 medium challenges"

# These are some medium challenges

TypeOfTriangle = Challenge.create(
  name: 'Type of Triangle',
  description: 'Given an array of the side lengths of a triangle, determine its type.

  No sides equal: "scalene"
  Two sides equal: "isosceles"
  All sides equal: "equilateral"
  Less or more than 3 sides given: "not a triangle"

  The method should return a string.

  For example:
  [2, 6, 5] --> "scalene"
  [4, 4, 7] --> "isosceles"
  [3, 5, 5, 2] --> "not a triangle"',
  language: 'Ruby',
  tests: {
    [2, 3, 4] => "scalene",
    [4, 4, 7] => "isosceles",
    [8, 8, 8] => "equilateral",
    [10] => "not a triangle"
  },
  method_template: 'def type_of_triangle(integer)\n  \nend'
)

ReverseOddLengthWords = Challenge.create(
  name: 'Reverse Odd Length Words',
  description: 'Given a string, reverse all the words which have odd length. The even length words are not changed.

  For example:
  "Bananas" --> "sananaB"
  "One two three four" --> "enO owt eerht four"
  "Make sure uoy only esrever sdrow of ddo length" --> "Make sure you only reverse words of odd length"',
  language: 'Ruby',
  tests: {
    "Even even even even even even even even even" => "Even even even even even even even even even",
    "Odd Odd odd" => "ddO ddO ddo",
    "Make sure you only reverse words of odd length" => "Make sure uoy only esrever sdrow of ddo length",
  },
  method_template: 'def reverse_odd_length_words(integer)\n  \nend'
)

PositionInAlphabet = Challenge.create(
  name: 'Position in Alphabet',
  description: 'Given a number between 1-26, return what letter is at that position in the alphabet. Return "invalid" if the number given is not within that range, or isn\'t an integer.

  For example:
  1 --> "a"
  26.0 --> "z"
  0 --> "invalid"',
  language: 'Ruby',
  tests: {
    4 => "d",
    9 => "i",
    -1 => "invalid",
    4.5 => "invalid",
    21.0 => "u"
  },
  method_template: 'def position_in_alphabet(integer)\n  \nend'
)

FindBob = Challenge.create(
  name: 'Find Bob',
  description: 'Given an array of names, find Bob.
  Return his location in the array, or -1 if Bob is not there. This method returns an integer

  For example:
  ["Will", "Nicola", "Bob"] --> 2
  ["Bob", "Nicola", "Aaron", "Dareos"] --> 0
  ["Will", "Nicola", "Aaron"] --> -1',
  language: 'Ruby',
  tests: {
    ["Jimmy", "Layla", "Mandy"] => -1,
    ["Bob", "Nathan", "Hayden"] => 0,
    ["Paul", "Layla", "Bob"] => 2,
    ["Garry", "Maria", "Bethany", "Bob", "Pauline"] => 3
  },
  method_template: 'def find_bob(array)\n  \nend'
)

LetterIncrement = Challenge.create(
  name: 'Letter increment',
  description: 'Given a one word string, write a method that changes every letter to the next letter. Ignore any punctuation.
  This method returns a string.

  For example:
  "a" --> "b"
  "bye!" --> "czf!"
  "Welcome" --> "Xfmdpnf"',
  language: 'Ruby',
  tests: {
    "Hello" => "Ifmmp",
    "lol!?" => "mpm!?",
    "bye" => "czf"
  },
  method_template: 'def letter_increment(string)\n  \nend'
)

Decimator = Challenge.create(
  name: 'Decimator',
  description: 'Write a DECIMATOR function which takes a string and decimates it (i.e. it removes the last 1/10 of the characters).
  Always round up: if the string has 21 characters, 1/10 of the characters would be 2.1 characters, hence the DECIMATOR removes 3 characters. The DECIMATOR shows no mercy!

  For example:
  "1234567890" --> "123456789"
  # 10 characters, removed 1.

  "123" --> "12"
  # 3 characters, removed 1

  "ABCDEFGHIJKLMNOPQRSTUVWXYZ" --> "ABCDEFGHIJKLMNOPQRSTUVW"
  # 26 characters, removed 3.',
  language: 'Ruby',
  tests: {
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" => "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrst",
    "A" => "",
    "1234567890AB" => "1234567890",
    "" => ""
  },
  method_template: 'def decimator(string)\n  \nend'
)

BinaryZeros = Challenge.create(
  name: 'Binary Zeroes',
  description: 'Given a binary string, write a function that returns the longest sequence of consecutive zeroes in a binary string.
  If no zeroes exist in the input, return an empty string.
  This method returns a string.

  For example:
  "01100001011000" --> "0000"
  "100100100" --> "00"
  "11111" --> ""',
  language: 'Ruby',
  tests: {
    "1000000000011101" => "0000000000",
    "100001110000100000" => "00000",
    "101010101" => "0",
    "111111" => ""
  },
  method_template: 'def binary_zeroes(string)\n  \nend'
)

SquaresAndCubes = Challenge.create(
  name: 'Squares and Cubes',
  description: 'Given an array of two numbers, check if the square root of the first number is equal to the cube root of the second number.
  This method returns a boolean.

  For example:
  [4, 8] --> true
  [16, 48] --> false
  [9, 27] --> true',
  language: 'Ruby',
  tests: {
    [5, 12] => false,
    [25, 125] => true,
    [1, 1] => true,
    [36, 217] => false,
    [9, 27] => true
  },
  method_template: 'def binary_zeroes(array)\n  \nend'
)

FindOddInteger = Challenge.create(
  name: 'Find Odd Integer',
  description: 'Create a function that takes an array and finds the integer which appears an odd number of times.
  This method returns an integer.

  For example:
  [1, 1, 2, -2, 5, 2, 4, 4, -1, -2, 5] --> -1
  [20, 1, 1, 2, 2, 3, 3, 5, 5, 4, 20, 4, 5] --> 5
  [10] --> 10',
  language: 'Ruby',
  tests: {
    [20, 1, -1, 2, -2, 3, 3, 5, 5, 1, 2, 4, 20, 4, -1, -2, 5] => 5,
    [1, 1, 1, 1, 1, 1, 10, 1, 1, 1, 1] => 10,
    [20, 1, 1, 2, 2, 3, 3, 5, 5, 4, 20, 4, 5] => 5,
    [10] => 10
  },
  method_template: 'def find_odd_integer(array)\n  \nend'
)

NoYelling = Challenge.create(
  name: 'No Yelling',
  description: 'Create a function that transforms sentences ending with multiple question marks ? or exclamation marks ! into a sentence only ending with one without changing punctuation in the middle of the sentences.
  This method returns a string.

  For example:
  "What went wrong?????????" --> "What went wrong?"
  "Oh my goodness!!!" --> "Oh my goodness!"
  "I just can\'t believe!!!!!!! it." --> "I just can\'t believe!!!!!!! it."',
  language: 'Ruby',
  tests: {
    "What went wrong?????????" => "What went wrong?",
    "Oh my goodness!!!" => "Oh my goodness!",
    "WHAT!" => "WHAT!",
    "That's a ton!! of cheese!!!!!!!!" => "That's a ton!! of cheese!"
  },
  method_template: 'def no_yelling(array)\n  \nend'
)

puts "Finished creating 10 medium level challenges"
puts "Done!"

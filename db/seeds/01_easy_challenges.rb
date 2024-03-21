puts 'creating Katas erm... Challenges !'

puts "Creating #{Rainbow('40').cyan.bright} #{Rainbow('easy').green.bright} challenges"

create_challenge(
  name: 'Not even odd',
  difficulty: 1,
  description: 'Write a method taking a number as an argument.
  The method should return "even steven" if the number is even and "that was odd..." if the number is odd.',
  language: 'Ruby',
  tests: {
    4 => 'even steven',
    5 => 'that was odd...',
  },
  method_template: 'def not_even_odd(number)\n  \nend',
)

create_challenge(
  name: 'Array Array Array',
  difficulty: 1,
  description: 'You are given an initial 2-value array. You will use this to calculate a score.
  If both values in the array are numbers, the score is the sum of the two.
  If only one is a number, the score is that number.
  If neither is a number, return "Void!".
  Once you have your score, you must return an array of arrays.
  Each sub array will be the same as the original array and the number of sub arrays should be equal to the score.

  For example:
    if (array) == ["a", 3] you should return [["a", 3], ["a", 3], ["a", 3]].',
  language: 'Ruby',
  tests: {
    ['a', 3] => [['a', 3], ['a', 3], ['a', 3]],
    [2, 4] => [[2, 4], [2, 4], [2, 4], [2, 4], [2, 4], [2, 4]],
  },
  method_template: 'def array_array_array(array)\n  \nend',
)

create_challenge(
  name: 'Printed errors',
  difficulty: 1,
  description: 'In a factory a printer prints labels for boxes. For one kind of boxes the printer has to use colors which, are named with letters from a to m.
  The colors used by the printer are recorded in a control string.
  For example a "good" control string would be aaabbbbhaijjjm meaning that the printer used color a three times, color b four times, color h once, then once again color a...

  Sometimes there are problems: lack of colors, technical malfunctions, and a "bad" control string is produced.

  For example:
    aaaxbbbbyyhwawiwjjjwwm which includes letters outside of a-m.

  You have to write a method which given a string will return the error rate of the printer as a string with a numerator showing the number of errors, and a denominator showing the length of the control string.

  For example:
    "1/15" (1 error, 15 control string length) Do not reduce this fraction to a simpler expression.',
  language: 'Ruby',
  tests: {
    'aaabbbbhaijjjm' => '0/14',
    'aaaxbbbbyyhwawiwjjjwwm' => '8/22',
  },
  method_template: 'def printer_error(string)\n  \nend',
)

create_challenge(
  name: 'Arrays',
  difficulty: 1,
  description: 'You are given an array (which will have a length of at least 3, but could be very large) containing integers.
  The array is either entirely comprised of odd integers or entirely comprised of even integers except for a single integer N.
  Write a method that takes the array as an argument and returns this "outlier" N.

  Examples:
    [2, 4, 0, 100, 4, 11, 2602, 36]
    Should return: 11 (the only odd number)

    [160, 3, 1719, 19, 11, 13, -21]
    Should return: 160 (the only even number)',
  language: 'Ruby',
  tests: {
    [2, 4, 0, 100, 4, 11, 2602, 36] => 11,
    [160, 3, 1719, 19, 11, 13, -21] => 160,
  },
  method_template: 'def find_the_outlier(array)\n  \nend',
)

create_challenge(
  name: 'Sort numbers',
  difficulty: 1,
  description: 'You are given an array of integers.
  Your task is to sort odd numbers within the array in ascending order, and even numbers in descending order.
  Note that zero is an even number. If you have an empty array, you need to return it.

  For example:
  [5, 3, 2, 8, 1, 4]  -->  [1, 3, 5, 8, 4, 2]',
  language: 'Ruby',
  tests: {
    [5, 3, 2, 8, 1, 4] => [1, 3, 5, 8, 4, 2],
    [21, 7, 35, 1, 8, 12, 2, 0] => [1, 7, 21, 35, 12, 8, 2, 0],
  },
  method_template: 'def up_and_down(array)\n  \nend',
)

create_challenge(
  name: 'Descending order',
  difficulty: 1,
  description: 'Your task is to make a method that can take any non-negative integer as an argument and return it with its digits in descending order.

  Examples:
    Input: 42145 Output: 54421
    Input: 145263 Output: 654321
    Input: 123456789 Output: 987654321',
  language: 'Ruby',
  tests: {
    42145 => 54421,
    145263 => 654321,
    123456789 => 987654321,
  },
  method_template: 'def descending_order(number)\n  \nend',
)

create_challenge(
  name: 'Numbers Greater Than Five',
  difficulty: 1,
  description: 'Given an array of numbers, count how many items are greater than 5.
  The method should return an integer.

  For example:
    [1, 4, 2, 70, 45, -2] --> 2',
  language: 'Ruby',
  tests: {
    [1, 48, 32, 6, 90, 2, 3] => 4,
    [32, 3, 1, 8, 5, 4] => 2,
  },
  method_template: 'def numbers_greater_than_five(array)\n  \nend',
)

create_challenge(
  name: 'Prime Number Algorith',
  difficulty: 1,
  description: 'Given an array of numbers, count how many items are prime numbers.
  The method should return an integer.

  For example:
    [15, 53, 117, 487, 1212, 1213] --> 3',
  language: 'Ruby',
  tests: {
    [1303, 41, 86, 997, 100] => 3,
    [120, 2, 1, 60, -1, 80] => 1,
  },
  method_template: 'def prime_number_algorithm(array)\n  \nend',
)

create_challenge(
  name: 'Sum of Prime Numbers',
  difficulty: 1,
  description: 'Given an array of numbers, calculate the sum of the prime numbers.
  The method should return an integer.

  For example:
    [15, 53, 117, 487, 1212, 1213] --> 1753',
  language: 'Ruby',
  tests: {
    [1303, 41, 86, 997, 100] => 2341,
    [120, 2, 1, 60, -1, 80] => 2,
  },
  method_template: 'def sum_of_prime_numbers(array)\n  \nend',
)

create_challenge(
  name: 'Factorial Numbers',
  difficulty: 1,
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
    4 => 24,
  },
  method_template: 'def factorial_numbers(number)\n  \nend',
)

create_challenge(
  name: 'Repeated Digit Checker',
  difficulty: 1,
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
    666 => true,
  },
  method_template: 'def repeated_digit_checker(integer)\n  \nend',
)

create_challenge(
  name: 'FibonacciAlgorithm',
  difficulty: 1,
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
    2 => 1,
    14 => 233,
  },
  method_template: 'def fibonacci_algorithm(integer)\n  \nend',
)

create_challenge(
  name: 'Missing Number Game',
  difficulty: 1,
  description: 'Given an array of numbers 1 - 10 that is missing one number, find the missing number.
  The method should return an integer.

  For example:
    [2, 1, 5, 4, 6, 9, 7, 8, 10] --> 3',
  language: 'Ruby',
  tests: {
    [2, 1, 3, 4, 6, 7, 9, 8, 10] => 5,
    [1, 9, 4, 10, 2, 3, 8, 5, 7] => 6,
    [9, 3, 2, 4, 7, 10, 5, 6, 1] => 8,
  },
  method_template: 'def missing_number_game(array)\n  \nend',
)

create_challenge(
  name: 'Four Passengers And Driver',
  difficulty: 1,
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
    30 => 6,
  },
  method_template: 'def four_passengers_and_driver(integer)\n  \nend',
)

create_challenge(
  name: 'Multiply Numbers in a String',
  difficulty: 1,
  description: 'Given a string which contains some numbers, return the product of all the numbers.
  The method should return an integer.

  For example:
    "1 l1v3 l1f3 2 th3 full!" --> 54
    "I need to buy 4 oranges and 3 tomatoes" --> 12',
  language: 'Ruby',
  tests: {
    '123456helloeveryone!' => 720,
    "h3k h3p .;/#';" => 9,
    '1' => 1,
  },
  method_template: 'def multiply_numbers_in_a_string(string)\n  \nend',
)

create_challenge(
  name: 'Last Letter Sort',
  difficulty: 1,
  description: 'Given a string of words, sort it alphabetically by the last character of each word.
  If two words have the same last character, sort by the order they originally appeared.
  The method should return an string of words.

  For example:
    "herb camera dynamic" --> "camera herb dynamic"
    "brick moral institution loud talk resign worth" --> "loud worth brick talk moral institution resign"',
  language: 'Ruby',
  tests: {
    'stab traction artist approach' => 'stab approach traction artist',
    'sample partner autonomy swallow trend' => 'trend sample partner swallow autonomy',
    'introduce fashionable cause sacrifice reality' => 'introduce fashionable cause sacrifice reality',
  },
  method_template: 'def multiply_numbers_in_a_string(string)\n  \nend',
)

# create_challenge(
#   name: 'Add Numbers',
#   difficulty: 1,
#   description: 'Write a method that takes two numbers as arguments and returns their sum.
#
#   For example:
#   Input: [2, 3]
#   Output: 5
#
#   Input: [-10, 20]
#   Output: 10
#
#   Input: [0, 0]
#   Output: 0',
#   language: 'Ruby',
#   tests: {
#     [2, 3] => 5,
#     [-10, 20] => 10,
#     [0, 0] => 0
#   },
#   method_template: 'def add_numbers(a, b)\n  \nend'
# )

create_challenge(
  name: 'Largest Number',
  difficulty: 1,
  description: 'Write a method that takes an array of numbers and returns the largest number in the array.

  For example:
  Input: [3, 6, 1, 9, 4]
  Output: 9

  Input: [10, 20, 5, 15]
  Output: 20

  Input: [-5, -10, -2, -8]
  Output: -2',
  language: 'Ruby',
  tests: {
    [3, 6, 1, 9, 4] => 9,
    [10, 20, 5, 15] => 20,
    [-5, -10, -2, -8] => -2,
  },
  method_template: 'def largest_number(array)\n  \nend',
)

create_challenge(
  name: 'Reverse String',
  difficulty: 1,
  description: 'Write a method that takes a string as an argument and returns the string reversed.

  For example:
  Input: "hello"
  Output: "olleh"

  Input: "racecar"
  Output: "racecar"

  Input: "12345"
  Output: "54321"',
  language: 'Ruby',
  tests: {
    'hello' => 'olleh',
    'racecar' => 'racecar',
    '12345' => '54321',
  },
  method_template: 'def reverse_string(str)\n  \nend',
)

create_challenge(
  name: 'Prime Number',
  difficulty: 1,
  description: 'Write a method that takes a number as an argument and returns true if the number is prime, false otherwise.

  For example:
  Input: 7
  Output: true

  Input: 10
  Output: false

  Input: 23
  Output: true

  Input: 4
  Output: false',
  language: 'Ruby',
  tests: {
    7 => true,
    10 => false,
    23 => true,
    4 => false,
  },
  method_template: 'def prime_number?(number)\n  \nend',
)

create_challenge(
  name: 'Factorial',
  difficulty: 1,
  description: 'Write a method that takes a positive integer as an argument and returns its factorial.

  For example:
  Input: 5
  Output: 120

  Input: 3
  Output: 6

  Input: 0
  Output: 1',
  language: 'Ruby',
  tests: {
    5 => 120,
    3 => 6,
    0 => 1,
  },
  method_template: 'def factorial(n)\n  \nend',
)

create_challenge(
  name: 'Sum of Array',
  difficulty: 1,
  description: 'Write a method that takes an array of numbers as an argument and returns the sum of all elements.

  For example:
  Input: [1, 2, 3, 4, 5]
  Output: 15

  Input: [10, -3, 8, 1]
  Output: 16

  Input: [0, 0, 0]
  Output: 0',
  language: 'Ruby',
  tests: {
    [1, 2, 3, 4, 5] => 15,
    [10, -3, 8, 1] => 16,
    [0, 0, 0] => 0,
  },
  method_template: 'def sum_of_array(array)\n  \nend',
)

create_challenge(
  name: 'Palindrome Check',
  difficulty: 1,
  description: 'Write a method that takes a string as an argument and returns true if it is a palindrome, false otherwise.

  For example:
  Input: "racecar"
  Output: true

  Input: "hello"
  Output: false

  Input: "level"
  Output: true

  Input: "abcde"
  Output: false',
  language: 'Ruby',
  tests: {
    'racecar' => true,
    'hello' => false,
    'level' => true,
    'abcde' => false,
  },
  method_template: 'def palindrome?(str)\n  \nend',
)

create_challenge(
  name: 'Minimum Number',
  difficulty: 1,
  description: 'Write a method that takes an array of numbers and returns the minimum number in the array.

  For example:
  Input: [3, 6, 1, 9, 4]
  Output: 1

  Input: [10, 20, 5, 15]
  Output: 5

  Input: [-5, -10, -2, -8]
  Output: -10',
  language: 'Ruby',
  tests: {
    [3, 6, 1, 9, 4] => 1,
    [10, 20, 5, 15] => 5,
    [-5, -10, -2, -8] => -10,
  },
  method_template: 'def minimum_number(array)\n  \nend',
)

create_challenge(
  name: 'Remove Duplicates',
  difficulty: 1,
  description: 'Write a method that takes an array of numbers and returns a new array with duplicates removed.

  For example:
  Input: [1, 2, 2, 3, 3, 4, 4, 5]
  Output: [1, 2, 3, 4, 5]

  Input: [10, 10, 20, 30, 20]
  Output: [10, 20, 30]

  Input: []
  Output: []',
  language: 'Ruby',
  tests: {
    [1, 2, 2, 3, 3, 4, 4, 5] => [1, 2, 3, 4, 5],
    [10, 10, 20, 30, 20] => [10, 20, 30],
    [] => [],
  },
  method_template: 'def remove_duplicates(array)\n  \nend',
)

create_challenge(
  name: 'Average of Array',
  difficulty: 1,
  description: 'Write a method that takes an array of numbers and returns the average of all elements.

  For example:
  Input: [1, 2, 3, 4, 5]
  Output: 3.0

  Input: [10, -3, 8, 1]
  Output: 4.0

  Input: [0, 0, 0]
  Output: 0.0',
  language: 'Ruby',
  tests: {
    [1, 2, 3, 4, 5] => 3.0,
    [10, -3, 8, 1] => 4.0,
    [0, 0, 0] => 0.0,
  },
  method_template: 'def average_of_array(array)\n  \nend',
)

create_challenge(
  name: 'Middle Element',
  difficulty: 1,
  description: 'Write a method that takes an array of numbers and returns the middle element. If the array has an even number of elements, return the second middle element.

  For example:
  Input: [1, 2, 3, 4, 5]
  Output: 3

  Input: [10, -3, 8, 1]
  Output: -3

  Input: [1, 2, 3, 4]
  Output: 3

  Input: [0, 0, 0, 0]
  Output: 0',
  language: 'Ruby',
  tests: {
    [1, 2, 3, 4, 5] => 3,
    [10, -3, 8, 1] => -3,
    [1, 2, 3, 4] => 3,
    [0, 0, 0, 0] => 0,
  },
  method_template: 'def middle_element(array)\n  \nend',
)

create_challenge(
  name: 'Word Count',
  difficulty: 1,
  description: 'Write a method that takes a string representing a sentence and returns the number of words in the sentence.

  For example:
  Input: "This is a sample sentence."
  Output: 5

  Input: "Hello, how are you?"
  Output: 4

  Input: "One word."
  Output: 2',
  language: 'Ruby',
  tests: {
    'This is a sample sentence.' => 5,
    'Hello, how are you?' => 4,
    'One word.' => 2,
  },
  method_template: 'def word_count(sentence)\n  \nend',
)

create_challenge(
  name: 'Multiply Array',
  difficulty: 1,
  description: 'Write a method that takes an array of numbers as an argument and returns the product of all elements.

  For example:
  Input: [1, 2, 3, 4, 5]
  Output: 120

  Input: [10, -3, 8, 1]
  Output: -240

  Input: [1, 1, 1, 1, 1]
  Output: 1',
  language: 'Ruby',
  tests: {
    [1, 2, 3, 4, 5] => 120,
    [10, -3, 8, 1] => -240,
    [1, 1, 1, 1, 1] => 1,
  },
  method_template: 'def multiply_array(array)\n  \nend',
)

create_challenge(
  name: 'Even Number Check',
  difficulty: 1,
  description: 'Write a method that takes a number as an argument and returns true if the number is even, false otherwise.

  For example:
  Input: 4
  Output: true

  Input: 7
  Output: false

  Input: -10
  Output: true

  Input: 0
  Output: true',
  language: 'Ruby',
  tests: {
    4 => true,
    7 => false,
    -10 => true,
    0 => true,
  },
  method_template: 'def even_number?(number)\n  \nend',
)

create_challenge(
  name: 'Numbers Greater Than Five',
  difficulty: 1,
  description: 'Given an array of numbers, count how many items are greater than 5.
  The method should return an integer.

  For example:
    [1, 4, 2, 70, 45, -2] --> 2',
  language: 'Ruby',
  tests: {
    [1, 48, 32, 6, 90, 2, 3] => 4,
    [32, 3, 1, 8, 5, 4] => 2,
  },
  method_template: 'def numbers_greater_than_five(array)\n  \nend',
)

create_challenge(
  name: 'Prime Number Algorith',
  difficulty: 1,
  description: 'Given an array of numbers, count how many items are prime numbers.
  The method should return an integer.

  For example:
    [15, 53, 117, 487, 1212, 1213] --> 3',
  language: 'Ruby',
  tests: {
    [1303, 41, 86, 997, 100] => 3,
    [120, 2, 1, 60, -1, 80] => 1,
  },
  method_template: 'def prime_number_algorithm(array)\n  \nend',
)

create_challenge(
  name: 'Sum of Prime Numbers',
  difficulty: 1,
  description: 'Given an array of numbers, calculate the sum of the prime numbers.
  The method should return an integer.

  For example:
    [15, 53, 117, 487, 1212, 1213] --> 1753',
  language: 'Ruby',
  tests: {
    [1303, 41, 86, 997, 100] => 2341,
    [120, 2, 1, 60, -1, 80] => 2,
  },
  method_template: 'def sum_of_prime_numbers(array)\n  \nend',
)

create_challenge(
  name: 'Factorial Numbers',
  difficulty: 1,
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
    4 => 24,
  },
  method_template: 'def factorial_numbers(number)\n  \nend',
)

create_challenge(
  name: 'Repeated Digit Checker',
  difficulty: 1,
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
    666 => true,
  },
  method_template: 'def repeated_digit_checker(integer)\n  \nend',
)

create_challenge(
  name: 'FibonacciAlgorithm',
  difficulty: 1,
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
    2 => 1,
    14 => 233,
  },
  method_template: 'def fibonacci_algorithm(integer)\n  \nend',
)

create_challenge(
  name: 'Missing Number Game',
  difficulty: 1,
  description: 'Given an array of numbers 1 - 10 that is missing one number, find the missing number.
  The method should return an integer.

  For example:
    [2, 1, 5, 4, 6, 9, 7, 8, 10] --> 3',
  language: 'Ruby',
  tests: {
    [2, 1, 3, 4, 6, 7, 9, 8, 10] => 5,
    [1, 9, 4, 10, 2, 3, 8, 5, 7] => 6,
    [9, 3, 2, 4, 7, 10, 5, 6, 1] => 8,
  },
  method_template: 'def missing_number_game(array)\n  \nend',
)

create_challenge(
  name: 'Four Passengers And Driver',
  difficulty: 1,
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
    30 => 6,
  },
  method_template: 'def four_passengers_and_driver(integer)\n  \nend',
)

create_challenge(
  name: 'Multiply Numbers in a String',
  difficulty: 1,
  description: 'Given a string which contains some numbers, return the product of all the numbers.
  The method should return an integer.

  For example:
    "1 l1v3 l1f3 2 th3 full!" --> 54
    "I need to buy 4 oranges and 3 tomatoes" --> 12',
  language: 'Ruby',
  tests: {
    '123456helloeveryone!' => 720,
    "h3k h3p .;/#';" => 9,
    '1' => 1,
  },
  method_template: 'def multiply_numbers_in_a_string(string)\n  \nend',
)

create_challenge(
  name: 'Last Letter Sort',
  difficulty: 1,
  description: 'Given a string of words, sort it alphabetically by the last character of each word.
  If two words have the same last character, sort by the order they originally appeared.
  The method should return an string of words.

  For example:
    "herb camera dynamic" --> "camera herb dynamic"
    "brick moral institution loud talk resign worth" --> "loud worth brick talk moral institution resign"',
  language: 'Ruby',
  tests: {
    'stab traction artist approach' => 'stab approach traction artist',
    'sample partner autonomy swallow trend' => 'trend sample partner swallow autonomy',
    'introduce fashionable cause sacrifice reality' => 'introduce fashionable cause sacrifice reality',
  },
  method_template: 'def multiply_numbers_in_a_string(string)\n  \nend',
)

puts "Finished creating #{Rainbow('40').cyan.bright} #{Rainbow('easy').green.bright} challenges #{Rainbow('✔').green.bright}"

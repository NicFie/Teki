puts "Creating just challenge seeds..."

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

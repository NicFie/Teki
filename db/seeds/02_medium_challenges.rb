puts "Creating #{Rainbow('30').cyan.bright} #{Rainbow('medium').orange.bright} challenges"

create_challenge(
  name: 'Type of Triangle',
  difficulty: 2,
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

create_challenge(
  name: 'Reverse Odd Length Words',
  difficulty: 2,
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

create_challenge(
  name: 'Position in Alphabet',
  difficulty: 2,
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

create_challenge(
  name: 'Find Bob',
  difficulty: 2,
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

create_challenge(
  name: 'Letter increment',
  difficulty: 2,
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

create_challenge(
  name: 'Decimator',
  difficulty: 2,
  description: 'Write a DECIMATOR method which takes a string and decimates it (i.e. it removes the last 1/10 of the characters).
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

create_challenge(
  name: 'Binary Zeroes',
  difficulty: 2,
  description: 'Given a binary string, write a method that returns the longest sequence of consecutive zeroes in a binary string.
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

create_challenge(
  name: 'Squares and Cubes',
  difficulty: 2,
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

create_challenge(
  name: 'Find Odd Integer',
  difficulty: 2,
  description: 'Create a method that takes an array and finds the integer which appears an odd number of times.
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

create_challenge(
  name: 'No Yelling',
  difficulty: 2,
  description: 'Create a method that transforms sentences ending with multiple question marks ? or exclamation marks ! into a sentence only ending with one without changing punctuation in the middle of the sentences.
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
  method_template: 'def no_yelling(string)\n  \nend'
)

create_challenge(
  name: 'Reverse Words',
  difficulty: 2,
  description: 'Write a method that takes a string as an argument and returns the string with each word reversed.
  Words are separated by a single space. The order of words should remain the same.

  For example:
  Input: "Hello World"
  Output: "olleH dlroW"

  Input: "Ruby is fun"
  Output: "ybuR si nuf"

  Input: "123 456 789"
  Output: "321 654 987"',
  language: 'Ruby',
  tests: {
    'Hello World' => 'olleH dlroW',
    'Ruby is fun' => 'ybuR si nuf',
    '123 456 789' => '321 654 987'
  },
  method_template: 'def reverse_words(string)\n  \nend'
)

create_challenge(
  name: 'Sum of Squares',
  difficulty: 2,
  description: 'Write a method that takes an array of numbers and returns the sum of the squares of all elements.

  For example:
  Input: [1, 2, 3, 4, 5]
  Output: 55

  Input: [10, -3, 8, 1]
  Output: 130

  Input: [0, 0, 0]
  Output: 0',
  language: 'Ruby',
  tests: {
    [1, 2, 3, 4, 5] => 55,
    [10, -3, 8, 1] => 130,
    [0, 0, 0] => 0
  },
  method_template: 'def sum_of_squares(array)\n  \nend'
)

create_challenge(
  name: 'Pangram Check',
  difficulty: 2,
  description: 'A pangram is a sentence that contains every letter of the alphabet at least once.
  Write a method that takes a string as an argument and returns true if it is a pangram, false otherwise.

  For example:
  Input: "The quick brown fox jumps over the lazy dog"
  Output: true

  Input: "Hello World"
  Output: false

  Input: "Pack my box with five dozen liquor jugs"
  Output: true',
  language: 'Ruby',
  tests: {
    'The quick brown fox jumps over the lazy dog' => true,
    'Hello World' => false,
    'Pack my box with five dozen liquor jugs' => true
  },
  method_template: 'def pangram?(sentence)\n  \nend'
)

create_challenge(
  name: 'Fibonacci Sequence',
  difficulty: 2,
  description: 'Write a method that takes an integer n and returns the nth number in the Fibonacci sequence.
  The Fibonacci sequence starts with 0 and 1, and each subsequent number is the sum of the two preceding ones.
  Assume n is non-negative.

  For example:
  Input: 0
  Output: 0

  Input: 1
  Output: 1

  Input: 5
  Output: 5

  Input: 10
  Output: 55',
  language: 'Ruby',
  tests: {
    0 => 0,
    1 => 1,
    5 => 5,
    10 => 55
  },
  method_template: 'def fibonacci(n)\n  \nend'
)

create_challenge(
  name: 'Unique Characters',
  difficulty: 2,
  description: 'Write a method that takes a string as an argument and returns true if all characters in the string are unique, false otherwise.

  For example:
  Input: "abcdefg"
  Output: true

  Input: "hello"
  Output: false

  Input: "123456789"
  Output: true',
  language: 'Ruby',
  tests: {
    'abcdefg' => true,
    'hello' => false,
    '123456789' => true
  },
  method_template: 'def unique_characters?(str)\n  \nend'
)

# create_challenge(
#   name: 'Array Intersection',
#   difficulty: 2,
#   description: 'Write a method that takes two arrays of numbers as arguments and returns a new array containing their intersection (common elements).
#   The elements in the returned array should be unique, and the order does not matter.
#
#   For example:
#   Input: [1, 2, 3], [3, 4, 5]
#   Output: [3]
#
#   Input: [10, 20, 30], [30, 40, 50]
#   Output: [30]
#
#   Input: [1, 2, 3], [4, 5, 6]
#   Output: []',
#   language: 'Ruby',
#   tests: {
#     [[1, 2, 3], [3, 4, 5]] => [3],
#     [[10, 20, 30], [30, 40, 50]] => [30],
#     [[1, 2, 3], [4, 5, 6]] => []
#   },
#   method_template: 'def array_intersection(arr1, arr2)\n  \nend'
# )

create_challenge(
  name: 'Power of Two',
  difficulty: 2,
  description: 'Write a method that takes an integer n as an argument and returns true if n is a power of 2, false otherwise.

  For example:
  Input: 1
  Output: true

  Input: 4
  Output: true

  Input: 10
  Output: false

  Input: 64
  Output: true',
  language: 'Ruby',
  tests: {
    1 => true,
    4 => true,
    10 => false,
    64 => true
  },
  method_template: 'def power_of_two?(n)\n  \nend'
)

create_challenge(
  name: 'Palindrome Integer',
  difficulty: 2,
  description: 'Write a method that takes an integer as an argument and returns true if it is a palindrome (reads the same backward as forward), false otherwise.

  For example:
  Input: 121
  Output: true

  Input: 12321
  Output: true

  Input: 12345
  Output: false',
  language: 'Ruby',
  tests: {
    121 => true,
    12321 => true,
    12345 => false
  },
  method_template: 'def palindrome_integer?(num)\n  \nend'
)

# create_challenge(
#   name: 'Rotate Array',
#   difficulty: 2,
#   description: 'Write a method that takes an array of numbers and an integer n as arguments and returns a new array with elements rotated to the right by n positions.
#   Assume 0 <= n < array length.
#
#   For example:
#   Input: [1, 2, 3, 4, 5], 2
#   Output: [4, 5, 1, 2, 3]
#
#   Input: [10, 20, 30, 40, 50], 3
#   Output: [30, 40, 50, 10, 20]',
#   language: 'Ruby',
#   tests: {
#     [[1, 2, 3, 4, 5], 2] => [4, 5, 1, 2, 3],
#     [[10, 20, 30, 40, 50], 3] => [30, 40, 50, 10, 20]
#   },
#   method_template: 'def rotate_array(arr, n)\n  \nend'
# )
#
# create_challenge(
#   name: 'Anagram Check',
#   difficulty: 2,
#   description: 'Write a method that takes two strings as arguments and returns true if they are anagrams (contain the same letters in a different order), false otherwise.
#
#   For example:
#   Input: "listen", "silent"
#   Output: true
#
#   Input: "hello", "world"
#   Output: false
#
#   Input: "rail safety", "fairy tales"
#   Output: true',
#   language: 'Ruby',
#   tests: {
#     ['listen', 'silent'] => true,
#     ['hello', 'world'] => false,
#     ['rail safety', 'fairy tales'] => true
#   },
#   method_template: 'def anagram?(str1, str2)\n  \nend'
# )

create_challenge(
  name: 'Reverse Odd Length Words',
  difficulty: 2,
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
  method_template: 'def reverse_odd_length_words(string)\n  \nend'
)

create_challenge(
  name: 'Largest Palindrome',
  difficulty: 2,
  description: 'Write a method that takes a string as an argument and returns the largest palindrome substring within that string.
  If there are multiple palindromes of the same length, return the first one found.

  For example:
  "racecar" --> "racecar"
  "hello" --> "ll"
  "abbacc" --> "abba"',
  language: 'Ruby',
  tests: {
    'racecar' => 'racecar',
    'hello' => 'll',
    'abbacc' => 'abba'
  },
  method_template: 'def largest_palindrome(str)\n  \nend'
)

# create_challenge(
#   name: 'Remove Element',
#   difficulty: 2,
#   description: 'Write a method that takes an array of numbers and an integer target as arguments and returns a new array with all occurrences of the target removed.
#
#   For example:
#   Input: [1, 2, 3, 4, 5], 3
#   Output: [1, 2, 4, 5]
#
#   Input: [10, 20, 30, 30, 40, 30], 30
#   Output: [10, 20, 40]
#
#   Input: [1, 1, 1, 1], 1
#   Output: []',
#   language: 'Ruby',
#   tests: {
#     [[1, 2, 3, 4, 5], 3] => [1, 2, 4, 5],
#     [[10, 20, 30, 30, 40, 30], 30] => [10, 20, 40],
#     [[1, 1, 1, 1], 1] => []
#   },
#   method_template: 'def remove_element(arr, target)\n  \nend'
# )

create_challenge(
  name: 'String Compression',
  difficulty: 2,
  description: 'Write a method that takes a string as an argument and returns a compressed version of the string.
  The compression should replace repeated characters with the character followed by the number of occurrences.

  For example:
  Input: "aaabbbbcc"
  Output: "a3b4c2"

  Input: "hello"
  Output: "h1e1l2o1"

  Input: "abcd"
  Output: "abcd"',
  language: 'Ruby',
  tests: {
    'aaabbbbcc' => 'a3b4c2',
    'hello' => 'h1e1l2o1',
    'abcd' => 'abcd'
  },
  method_template: 'def string_compression(str)\n  \nend'
)

create_challenge(
  name: 'Sum of Digits',
  difficulty: 2,
  description: 'Write a method that takes an integer as an argument and returns the sum of its digits.

  For example:
  Input: 123
  Output: 6

  Input: 456
  Output: 15

  Input: 98765
  Output: 35',
  language: 'Ruby',
  tests: {
    123 => 6,
    456 => 15,
    98765 => 35
  },
  method_template: 'def sum_of_digits(n)\n  \nend'
)

create_challenge(
  name: 'Common Prefix',
  difficulty: 2,
  description: 'Write a method that takes an array of strings as an argument and returns the longest common prefix among the strings.
  If there is no common prefix, return an empty string.

  For example:
  Input: ["flower", "flow", "flight"]
  Output: "fl"

  Input: ["dog", "race", "car"]
  Output: ""',
  language: 'Ruby',
  tests: {
    ['flower', 'flow', 'flight'] => 'fl',
    ['dog', 'race', 'car'] => ''
  },
  method_template: 'def common_prefix(strings)\n  \nend'
)

create_challenge(
  name: 'Roman to Integer',
  difficulty: 2,
  description: 'Write a method that takes a string representing a Roman numeral and returns the corresponding integer value.
  Roman numerals are represented by the following symbols: I, V, X, L, C, D, M.

  For example:
  Input: "III"
  Output: 3

  Input: "IV"
  Output: 4

  Input: "IX"
  Output: 9

  Input: "LVIII"
  Output: 58',
  language: 'Ruby',
  tests: {
    'III' => 3,
    'IV' => 4,
    'IX' => 9,
    'LVIII' => 58
  },
  method_template: 'def roman_to_integer(roman)\n  \nend'
)

create_challenge(
  name: 'Square Root',
  difficulty: 2,
  description: 'Write a method that takes a non-negative integer x and returns its square root as an integer.
  You may assume that the input will be a valid non-negative integer.

  For example:
  Input: 4
  Output: 2

  Input: 9
  Output: 3

  Input: 16
  Output: 4',
  language: 'Ruby',
  tests: {
    4 => 2,
    9 => 3,
    16 => 4
  },
  method_template: 'def square_root(x)\n  \nend'
)

create_challenge(
  name: 'Majority Element',
  difficulty: 2,
  description: 'Write a method that takes an array of numbers and returns the majority element (element that appears more than n/2 times, where n is the length of the array).
  Assume there is always a majority element.

  For example:
  Input: [3, 2, 3]
  Output: 3

  Input: [2, 2, 1, 1, 1, 2, 2]
  Output: 2

  Input: [1]
  Output: 1',
  language: 'Ruby',
  tests: {
    [3, 2, 3] => 3,
    [2, 2, 1, 1, 1, 2, 2] => 2,
    [1] => 1
  },
  method_template: 'def majority_element(arr)\n  \nend'
)

create_challenge(
  name: 'Count Primes',
  difficulty: 2,
  description: 'Write a method that takes an integer n as an argument and returns the number of prime numbers less than n.
  Assume n is a positive integer greater than 1.

  For example:
  Input: 10
  Output: 4 (Primes less than 10 are 2, 3, 5, 7)

  Input: 20
  Output: 8 (Primes less than 20 are 2, 3, 5, 7, 11, 13, 17, 19)

  Input: 30
  Output: 10 (Primes less than 30 are 2, 3, 5, 7, 11, 13, 17, 19, 23, 29)',
  language: 'Ruby',
  tests: {
    10 => 4,
    20 => 8,
    30 => 10
  },
  method_template: 'def count_primes(n)\n  \nend'
)

create_challenge(
  name: 'Reverse Words in a String',
  difficulty: 2,
  description: 'Write a method that takes a string as an argument and returns the string with the order of the words reversed.
  Words in the input string are separated by one or more spaces.
  Remove leading and trailing spaces from the resulting string.

  For example:
  Input: "hello world"
  Output: "world hello"

  Input: "  The sky is blue   "
  Output: "blue is sky The"',
  language: 'Ruby',
  tests: {
    'hello world' => 'world hello',
    '  The sky is blue   ' => 'blue is sky The'
  },
  method_template: 'def reverse_words(str)\n  \nend'
)

puts "Finished creating #{Rainbow('30').cyan.bright} #{Rainbow('medium').orange.bright} level challenges #{Rainbow('✔').green.bright}"

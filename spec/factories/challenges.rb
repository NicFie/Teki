FactoryBot.define do
  factory :challenge do
    name { "Not even odd" }
    description do
      'The method should return "even steven" if the number is even and "that was odd..." if the number is odd.'
    end
    language { "Ruby" }
    tests { { 4 => "even steven", 5 => "that was odd..." } }
    method_template { 'def not_even_odd(number)\n  \nend' }
    difficulty { 1 }
  end
end

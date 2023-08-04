module ChallengeCreator
  def create_challenge(attributes)
    Challenge.find_or_create_by!(name: attributes[:name]) do |challenge|
      puts "Creating: #{attributes[:name]}"
      challenge.description = attributes[:description]
      challenge.language = attributes[:language]
      challenge.tests = attributes[:tests]
      challenge.method_template = attributes[:method_template]
      challenge.difficulty = attributes[:difficulty]
    end
  end
end

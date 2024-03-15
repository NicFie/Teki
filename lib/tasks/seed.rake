require "rainbow"

namespace :db do
  desc "Load seed data from db/seeds/*.rb"
  task seed: :environment do
    seed_files = Dir[Rails.root.join("db", "seeds", "*.rb")]

    seed_files.each do |file|
      match = file.to_s.match(/0\d_(\w+)/)[1] if file.to_s.match?(/0\d_(\w+)/)
      puts ""
      puts "Seeding data from #{Rainbow(match ? match : 'user_seeds').cyan.bright}..."
      load(file)
    end

    puts ""
    puts "Seed data loaded successfully! #{Rainbow('✔').green.bright}"
  end
end
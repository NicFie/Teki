require 'rainbow'

namespace :db do
  desc "Load seed data from db/seeds/*.rb"
  task seed: :environment do
    seed_files = Dir[Rails.root.join('db', 'seeds', '*.rb')]

    seed_files.each do |file|
      puts "Seeding data from #{file}..."
      load(file)
    end

    puts "Seed data loaded successfully."
  end
end
class CreateChallenges < ActiveRecord::Migration[7.0]
  def change
    create_table :challenges do |t|
      t.string :name
      t.text :description
      t.string :language
      t.text :tests

      t.timestamps
    end
  end
end

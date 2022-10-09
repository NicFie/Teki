class AddMethodTemplateToChallenges < ActiveRecord::Migration[7.0]
  def change
    add_column :challenges, :method_template, :text
  end
end

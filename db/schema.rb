# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_09_27_152330) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "challenges", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "language"
    t.text "tests"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendships", force: :cascade do |t|
    t.boolean "status"
    t.bigint "asker_id"
    t.bigint "receiver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asker_id"], name: "index_friendships_on_asker_id"
    t.index ["receiver_id"], name: "index_friendships_on_receiver_id"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "player_one_id"
    t.bigint "player_two_id"
    t.integer "game_winner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "round_one_id"
    t.bigint "round_two_id"
    t.bigint "round_three_id"
    t.bigint "round_four_id"
    t.bigint "round_five_id"
    t.index ["player_one_id"], name: "index_games_on_player_one_id"
    t.index ["player_two_id"], name: "index_games_on_player_two_id"
    t.index ["round_five_id"], name: "index_games_on_round_five_id"
    t.index ["round_four_id"], name: "index_games_on_round_four_id"
    t.index ["round_one_id"], name: "index_games_on_round_one_id"
    t.index ["round_three_id"], name: "index_games_on_round_three_id"
    t.index ["round_two_id"], name: "index_games_on_round_two_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.integer "round_winner"
    t.datetime "completion_time"
    t.bigint "challenge_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "winner_id"
    t.index ["challenge_id"], name: "index_rounds_on_challenge_id"
    t.index ["winner_id"], name: "index_rounds_on_winner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "avatar"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "friendships", "users", column: "asker_id"
  add_foreign_key "friendships", "users", column: "receiver_id"
  add_foreign_key "games", "rounds", column: "round_five_id"
  add_foreign_key "games", "rounds", column: "round_four_id"
  add_foreign_key "games", "rounds", column: "round_one_id"
  add_foreign_key "games", "rounds", column: "round_three_id"
  add_foreign_key "games", "rounds", column: "round_two_id"
  add_foreign_key "games", "users", column: "player_one_id"
  add_foreign_key "games", "users", column: "player_two_id"
  add_foreign_key "rounds", "challenges"
  add_foreign_key "rounds", "users", column: "winner_id"
end

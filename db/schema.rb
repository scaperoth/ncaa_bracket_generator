# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160419021724) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "bmatrix_stats", force: true do |t|
    t.integer  "bmatrix_team_id"
    t.integer  "tournament_id"
    t.integer  "rank"
    t.decimal  "avg_seed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bmatrix_stats", ["bmatrix_team_id"], name: "index_bmatrix_stats_on_bmatrix_team_id", using: :btree
  add_index "bmatrix_stats", ["tournament_id"], name: "index_bmatrix_stats_tournament_id", using: :btree

  create_table "bmatrix_teams", force: true do |t|
    t.string   "name"
    t.string   "conf"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bmatrix_teams", ["name"], name: "index_bmatrix_teams_on_name", using: :btree

  create_table "bracket_games", force: true do |t|
    t.integer  "tournament_id"
    t.integer  "round_id"
    t.integer  "region_id"
    t.integer  "team_id"
    t.integer  "team1_score"
    t.integer  "team2_id"
    t.integer  "team2_score"
    t.integer  "weight"
    t.integer  "winner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bracket_games", ["region_id"], name: "index_bracket_games_on_region_id", using: :btree
  add_index "bracket_games", ["round_id"], name: "index_bracket_games_on_round_id", using: :btree
  add_index "bracket_games", ["team2_id"], name: "index_bracket_games_on_team2_id", using: :btree
  add_index "bracket_games", ["team_id"], name: "index_bracket_games_on_team_id", using: :btree
  add_index "bracket_games", ["tournament_id"], name: "index_bracket_games_on_tournament_id", using: :btree
  add_index "bracket_games", ["winner_id"], name: "index_bracket_games_on_winner_id", using: :btree

  create_table "conferences", force: true do |t|
    t.string   "name"
    t.string   "kp_name"
    t.string   "bmat_name"
    t.string   "short_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "generated_bracket_games", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "generated_bracket_options", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kenpom_stats", force: true do |t|
    t.integer  "kenpom_team_id"
    t.integer  "tournament_id"
    t.integer  "rank"
    t.string   "wl"
    t.decimal  "pyth"
    t.decimal  "adjo"
    t.decimal  "adjd"
    t.decimal  "adjt"
    t.decimal  "luck"
    t.decimal  "pyth_sched"
    t.decimal  "oppo_sched"
    t.decimal  "oppd_sched"
    t.decimal  "pyth_ncsos"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "kenpom_stats", ["kenpom_team_id"], name: "index_kenpom_stats_on_kenpom_team_id", using: :btree
  add_index "kenpom_stats", ["tournament_id"], name: "index_kenpom_stats_tournament_id", using: :btree

  create_table "kenpom_teams", force: true do |t|
    t.string   "name"
    t.string   "conf"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "kenpom_teams", ["name"], name: "index_kenpom_teams_on_name", using: :btree

  create_table "regions", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rounds", force: true do |t|
    t.integer  "number"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", force: true do |t|
    t.string   "name"
    t.integer  "conference_id"
    t.integer  "kenpom_team_id"
    t.integer  "bmatrix_team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["name"], name: "index_teams_on_name", using: :btree

  create_table "tournaments", force: true do |t|
    t.string   "name"
    t.date     "date"
    t.string   "year"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
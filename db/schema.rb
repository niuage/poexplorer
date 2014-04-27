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

ActiveRecord::Schema.define(version: 20140427205311) do

  create_table "accounts", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authentications", force: true do |t|
    t.integer  "user_id"
    t.string   "uid"
    t.string   "provider"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bandit_choices", force: true do |t|
    t.integer "build_id"
    t.integer "normal_choice"
    t.integer "cruel_choice"
    t.integer "merciless_choice"
    t.text    "alternatives"
  end

  create_table "broadcasts", force: true do |t|
    t.string   "title"
    t.string   "body"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "build_classes", force: true do |t|
    t.integer  "build_id"
    t.integer  "klass_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "build_keystones", force: true do |t|
    t.integer "build_id"
    t.integer "keystone_id"
  end

  create_table "build_leagues", force: true do |t|
    t.integer  "build_id"
    t.integer  "league_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "build_searches", force: true do |t|
    t.string   "uid"
    t.integer  "user_id"
    t.integer  "build_id"
    t.string   "order"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "keywords"
    t.integer  "life_type"
    t.boolean  "softcore",      default: true
    t.boolean  "hardcore",      default: true
    t.string   "skill_gem_ids"
    t.string   "unique_ids"
    t.string   "klass_ids"
    t.string   "keystone_ids"
    t.boolean  "pvp",           default: false
    t.integer  "user_uid"
  end

  add_index "build_searches", ["uid"], name: "index_build_searches_on_uid", using: :btree

  create_table "build_uniques", force: true do |t|
    t.integer "build_id"
    t.integer "unique_id"
  end

  create_table "builds", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "summary"
    t.text     "description"
    t.string   "video_url"
    t.integer  "life_type"
    t.integer  "playstyle"
    t.integer  "role"
    t.boolean  "pvp"
    t.string   "version"
    t.boolean  "indexed"
    t.boolean  "certified"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.boolean  "softcore",       default: true
    t.boolean  "hardcore",       default: true
    t.text     "gearing_advice"
    t.text     "conclusion"
    t.integer  "up_votes",       default: 0,    null: false
    t.integer  "down_votes",     default: 0,    null: false
    t.integer  "views",          default: 0
  end

  create_table "exile_uniques", force: true do |t|
    t.integer  "unique_id"
    t.integer  "exile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exiles", force: true do |t|
    t.string   "name"
    t.text     "tagline"
    t.text     "description"
    t.integer  "views"
    t.integer  "user_id"
    t.integer  "klass_id"
    t.string   "video_uid"
    t.string   "album_uid"
    t.text     "cached_photos"
    t.text     "items"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favoriteds", force: true do |t|
    t.integer  "search_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "forum_threads", force: true do |t|
    t.string   "account"
    t.string   "items_md5"
    t.text     "item_store",      limit: 16777215
    t.integer  "uid"
    t.integer  "league_id"
    t.datetime "last_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gear_gems", force: true do |t|
    t.integer "gear_id"
    t.integer "skill_gem_id"
  end

  create_table "gears", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "gear_gems_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "build_id"
    t.boolean  "main",            default: false
  end

  create_table "item_types", force: true do |t|
    t.string "name"
  end

  add_index "item_types", ["name"], name: "index_item_types_on_name", using: :btree

  create_table "items", force: true do |t|
    t.integer  "league_id"
    t.integer  "rarity_id"
    t.string   "name",                                   null: false
    t.string   "base_name"
    t.string   "account"
    t.text     "socket_store"
    t.integer  "quality"
    t.integer  "block_chance"
    t.integer  "armour"
    t.integer  "evasion"
    t.integer  "energy_shield"
    t.integer  "physical_damage"
    t.integer  "dps"
    t.float    "critical_strike_chance"
    t.float    "aps"
    t.integer  "level"
    t.string   "requirements"
    t.string   "type"
    t.string   "price"
    t.string   "thread_id"
    t.boolean  "verified"
    t.boolean  "identified"
    t.datetime "indexed_at"
    t.string   "icon"
    t.text     "raw_icon"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "size"
    t.date     "thread_updated_at"
    t.string   "league_name"
    t.string   "rarity_name"
    t.integer  "elemental_damage"
    t.integer  "sold",                   default: 0
    t.string   "display_stats"
    t.string   "socket_combination"
    t.boolean  "corrupted",              default: false
  end

  add_index "items", ["uid", "thread_id"], name: "index_items_on_uid_and_thread_id", using: :btree

  create_table "keystones", force: true do |t|
    t.string  "name"
    t.text    "description"
    t.string  "icon"
    t.integer "uid"
  end

  create_table "klasses", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leagues", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "permanent",  default: false
    t.boolean  "hardcore",   default: false
  end

  add_index "leagues", ["name"], name: "index_leagues_on_name", using: :btree

  create_table "messages", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "contact_info"
  end

  create_table "mod_item_types", force: true do |t|
    t.integer "mod_id"
    t.integer "item_type_id"
    t.string  "mod_group"
  end

  add_index "mod_item_types", ["item_type_id"], name: "index_mod_item_types_on_item_type_id", using: :btree
  add_index "mod_item_types", ["mod_id"], name: "index_mod_item_types_on_mod_id", using: :btree

  create_table "mods", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mods", ["name"], name: "index_mods_on_name", using: :btree

  create_table "players", force: true do |t|
    t.integer  "league_id"
    t.boolean  "online",           default: false
    t.string   "account"
    t.string   "character"
    t.datetime "marked_online_at"
    t.datetime "last_online"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "players", ["account", "league_id"], name: "index_players_on_account_and_league_id", using: :btree
  add_index "players", ["account"], name: "index_players_on_account", using: :btree
  add_index "players", ["character", "league_id"], name: "index_players_on_character_and_league_id", using: :btree

  create_table "posts", force: true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rarities", force: true do |t|
    t.string   "name",       null: false
    t.integer  "frame_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rarities", ["name"], name: "index_rarities_on_name", using: :btree

  create_table "scrawls", force: true do |t|
    t.integer  "thread_count"
    t.integer  "item_count"
    t.boolean  "successful"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "search_stats", force: true do |t|
    t.string   "name"
    t.integer  "search_id"
    t.integer  "mod_id"
    t.integer  "value"
    t.integer  "max_value"
    t.boolean  "required",   default: false
    t.boolean  "excluded",   default: false
    t.boolean  "gte",        default: false
    t.boolean  "lte",        default: false
    t.boolean  "implicit",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "search_stats", ["search_id"], name: "index_search_stats_on_search_id", using: :btree

  create_table "searches", force: true do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.string   "item_type"
    t.integer  "league_id"
    t.integer  "str"
    t.integer  "max_str"
    t.integer  "int"
    t.integer  "max_int"
    t.integer  "dex"
    t.integer  "max_dex"
    t.string   "uid"
    t.string   "account"
    t.string   "full_name"
    t.string   "name"
    t.string   "base_name"
    t.string   "currency"
    t.string   "socket_combination"
    t.string   "thread_id"
    t.string   "quality"
    t.integer  "dps"
    t.integer  "max_dps"
    t.integer  "physical_dps"
    t.integer  "max_physical_dps"
    t.float    "aps"
    t.float    "critical_strike_chance"
    t.float    "price_value"
    t.float    "max_price_value"
    t.integer  "physical_damage"
    t.integer  "max_physical_damage"
    t.integer  "elemental_damage"
    t.integer  "max_elemental_damage"
    t.integer  "block_chance"
    t.integer  "max_block_chance"
    t.integer  "armour"
    t.integer  "max_armour"
    t.integer  "evasion"
    t.integer  "max_evasion"
    t.integer  "energy_shield"
    t.integer  "max_energy_shield"
    t.integer  "rarity_id"
    t.integer  "socket_count"
    t.integer  "max_socket_count"
    t.integer  "linked_socket_count"
    t.integer  "max_linked_socket_count"
    t.integer  "level"
    t.integer  "max_level"
    t.boolean  "has_price",               default: false
    t.boolean  "same_item_type"
    t.boolean  "corrupted"
    t.boolean  "online",                  default: false
    t.string   "order"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "minimum_mod_match",       default: 0
    t.integer  "order_by_mod_id"
  end

  add_index "searches", ["uid"], name: "index_searches_on_uid", using: :btree

  create_table "skill_gems", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "attr"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "support",     default: false
  end

  create_table "skill_trees", force: true do |t|
    t.integer  "build_id"
    t.text     "url"
    t.text     "description"
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stats", force: true do |t|
    t.string   "name"
    t.integer  "item_id"
    t.integer  "mod_id"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "hidden",     default: false
    t.boolean  "implicit",   default: false
  end

  add_index "stats", ["item_id"], name: "index_stats_on_item_id", using: :btree

  create_table "uniques", force: true do |t|
    t.string   "name"
    t.string   "base_item"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_url"
  end

  create_table "user_favorites", force: true do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "login",                                         null: false
    t.string   "bio"
    t.string   "forum_token"
    t.string   "email",                    default: "",         null: false
    t.string   "encrypted_password",       default: "",         null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",                     default: "verified"
    t.string   "avatar"
    t.text     "cached_favorite_item_ids"
    t.integer  "league_id"
    t.string   "league_name"
    t.integer  "up_votes",                 default: 0,          null: false
    t.integer  "down_votes",               default: 0,          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "votings", force: true do |t|
    t.string   "voteable_type"
    t.integer  "voteable_id"
    t.string   "voter_type"
    t.integer  "voter_id"
    t.boolean  "up_vote",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votings", ["voteable_type", "voteable_id", "voter_type", "voter_id"], name: "unique_voters", unique: true, using: :btree
  add_index "votings", ["voteable_type", "voteable_id"], name: "index_votings_on_voteable_type_and_voteable_id", using: :btree
  add_index "votings", ["voter_type", "voter_id"], name: "index_votings_on_voter_type_and_voter_id", using: :btree

end

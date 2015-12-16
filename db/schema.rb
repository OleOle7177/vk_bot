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

ActiveRecord::Schema.define(version: 20151216114731) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fakes", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "login"
    t.string   "password"
    t.integer  "user_id"
    t.text     "message"
    t.string   "access_token"
    t.datetime "token_expires_at"
    t.integer  "vk_id"
    t.boolean  "schedule_notify",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fakes", ["user_id"], name: "index_fakes_on_user_id", using: :btree

  create_table "fakes_friends", force: :cascade do |t|
    t.integer  "friend_id"
    t.integer  "fake_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fakes_friends", ["fake_id"], name: "index_fakes_friends_on_fake_id", using: :btree
  add_index "fakes_friends", ["friend_id"], name: "index_fakes_friends_on_friend_id", using: :btree

  create_table "friends", force: :cascade do |t|
    t.integer  "vk_id"
    t.boolean  "notified",          default: false
    t.boolean  "in_group",          default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "notification_date"
  end

  add_index "friends", ["in_group"], name: "index_friends_on_in_group", using: :btree
  add_index "friends", ["notified"], name: "index_friends_on_notified", using: :btree
  add_index "friends", ["vk_id"], name: "index_friends_on_vk_id", using: :btree

  create_table "statistics", force: :cascade do |t|
    t.integer  "fake_id"
    t.datetime "date"
    t.integer  "event_type_id"
    t.integer  "count"
    t.string   "message"
  end

  add_index "statistics", ["fake_id"], name: "index_statistics_on_fake_id", using: :btree

  create_table "system_journals", force: :cascade do |t|
    t.integer  "fake_id"
    t.string   "type"
    t.text     "note"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "login"
    t.string "string"
    t.string "password_digest"
  end

end

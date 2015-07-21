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

ActiveRecord::Schema.define(version: 20150721084224) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "subject_id"
    t.string   "subject_type"
    t.integer  "user_id"
    t.integer  "target_user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "activities", ["subject_type"], name: "index_activities_on_subject_type", using: :btree
  add_index "activities", ["target_user_id"], name: "index_activities_on_target_user_id", using: :btree
  add_index "activities", ["user_id"], name: "index_activities_on_user_id", using: :btree

  create_table "entries", force: :cascade do |t|
    t.datetime "date",                           null: false
    t.integer  "duration",                       null: false
    t.integer  "user_id",                        null: false
    t.integer  "amount_contributed", default: 0
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.text     "description"
    t.string   "workout_image_url"
  end

  add_index "entries", ["user_id"], name: "index_entries_on_user_id", using: :btree

  create_table "user_interactions", force: :cascade do |t|
    t.integer  "from_user_id"
    t.integer  "to_user_id"
    t.string   "interaction_type"
    t.boolean  "notification_read", default: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "user_interactions", ["from_user_id"], name: "index_user_interactions_on_from_user_id", using: :btree
  add_index "user_interactions", ["interaction_type"], name: "index_user_interactions_on_interaction_type", using: :btree
  add_index "user_interactions", ["to_user_id"], name: "index_user_interactions_on_to_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "gcm_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "slack_user_name"
  end

end

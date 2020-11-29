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

ActiveRecord::Schema.define(version: 20201129000609) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.string "push_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "applications", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title", null: false
    t.integer "rating", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category", default: ""
    t.string "problem", default: ""
    t.string "decision", default: ""
    t.string "impact", default: ""
    t.boolean "economy", default: false
    t.jsonb "other_authors"
    t.jsonb "expenses"
    t.jsonb "stages"
    t.string "file"
    t.string "doc_app"
    t.integer "count_likes", default: 0
    t.integer "status", default: 1
    t.integer "popularity", default: 0
    t.integer "uniqueness", default: 0
    t.integer "direction_activity", default: 0
    t.index ["user_id"], name: "index_applications_on_user_id"
  end

  create_table "chats", force: :cascade do |t|
    t.bigint "application_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_chats_on_application_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "application_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_likes_on_application_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.string "sender_type"
    t.bigint "sender_id"
    t.bigint "chat_id"
    t.string "picture"
    t.integer "type_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["sender_type", "sender_id"], name: "index_messages_on_sender_type_and_sender_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "surname"
    t.string "second_name"
    t.string "password_digest"
    t.float "rating", default: 0.0
    t.string "unit", null: false
    t.string "email", null: false
    t.string "push_token"
    t.boolean "verify", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "start_working"
    t.date "birthday"
    t.string "education", default: ""
    t.integer "count_messages", default: 0
    t.integer "count_approved", default: 0
    t.string "post", default: ""
  end

  add_foreign_key "applications", "users"
end

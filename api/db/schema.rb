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

ActiveRecord::Schema.define(version: 20201127170421) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.string "push_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "aplications", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name", null: false
    t.text "text", null: false
    t.integer "rating", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_aplications_on_user_id"
  end

  create_table "chats", force: :cascade do |t|
    t.bigint "application_id", null: false
    t.index ["application_id"], name: "index_chats_on_application_id"
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
  end

  add_foreign_key "aplications", "users"
end

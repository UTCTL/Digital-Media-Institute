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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111212175114) do

  create_table "groupings", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lessons", :force => true do |t|
    t.integer  "skill_id"
    t.string   "title"
    t.text     "content"
    t.string   "thumbnail"
    t.integer  "list_scope"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "kind"
    t.string   "link"
  end

  create_table "skills", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "icon"
    t.string   "slug"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.text     "about_me"
    t.string   "url"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "display_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end

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

ActiveRecord::Schema.define(:version => 20120313174703) do

  create_table "challenges", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.string   "assets"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "submission_type"
  end

  create_table "groupings", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lessons", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "kind"
    t.string   "link"
    t.string   "assets"
    t.string   "submission_type"
    t.boolean  "allow_submission"
  end

  create_table "skill_challenges", :force => true do |t|
    t.integer  "skill_id"
    t.integer  "challenge_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.string   "title"
  end

  create_table "skill_lessons", :force => true do |t|
    t.integer  "skill_id"
    t.integer  "lesson_id"
    t.integer  "list_scope"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "fulltitle"
  end

  create_table "submissions", :force => true do |t|
    t.integer  "user_id"
    t.string   "attachment"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "media_type"
    t.integer  "answerable_id"
    t.string   "answerable_type"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password"
    t.text     "about_me"
    t.string   "url"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "display_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end

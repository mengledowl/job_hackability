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

ActiveRecord::Schema.define(version: 20160813045550) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.integer  "job_listing_id"
    t.integer  "user_id"
    t.text     "value"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "interview_id"
  end

  add_index "comments", ["interview_id"], name: "index_comments_on_interview_id", using: :btree
  add_index "comments", ["job_listing_id"], name: "index_comments_on_job_listing_id", using: :btree

  create_table "interviews", force: :cascade do |t|
    t.integer  "job_listing_id"
    t.datetime "scheduled_at"
    t.string   "location"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "how_it_went"
    t.string   "description"
    t.string   "time_zone"
  end

  create_table "job_listings", force: :cascade do |t|
    t.text     "url"
    t.integer  "user_id"
    t.text     "title"
    t.text     "description"
    t.text     "raw_scraping_data"
    t.text     "apply_link"
    t.text     "resume_link"
    t.text     "cover_letter_link"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.boolean  "favorite"
    t.text     "position"
    t.date     "posted_date"
    t.string   "company_website"
    t.string   "company"
    t.text     "apply_details"
    t.datetime "applied_at"
    t.string   "status"
    t.string   "location"
    t.boolean  "remote"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end

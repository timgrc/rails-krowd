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


ActiveRecord::Schema.define(version: 20161206132703) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "badges", force: :cascade do |t|
    t.string   "name"
    t.string   "kind"
    t.string   "picture"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string   "plain"
    t.string   "rich"
    t.string   "liked_by"
    t.string   "kind"
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_comments_on_post_id", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "groups", force: :cascade do |t|
    t.string   "rse_group_id"
    t.string   "rse_network_id"
    t.string   "network_name"
    t.string   "full_name"
    t.string   "description"
    t.string   "web_url"
    t.string   "mugshot_url"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "incentive_templates", force: :cascade do |t|
    t.string   "title"
    t.string   "body"
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_incentive_templates_on_group_id", using: :btree
    t.index ["user_id"], name: "index_incentive_templates_on_user_id", using: :btree
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_memberships_on_group_id", using: :btree
    t.index ["user_id"], name: "index_memberships_on_user_id", using: :btree
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "rse_post_id"
    t.string   "rse_created_at"
    t.string   "message_type"
    t.string   "web_url"
    t.string   "title"
    t.string   "plain"
    t.string   "rich"
    t.string   "liked_by"
    t.string   "disruption"
    t.string   "kind"
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["group_id"], name: "index_posts_on_group_id", using: :btree
    t.index ["user_id"], name: "index_posts_on_user_id", using: :btree
  end

  create_table "push_posts", force: :cascade do |t|
    t.string   "title"
    t.string   "body"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_push_posts_on_user_id", using: :btree
  end

  create_table "user_badges", force: :cascade do |t|
    t.integer  "badge_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "group_id"
    t.index ["badge_id"], name: "index_user_badges_on_badge_id", using: :btree
    t.index ["group_id"], name: "index_user_badges_on_group_id", using: :btree
    t.index ["user_id"], name: "index_user_badges_on_user_id", using: :btree
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
    t.integer  "rse_user_id"
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "job_title"
    t.string   "contact"
    t.string   "timezone"
    t.string   "location"
    t.string   "department"
    t.string   "expertise"
    t.string   "mugshot_url"
    t.boolean  "admin"
    t.string   "access_token"
    t.string   "network_name"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "incentive_templates", "groups"
  add_foreign_key "incentive_templates", "users"
  add_foreign_key "memberships", "groups"
  add_foreign_key "memberships", "users"
  add_foreign_key "posts", "groups"
  add_foreign_key "posts", "users"
  add_foreign_key "push_posts", "users"
  add_foreign_key "user_badges", "badges"
  add_foreign_key "user_badges", "groups"
  add_foreign_key "user_badges", "users"
end

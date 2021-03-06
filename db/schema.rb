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

ActiveRecord::Schema.define(version: 2016_12_19_230944) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "badges", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "kind"
    t.string "picture"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bot_users", id: :serial, force: :cascade do |t|
    t.integer "latest_rse_replied_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_bot_users_on_user_id"
  end

  create_table "groups", id: :serial, force: :cascade do |t|
    t.string "rse_id"
    t.string "rse_network_id"
    t.string "network_name"
    t.string "full_name"
    t.string "description"
    t.string "web_url"
    t.string "mugshot_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total_members"
  end

  create_table "incentive_templates", id: :serial, force: :cascade do |t|
    t.string "body"
    t.integer "group_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_incentive_templates_on_group_id"
    t.index ["user_id"], name: "index_incentive_templates_on_user_id"
  end

  create_table "memberships", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "user_in_dash", default: false
    t.index ["group_id"], name: "index_memberships_on_group_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.string "plain"
    t.string "idea_kint_kext_social"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rse_id"
    t.integer "rse_replied_to_id"
    t.string "web_url"
    t.string "parsed"
    t.integer "liked_by"
    t.integer "notified_by"
    t.integer "thread_post_id"
    t.integer "replied_to_id"
    t.index ["thread_post_id"], name: "index_messages_on_thread_post_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "push_messages", id: :serial, force: :cascade do |t|
    t.string "body"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_push_messages_on_user_id"
  end

  create_table "technip_to_wearestim_ids", id: :serial, force: :cascade do |t|
    t.integer "technip_message_id"
    t.integer "wearestim_message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "technip_users", id: :serial, force: :cascade do |t|
    t.integer "rse_id"
    t.string "email"
    t.string "job_title"
    t.string "location"
    t.string "expertise"
    t.string "first_name"
    t.string "last_name"
    t.string "name"
    t.string "mugshot_url"
    t.string "timezone"
    t.string "department"
    t.string "contact"
    t.string "network_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "thread_posts", id: :serial, force: :cascade do |t|
    t.integer "rse_id"
    t.string "web_url"
    t.string "innovation_disruption"
    t.string "business_technology"
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "updates"
    t.integer "first_reply_id"
    t.integer "latest_reply_id"
    t.index ["group_id"], name: "index_thread_posts_on_group_id"
  end

  create_table "user_badges", id: :serial, force: :cascade do |t|
    t.integer "badge_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "group_id"
    t.index ["badge_id"], name: "index_user_badges_on_badge_id"
    t.index ["group_id"], name: "index_user_badges_on_group_id"
    t.index ["user_id"], name: "index_user_badges_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rse_id"
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.string "job_title"
    t.string "contact"
    t.string "timezone"
    t.string "location"
    t.string "department"
    t.string "expertise"
    t.string "mugshot_url"
    t.boolean "admin"
    t.string "access_token"
    t.string "network_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bot_users", "users"
  add_foreign_key "incentive_templates", "groups"
  add_foreign_key "incentive_templates", "users"
  add_foreign_key "memberships", "groups"
  add_foreign_key "memberships", "users"
  add_foreign_key "messages", "thread_posts"
  add_foreign_key "messages", "users"
  add_foreign_key "push_messages", "users"
  add_foreign_key "thread_posts", "groups"
  add_foreign_key "user_badges", "badges"
  add_foreign_key "user_badges", "groups"
  add_foreign_key "user_badges", "users"
end

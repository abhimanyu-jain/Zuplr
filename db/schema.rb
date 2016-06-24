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

ActiveRecord::Schema.define(version: 20160624144341) do

  create_table "cities", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "code",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "remark",     limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "conversations", force: :cascade do |t|
    t.integer  "sender_id",   limit: 4
    t.integer  "receiver_id", limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "deliveries", force: :cascade do |t|
    t.string   "address1",       limit: 255
    t.string   "address2",       limit: 255
    t.string   "city",           limit: 255
    t.integer  "phonenumber",    limit: 8
    t.datetime "delivery_date"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "pincode",        limit: 4
    t.integer  "user_id",        limit: 4
    t.string   "status",         limit: 255
    t.string   "session_number", limit: 255
  end

  add_index "deliveries", ["user_id"], name: "index_deliveries_on_user_id", using: :btree

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.string   "provider",    limit: 255
    t.string   "accesstoken", limit: 255
    t.string   "uid",         limit: 255
    t.string   "name",        limit: 255
    t.string   "email",       limit: 255
    t.string   "nickname",    limit: 255
    t.string   "image",       limit: 255
    t.string   "phone",       limit: 255
    t.string   "urls",        limit: 255
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.boolean  "mail_sent",               default: false
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "items", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "leads", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "phonenumber", limit: 8
    t.string   "city",        limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "email",       limit: 255
  end

  create_table "messages", force: :cascade do |t|
    t.text     "message_body",    limit: 65535
    t.integer  "user_id",         limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "conversation_id", limit: 4
  end

  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.string   "order_code",            limit: 255
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "user_id",               limit: 4
    t.string   "status",                limit: 255
    t.date     "scheduleddeliverydate"
    t.text     "stylist_comments",      limit: 65535
  end

  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "userdata", force: :cascade do |t|
    t.text     "data",        limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "city",        limit: 255
    t.integer  "phonenumber", limit: 8
    t.integer  "user_id",     limit: 4
  end

  add_index "userdata", ["user_id"], name: "index_userdata_on_user_id", using: :btree

  create_table "userprofiles", force: :cascade do |t|
    t.text     "data",        limit: 65535
    t.string   "city",        limit: 255
    t.integer  "phonenumber", limit: 8
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "name",        limit: 255
    t.integer  "user_id",     limit: 4
    t.integer  "credits",     limit: 4,     default: 0
    t.string   "address",     limit: 255
  end

  add_index "userprofiles", ["user_id"], name: "index_userprofiles_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_id",                limit: 4,   default: 1
    t.integer  "userdatum_id",           limit: 4
    t.integer  "userprofile_id",         limit: 4
    t.string   "invitation_token",       limit: 255
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit",       limit: 4
    t.integer  "invited_by_id",          limit: 4
    t.string   "invited_by_type",        limit: 255
    t.integer  "invitations_count",      limit: 4,   default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree
  add_index "users", ["userdatum_id"], name: "index_users_on_userdatum_id", using: :btree
  add_index "users", ["userprofile_id"], name: "index_users_on_userprofile_id", using: :btree

  add_foreign_key "comments", "users"
  add_foreign_key "deliveries", "users"
  add_foreign_key "identities", "users"
  add_foreign_key "messages", "users"
  add_foreign_key "orders", "users"
  add_foreign_key "userdata", "users"
  add_foreign_key "userprofiles", "users"
  add_foreign_key "users", "roles"
  add_foreign_key "users", "userdata"
  add_foreign_key "users", "userprofiles"
end

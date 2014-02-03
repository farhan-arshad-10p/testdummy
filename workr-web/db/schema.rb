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

ActiveRecord::Schema.define(version: 20131022195010) do

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "articles", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.integer  "content_source_id"
    t.integer  "user_id"
  end

  add_index "articles", ["content_source_id"], name: "index_articles_content_source_id", using: :btree
  add_index "articles", ["user_id"], name: "index_articles_user_id", using: :btree

  create_table "articles_collections", id: false, force: true do |t|
    t.integer "article_id"
    t.integer "collection_id"
  end

  add_index "articles_collections", ["article_id"], name: "index_articles_collections_on_article_id", using: :btree
  add_index "articles_collections", ["collection_id"], name: "index_articles_collections_on_collection_id", using: :btree

  create_table "collections", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "collections", ["user_id"], name: "index_collections_user_id", using: :btree

  create_table "content_sources", force: true do |t|
    t.text     "content",            limit: 2147483647
    t.text     "url"
    t.text     "media_url"
    t.text     "featured_image_url"
    t.text     "raw_article",        limit: 2147483647
    t.string   "provider_name"
    t.string   "provider_display"
    t.string   "provider_url"
    t.integer  "view_count",                            default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "description"
    t.string   "content_type"
  end

  create_table "flags", force: true do |t|
    t.integer "user_id"
    t.integer "article_id"
    t.string  "reason"
    t.boolean "open",       default: true
  end

  add_index "flags", ["article_id"], name: "index_flags_on_article_id", using: :btree
  add_index "flags", ["user_id"], name: "index_flags_on_user_id", using: :btree

  create_table "hosted_files", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "upload_file_name"
    t.string   "upload_content_type"
    t.integer  "upload_file_size"
    t.datetime "upload_updated_at"
  end

  create_table "interests", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interests_users", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "interest_id"
  end

  add_index "interests_users", ["interest_id"], name: "index_interests_users_on_interest_id", using: :btree
  add_index "interests_users", ["user_id"], name: "index_interests_users_on_user_id", using: :btree

  create_table "invites", force: true do |t|
    t.string   "code"
    t.boolean  "active",     default: true
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invites", ["user_id"], name: "index_invites_user_id", using: :btree

  create_table "ratings", force: true do |t|
    t.integer "article_id"
    t.integer "user_id"
    t.integer "rating"
  end

  create_table "relationships", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string "name"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "terms_of_service",       default: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "viewed_articles", force: true do |t|
    t.integer "user_id"
    t.integer "article_id"
  end

  add_index "viewed_articles", ["article_id"], name: "index_viewed_articles_on_article_id", using: :btree
  add_index "viewed_articles", ["user_id"], name: "index_viewed_articles_on_user_id", using: :btree

  create_table "workr_settings", force: true do |t|
    t.text "article_search_settings"
  end

end

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

ActiveRecord::Schema.define(version: 20160301194357) do

  create_table "playlist_entries", force: :cascade do |t|
    t.integer "playlist_id"
    t.integer "song_id"
  end

  add_index "playlist_entries", ["playlist_id", "song_id"], name: "index_playlist_entries_on_playlist_id_and_song_id", unique: true
  add_index "playlist_entries", ["playlist_id"], name: "index_playlist_entries_on_playlist_id"
  add_index "playlist_entries", ["song_id"], name: "index_playlist_entries_on_song_id"

  create_table "playlists", force: :cascade do |t|
    t.string   "pid"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "songs", force: :cascade do |t|
    t.string   "uri"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "uid"
    t.string   "provider"
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "login_data"
  end

end

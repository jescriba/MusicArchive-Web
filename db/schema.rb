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

ActiveRecord::Schema.define(version: 20171014155614) do

  create_table "albums", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.date "release_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "artist_albums", force: :cascade do |t|
    t.integer "artist_id"
    t.integer "album_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "index_artist_albums_on_album_id"
    t.index ["artist_id"], name: "index_artist_albums_on_artist_id"
  end

  create_table "artist_songs", force: :cascade do |t|
    t.integer "artist_id"
    t.integer "song_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id"], name: "index_artist_songs_on_artist_id"
    t.index ["song_id"], name: "index_artist_songs_on_song_id"
  end

  create_table "artists", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "songs", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "url"
    t.text "lossless_url"
    t.date "recorded_date"
    t.integer "album_id"
    t.integer "artist_songs_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "index_songs_on_album_id"
    t.index ["artist_songs_id"], name: "index_songs_on_artist_songs_id"
  end

end

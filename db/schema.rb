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

ActiveRecord::Schema.define(version: 20150508173733) do

  create_table "movies", force: :cascade do |t|
    t.string   "title",             limit: 255
    t.string   "tmdb_id",           limit: 255
    t.string   "imdb_id",           limit: 255
    t.string   "letterboxd_slug",   limit: 255
    t.string   "backdrop_url",      limit: 255
    t.text     "plot",              limit: 65535
    t.string   "trailer_url",       limit: 255
    t.date     "release_date"
    t.integer  "runtime",           limit: 4
    t.float    "letterboxd_rating", limit: 24
    t.float    "imdb_rating",       limit: 24
    t.float    "tmdb_rating",       limit: 24
    t.integer  "budget",            limit: 4
    t.string   "language",          limit: 255
    t.string   "country",           limit: 255
    t.string   "certification",     limit: 255
    t.integer  "metascore",         limit: 4
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "movies", ["budget"], name: "index_movies_on_budget", using: :btree
  add_index "movies", ["certification"], name: "index_movies_on_certification", using: :btree
  add_index "movies", ["country"], name: "index_movies_on_country", using: :btree
  add_index "movies", ["imdb_id"], name: "index_movies_on_imdb_id", unique: true, using: :btree
  add_index "movies", ["imdb_rating"], name: "index_movies_on_imdb_rating", using: :btree
  add_index "movies", ["language"], name: "index_movies_on_language", using: :btree
  add_index "movies", ["letterboxd_rating"], name: "index_movies_on_letterboxd_rating", using: :btree
  add_index "movies", ["letterboxd_slug"], name: "index_movies_on_letterboxd_slug", unique: true, using: :btree
  add_index "movies", ["metascore"], name: "index_movies_on_metascore", using: :btree
  add_index "movies", ["release_date"], name: "index_movies_on_release_date", using: :btree
  add_index "movies", ["runtime"], name: "index_movies_on_runtime", using: :btree
  add_index "movies", ["tmdb_id"], name: "index_movies_on_tmdb_id", unique: true, using: :btree
  add_index "movies", ["tmdb_rating"], name: "index_movies_on_tmdb_rating", using: :btree

end

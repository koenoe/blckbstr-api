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

ActiveRecord::Schema.define(version: 20150522140507) do

  create_table "companies", force: :cascade do |t|
    t.integer  "tmdb_id",    limit: 4
    t.string   "title",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "companies", ["tmdb_id"], name: "index_companies_on_tmdb_id", unique: true, using: :btree

  create_table "countries", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.string   "code",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "countries", ["code"], name: "index_countries_on_code", unique: true, using: :btree

  create_table "genres", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.integer  "tmdb_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "genres", ["title"], name: "index_genres_on_title", using: :btree
  add_index "genres", ["tmdb_id"], name: "index_genres_on_tmdb_id", unique: true, using: :btree

  create_table "languages", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.string   "code",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "languages", ["code"], name: "index_languages_on_code", unique: true, using: :btree

  create_table "movie_companies", id: false, force: :cascade do |t|
    t.integer "company_id", limit: 4
    t.integer "movie_id",   limit: 4
  end

  add_index "movie_companies", ["company_id", "movie_id"], name: "movie_companies_index", unique: true, using: :btree

  create_table "movie_countries", id: false, force: :cascade do |t|
    t.integer "country_id", limit: 4
    t.integer "movie_id",   limit: 4
  end

  add_index "movie_countries", ["country_id", "movie_id"], name: "movie_countries_index", unique: true, using: :btree

  create_table "movie_genres", id: false, force: :cascade do |t|
    t.integer "genre_id", limit: 4
    t.integer "movie_id", limit: 4
  end

  add_index "movie_genres", ["genre_id", "movie_id"], name: "movie_genres_index", unique: true, using: :btree

  create_table "movie_languages", id: false, force: :cascade do |t|
    t.integer "language_id", limit: 4
    t.integer "movie_id",    limit: 4
  end

  add_index "movie_languages", ["language_id", "movie_id"], name: "movie_languages_index", unique: true, using: :btree

  create_table "movie_roles", force: :cascade do |t|
    t.integer  "movie_id",   limit: 4
    t.integer  "person_id",  limit: 4
    t.integer  "role_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "character",  limit: 255
  end

  add_index "movie_roles", ["movie_id", "person_id", "role_id"], name: "movie_roles_index", unique: true, using: :btree
  add_index "movie_roles", ["movie_id"], name: "index_movie_roles_on_movie_id", using: :btree
  add_index "movie_roles", ["person_id"], name: "index_movie_roles_on_person_id", using: :btree
  add_index "movie_roles", ["role_id"], name: "index_movie_roles_on_role_id", using: :btree

  create_table "movie_services", id: false, force: :cascade do |t|
    t.integer "service_id", limit: 4
    t.integer "movie_id",   limit: 4
  end

  add_index "movie_services", ["service_id", "movie_id"], name: "movie_services_index", unique: true, using: :btree

  create_table "movie_views", id: false, force: :cascade do |t|
    t.integer "movie_id", limit: 4
    t.integer "user_id",  limit: 4
  end

  add_index "movie_views", ["movie_id", "user_id"], name: "movie_views_index", unique: true, using: :btree

  create_table "movies", force: :cascade do |t|
    t.string   "title",                 limit: 255
    t.string   "tmdb_id",               limit: 255
    t.string   "imdb_id",               limit: 255
    t.string   "letterboxd_slug",       limit: 255
    t.string   "tmdb_backdrop_path",    limit: 255
    t.text     "plot",                  limit: 65535
    t.string   "trailer_url",           limit: 255
    t.date     "release_date"
    t.integer  "runtime",               limit: 4
    t.float    "letterboxd_rating",     limit: 24
    t.float    "imdb_rating",           limit: 24
    t.float    "tmdb_rating",           limit: 24
    t.integer  "budget",                limit: 4
    t.string   "certification",         limit: 255
    t.integer  "metascore",             limit: 4
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "letterboxd_position",   limit: 4
    t.float    "tmdb_popularity",       limit: 24
    t.string   "tmdb_poster_path",      limit: 255
    t.string   "tagline",               limit: 255
    t.integer  "tmdb_vote_count",       limit: 4
    t.integer  "imdb_vote_count",       limit: 4
    t.integer  "letterboxd_vote_count", limit: 4
    t.integer  "revenue",               limit: 4
    t.integer  "oscars",                limit: 4
    t.integer  "wins",                  limit: 4
    t.integer  "nominations",           limit: 4
  end

  add_index "movies", ["budget"], name: "index_movies_on_budget", using: :btree
  add_index "movies", ["certification"], name: "index_movies_on_certification", using: :btree
  add_index "movies", ["imdb_id"], name: "index_movies_on_imdb_id", unique: true, using: :btree
  add_index "movies", ["imdb_rating"], name: "index_movies_on_imdb_rating", using: :btree
  add_index "movies", ["letterboxd_position"], name: "index_movies_on_letterboxd_position", using: :btree
  add_index "movies", ["letterboxd_rating"], name: "index_movies_on_letterboxd_rating", using: :btree
  add_index "movies", ["letterboxd_slug"], name: "index_movies_on_letterboxd_slug", unique: true, using: :btree
  add_index "movies", ["metascore"], name: "index_movies_on_metascore", using: :btree
  add_index "movies", ["release_date"], name: "index_movies_on_release_date", using: :btree
  add_index "movies", ["runtime"], name: "index_movies_on_runtime", using: :btree
  add_index "movies", ["tmdb_id"], name: "index_movies_on_tmdb_id", unique: true, using: :btree
  add_index "movies", ["tmdb_popularity"], name: "index_movies_on_tmdb_popularity", using: :btree
  add_index "movies", ["tmdb_rating"], name: "index_movies_on_tmdb_rating", using: :btree

  create_table "people", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "place_of_birth",    limit: 255
    t.date     "birthdate"
    t.date     "deathdate"
    t.string   "tmdb_profile_path", limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "tmdb_id",           limit: 4
  end

  add_index "people", ["tmdb_id"], name: "index_people_on_tmdb_id", unique: true, using: :btree

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id", limit: 4
    t.integer  "followed_id", limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "roles", ["title"], name: "index_roles_on_title", using: :btree

  create_table "services", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "slug",       limit: 255
  end

  add_index "services", ["slug"], name: "index_services_on_slug", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "letterboxd_username", limit: 255
    t.string   "imdb_username",       limit: 255
    t.string   "tmdb_username",       limit: 255
    t.string   "name",                limit: 255
    t.string   "email",               limit: 255
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "sync_status",         limit: 4
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["imdb_username"], name: "index_users_on_imdb_username", unique: true, using: :btree
  add_index "users", ["letterboxd_username"], name: "index_users_on_letterboxd_username", unique: true, using: :btree
  add_index "users", ["sync_status"], name: "index_users_on_sync_status", using: :btree
  add_index "users", ["tmdb_username"], name: "index_users_on_tmdb_username", unique: true, using: :btree

  create_table "watchlists", id: false, force: :cascade do |t|
    t.integer "movie_id", limit: 4
    t.integer "user_id",  limit: 4
  end

  add_index "watchlists", ["movie_id", "user_id"], name: "watchlists_index", unique: true, using: :btree

  add_foreign_key "movie_roles", "movies"
  add_foreign_key "movie_roles", "people"
  add_foreign_key "movie_roles", "roles"
end

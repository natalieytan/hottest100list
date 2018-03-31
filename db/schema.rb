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

ActiveRecord::Schema.define(version: 20180330115118) do

  create_table "songs", force: :cascade do |t|
    t.integer "year"
    t.integer "rank"
    t.string "title"
    t.string "artist"
    t.string "country"
    t.string "videoid"
    t.string "image"
    t.string "title_slug"
    t.string "country_slug"
    t.string "artist_slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

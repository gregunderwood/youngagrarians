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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130915213759) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "locations", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps"
    t.string   "address"
    t.string   "name"
    t.text     "content"
    t.string   "bioregion"
    t.string   "phone"
    t.string   "url"
    t.string   "fb_url"
    t.string   "twitter_url"
    t.text     "description"
    t.boolean  "is_approved",    :default => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "category_id"
    t.string   "resource_type"
    t.string   "email"
    t.string   "postal"
    t.date     "show_until"
    t.string   "street_address"
    t.string   "city"
    t.string   "country_code"
    t.string   "country_name"
    t.string   "province_code"
    t.string   "province_name"
  end

  add_index "locations", ["is_approved"], :name => "index_locations_on_is_approved"
  add_index "locations", ["show_until"], :name => "index_locations_on_show_until"

  create_table "locations_subcategories", :id => false, :force => true do |t|
    t.integer "location_id"
    t.integer "subcategory_id"
  end

  create_table "subcategories", :force => true do |t|
    t.integer  "category_id"
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "email"
    t.string   "password_salt"
    t.string   "encrypted_password"
    t.string   "password_reset_key"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

end

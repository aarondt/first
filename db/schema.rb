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

ActiveRecord::Schema.define(version: 20160513152021) do

  create_table "searches", force: :cascade do |t|
    t.string   "keywords"
    t.string   "category"
    t.decimal  "min_price"
    t.decimal  "max_price"
    t.decimal  "vintage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shops", force: :cascade do |t|
    t.string   "shop_name"
    t.string   "shop_logo"
    t.string   "shop_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "weins", force: :cascade do |t|
    t.string   "name"
    t.string   "image_url"
    t.float    "price"
    t.string   "source_link"
    t.string   "vintage"
    t.string   "category"
    t.string   "prod_title"
    t.string   "prod_desc"
    t.string   "prod_inhalt"
    t.string   "prod_alcgehalt"
    t.string   "prod_geschmack"
    t.string   "prod_mhd"
    t.string   "prod_verschluss"
    t.string   "prod_winemaker"
    t.string   "prod_trinktemp"
    t.string   "prod_anbaugebiet"
    t.string   "prod_herstellerfirma"
    t.string   "prod_abfueller"
    t.string   "prod_allergene"
    t.string   "prod_rebsorte"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "shop_id"
  end

  add_index "weins", ["shop_id"], name: "index_weins_on_shop_id"

end

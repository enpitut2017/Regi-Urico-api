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

ActiveRecord::Schema.define(version: 20171228164606) do

  create_table "event_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "price"
    t.bigint "item_id"
    t.bigint "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deleted", default: false
    t.index ["event_id"], name: "index_event_items_on_event_id"
    t.index ["item_id"], name: "index_event_items_on_item_id"
  end

  create_table "events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "seller_id"
    t.index ["seller_id"], name: "index_events_on_seller_id"
  end

  create_table "items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "seller_id"
    t.index ["seller_id"], name: "index_items_on_seller_id"
  end

  create_table "logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "event_item_id"
    t.integer "diff_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "sales_log_id"
    t.index ["event_item_id"], name: "index_logs_on_event_item_id"
    t.index ["sales_log_id"], name: "index_logs_on_sales_log_id"
  end

  create_table "sales_logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "event_id"
    t.integer "deposit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_sales_logs_on_event_id"
  end

  create_table "sellers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "token"
    t.bigint "twitter_id"
    t.string "twitter_name"
    t.string "twitter_screen_name"
    t.string "twitter_image_url"
    t.string "twitter_token"
    t.string "twitter_secret"
  end

  add_foreign_key "events", "sellers"
  add_foreign_key "items", "sellers"
  add_foreign_key "logs", "event_items"
  add_foreign_key "logs", "sales_logs"
  add_foreign_key "sales_logs", "events"
end

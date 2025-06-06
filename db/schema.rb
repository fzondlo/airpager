# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_05_01_160003) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "incidents", force: :cascade do |t|
    t.jsonb "source_details"
    t.string "status", default: "created", null: false
    t.string "kind", null: false
    t.datetime "alerted_at"
    t.datetime "resolved_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "resolved_by"
  end

  create_table "messages", force: :cascade do |t|
    t.string "conversation_id", null: false
    t.string "reservation_id"
    t.string "sender_role"
    t.string "sender_full_name"
    t.text "content"
    t.datetime "posted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sender_type"
  end

  create_table "open_ai_requests", force: :cascade do |t|
    t.text "prompt"
    t.text "answer"
    t.jsonb "response_payload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end

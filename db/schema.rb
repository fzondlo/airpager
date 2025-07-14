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

ActiveRecord::Schema[8.0].define(version: 2025_07_11_220054) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "auto_replies", force: :cascade do |t|
    t.text "trigger"
    t.text "reply"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "auto_reply_properties", force: :cascade do |t|
    t.bigint "auto_reply_id", null: false
    t.bigint "property_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auto_reply_id", "property_id"], name: "index_auto_reply_properties_on_auto_reply_id_and_property_id", unique: true
    t.index ["auto_reply_id"], name: "index_auto_reply_properties_on_auto_reply_id"
    t.index ["property_id"], name: "index_auto_reply_properties_on_property_id"
  end

  create_table "incident_escalations", force: :cascade do |t|
    t.bigint "incident_id", null: false
    t.string "token", null: false
    t.datetime "triggered_at"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["incident_id"], name: "index_incident_escalations_on_incident_id"
    t.index ["token"], name: "index_incident_escalations_on_token", unique: true
  end

  create_table "incidents", force: :cascade do |t|
    t.jsonb "source_details"
    t.string "status", default: "created", null: false
    t.string "kind", null: false
    t.datetime "alerted_at"
    t.datetime "resolved_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "resolved_by"
    t.string "urgency_level"
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

  create_table "properties", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.text "address"
    t.string "clickup_custom_field_id", null: false
    t.string "google_maps_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hospitable_id"
    t.index ["clickup_custom_field_id"], name: "index_properties_on_clickup_custom_field_id", unique: true
    t.index ["hospitable_id"], name: "index_properties_on_hospitable_id", unique: true
    t.index ["slug"], name: "index_properties_on_slug", unique: true
  end

  add_foreign_key "auto_reply_properties", "auto_replies"
  add_foreign_key "auto_reply_properties", "properties"
  add_foreign_key "incident_escalations", "incidents"
end

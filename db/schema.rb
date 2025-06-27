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

ActiveRecord::Schema.define(version: 2025_06_24_174526) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "role_id", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_admins_on_role_id"
  end

  create_table "api_calls", force: :cascade do |t|
    t.string "url"
    t.string "response_code"
    t.integer "response_time"
    t.integer "method"
    t.text "data"
    t.text "response_data"
    t.bigint "response_size"
    t.integer "origin"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "banneds", force: :cascade do |t|
    t.string "document"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "codes", force: :cascade do |t|
    t.string "value"
    t.bigint "product_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.boolean "used", default: false, null: false
    t.index ["product_id"], name: "index_codes_on_product_id"
    t.index ["used"], name: "index_codes_on_used"
    t.index ["value"], name: "index_codes_on_value", unique: true
  end

  create_table "conversations", force: :cascade do |t|
    t.string "contact"
    t.bigint "last_message_id"
    t.bigint "participant_id"
    t.datetime "last_message_at"
    t.string "source_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["contact"], name: "index_conversations_on_contact", unique: true
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.integer "quantity", default: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "conversation_id"
    t.string "body"
    t.string "response"
    t.string "kind"
    t.string "uuid"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["uuid"], name: "index_messages_on_uuid", unique: true
  end

  create_table "participants", force: :cascade do |t|
    t.string "full_name"
    t.string "contact"
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "document"
    t.boolean "opt_out", default: false, null: false
    t.boolean "received_template", default: false
    t.integer "age", default: 0, null: false
    t.bigint "state_id"
    t.integer "participations_count", default: 0, null: false
    t.index ["age"], name: "index_participants_on_age"
    t.index ["state_id"], name: "index_participants_on_state_id"
  end

  create_table "participations", force: :cascade do |t|
    t.bigint "participant_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "code_str"
    t.bigint "code_id"
    t.index ["code_id"], name: "index_participations_on_code_id"
    t.index ["participant_id"], name: "index_participations_on_participant_id"
  end

  create_table "prizes", force: :cascade do |t|
    t.string "name", null: false
    t.integer "quantity", null: false
    t.boolean "active", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "position", default: 999
    t.integer "step", default: 0
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "category_id", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.boolean "admin_create", default: false
    t.boolean "admin_read", default: false
    t.boolean "admin_update", default: false
    t.boolean "admin_delete", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "role_create"
    t.boolean "role_read"
    t.boolean "role_update"
    t.boolean "role_delete"
    t.boolean "prize_create"
    t.boolean "prize_read"
    t.boolean "prize_update"
    t.boolean "prize_delete"
    t.boolean "participant_read"
    t.boolean "participant_create"
    t.boolean "participant_update"
    t.boolean "participant_delete"
    t.boolean "participation_read"
    t.boolean "participation_create"
    t.boolean "participation_update"
    t.boolean "participation_delete"
    t.boolean "winner_read"
    t.boolean "winner_create"
    t.boolean "winner_update"
    t.boolean "winner_delete"
    t.boolean "banned_read"
    t.boolean "banned_create"
    t.boolean "banned_update"
    t.boolean "banned_delete"
    t.boolean "code_read", default: false
    t.boolean "code_update", default: false
    t.boolean "code_create", default: false
    t.boolean "code_delete", default: false
    t.boolean "state_create", default: false
    t.boolean "state_read", default: false
    t.boolean "state_update", default: false
    t.boolean "state_delete", default: false
  end

  create_table "settings", force: :cascade do |t|
    t.string "name"
    t.datetime "date_start"
    t.datetime "date_end"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "active", default: false
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "active", default: true
  end

  create_table "winners", force: :cascade do |t|
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "used", default: false
    t.bigint "participant_id", null: false
    t.bigint "prize_id"
    t.index ["participant_id"], name: "index_winners_on_participant_id"
    t.index ["prize_id"], name: "index_winners_on_prize_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "admins", "roles"
  add_foreign_key "codes", "products"
  add_foreign_key "participants", "states"
  add_foreign_key "participations", "codes"
  add_foreign_key "participations", "participants"
  add_foreign_key "products", "categories"
  add_foreign_key "winners", "participants"
  add_foreign_key "winners", "prizes"
end

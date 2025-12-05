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

ActiveRecord::Schema[8.1].define(version: 2025_12_05_182124) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "curatelado_curators", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "curatelado_id", null: false
    t.boolean "is_owner", default: false, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["curatelado_id", "user_id"], name: "index_curatelado_curators_on_curatelado_id_and_user_id", unique: true
    t.index ["curatelado_id"], name: "index_curatelado_curators_on_curatelado_id"
    t.index ["user_id"], name: "index_curatelado_curators_on_user_id"
  end

  create_table "curatelados", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_curatelados_on_name"
  end

  create_table "partners", force: :cascade do |t|
    t.string "cpf_cnpj", null: false
    t.datetime "created_at", null: false
    t.integer "curatelado_id"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["cpf_cnpj"], name: "index_partners_on_cpf_cnpj"
    t.index ["curatelado_id", "cpf_cnpj"], name: "index_partners_on_curatelado_id_and_cpf_cnpj", unique: true
    t.index ["curatelado_id"], name: "index_partners_on_curatelado_id"
    t.index ["name"], name: "index_partners_on_name"
  end

  create_table "payment_reimbursements", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "payment_id", null: false
    t.integer "reimbursement_id", null: false
    t.datetime "updated_at", null: false
    t.index ["payment_id", "reimbursement_id"], name: "index_payment_reimbursements_unique", unique: true
    t.index ["payment_id"], name: "index_payment_reimbursements_on_payment_id"
    t.index ["reimbursement_id"], name: "index_payment_reimbursements_on_reimbursement_id"
  end

  create_table "payments", force: :cascade do |t|
    t.string "cpf_cnpj"
    t.datetime "created_at", null: false
    t.integer "curatelado_id"
    t.integer "curator_id"
    t.date "date", null: false
    t.text "description"
    t.integer "partner_id"
    t.string "partner_name"
    t.string "payment_method"
    t.integer "primary_classification_id", null: false
    t.string "reimbursement_code"
    t.integer "secondary_classification_id", null: false
    t.datetime "updated_at", null: false
    t.decimal "value", precision: 10, scale: 2, null: false
    t.index ["cpf_cnpj"], name: "index_payments_on_cpf_cnpj"
    t.index ["curatelado_id"], name: "index_payments_on_curatelado_id"
    t.index ["curator_id"], name: "index_payments_on_curator_id"
    t.index ["date"], name: "index_payments_on_date"
    t.index ["partner_id"], name: "index_payments_on_partner_id"
    t.index ["partner_name"], name: "index_payments_on_partner_name"
    t.index ["primary_classification_id"], name: "index_payments_on_primary_classification_id"
    t.index ["reimbursement_code"], name: "index_payments_on_reimbursement_code"
    t.index ["secondary_classification_id"], name: "index_payments_on_secondary_classification_id"
  end

  create_table "primary_classifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "curatelado_id"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["curatelado_id"], name: "index_primary_classifications_on_curatelado_id"
    t.index ["name"], name: "index_primary_classifications_on_name", unique: true
  end

  create_table "reimbursements", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.integer "curatelado_id"
    t.integer "curator_id"
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_reimbursements_on_code", unique: true
    t.index ["curatelado_id"], name: "index_reimbursements_on_curatelado_id"
    t.index ["curator_id"], name: "index_reimbursements_on_curator_id"
  end

  create_table "secondary_classifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "curatelado_id"
    t.string "name", null: false
    t.integer "primary_classification_id", null: false
    t.datetime "updated_at", null: false
    t.index ["curatelado_id"], name: "index_secondary_classifications_on_curatelado_id"
    t.index ["primary_classification_id", "name"], name: "index_secondary_on_primary_and_name", unique: true
    t.index ["primary_classification_id"], name: "index_secondary_classifications_on_primary_classification_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "curatelado_curators", "curatelados"
  add_foreign_key "curatelado_curators", "users"
  add_foreign_key "partners", "curatelados"
  add_foreign_key "payment_reimbursements", "payments"
  add_foreign_key "payment_reimbursements", "reimbursements"
  add_foreign_key "payments", "curatelados"
  add_foreign_key "payments", "partners"
  add_foreign_key "payments", "primary_classifications"
  add_foreign_key "payments", "secondary_classifications"
  add_foreign_key "payments", "users", column: "curator_id"
  add_foreign_key "primary_classifications", "curatelados"
  add_foreign_key "reimbursements", "curatelados"
  add_foreign_key "reimbursements", "users", column: "curator_id"
  add_foreign_key "secondary_classifications", "curatelados"
  add_foreign_key "secondary_classifications", "primary_classifications"
end

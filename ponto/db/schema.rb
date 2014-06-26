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

ActiveRecord::Schema.define(version: 20140626115923) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "departments", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "leader_id"
  end

  add_index "departments", ["leader_id"], name: "index_departments_on_leader_id", using: :btree

  create_table "employees", force: true do |t|
    t.string   "name",                                null: false
    t.integer  "department_id",                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "overtime_bank_balance", default: 0.0, null: false
  end

  add_index "employees", ["department_id"], name: "index_employees_on_department_id", using: :btree

  create_table "holidays", force: true do |t|
    t.date     "date",       null: false
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "holidays", ["date"], name: "index_holidays_on_date", unique: true, using: :btree

  create_table "overtime_bank_payments", force: true do |t|
    t.integer  "employee_id", null: false
    t.decimal  "paid_time",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "overtime_bank_payments", ["employee_id"], name: "index_overtime_bank_payments_on_employee_id", using: :btree

  create_table "record_groups", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "record_inconsistencies", force: true do |t|
    t.integer  "record_id",  null: false
    t.string   "kind",       null: false
    t.string   "status",     null: false
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "record_inconsistencies", ["record_id"], name: "index_record_inconsistencies_on_record_id", using: :btree

  create_table "records", force: true do |t|
    t.integer  "employee_id",              null: false
    t.date     "date",                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id",                 null: false
    t.time     "times",       default: [], null: false, array: true
  end

  add_index "records", ["employee_id"], name: "index_records_on_employee_id", using: :btree
  add_index "records", ["group_id"], name: "index_records_on_group_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",              default: "", null: false
    t.string   "encrypted_password", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employee_id",                     null: false
    t.string   "role",                            null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["employee_id"], name: "index_users_on_employee_id", using: :btree

  add_foreign_key "departments", "employees", name: "departments_leader_id_fk", column: "leader_id"

  add_foreign_key "employees", "departments", name: "employees_department_id_fk"

  add_foreign_key "overtime_bank_payments", "employees", name: "overtime_bank_payments_employee_id_fk", dependent: :delete

  add_foreign_key "record_inconsistencies", "records", name: "record_inconsistencies_record_id_fk", dependent: :delete

  add_foreign_key "records", "employees", name: "records_employee_id_fk", dependent: :delete
  add_foreign_key "records", "record_groups", name: "records_group_id_fk", column: "group_id", dependent: :delete

  add_foreign_key "users", "employees", name: "users_employee_id_fk", dependent: :delete

end

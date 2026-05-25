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

ActiveRecord::Schema[8.0].define(version: 2026_04_28_135314) do
  create_table "academic_periods", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_academic_periods_on_name", unique: true
    t.index ["status"], name: "index_academic_periods_on_status"
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
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "administrativos", force: :cascade do |t|
    t.string "name"
    t.string "apellido"
    t.string "name2"
    t.string "apellido2"
    t.integer "cedula"
    t.date "birthday"
    t.string "direccion"
    t.integer "telefono"
    t.string "cargo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ministerio_id"
  end

  create_table "alumnos", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "apellido"
    t.string "name2"
    t.string "apellido2"
    t.integer "representante_id"
    t.date "birthday"
    t.string "representante_secundario_id"
  end

  create_table "asignaturas", force: :cascade do |t|
    t.string "nombre_asignatura"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "nivel_id", default: 1, null: false
    t.string "codigo_asignatura"
    t.index ["codigo_asignatura"], name: "index_asignaturas_on_codigo_asignatura", unique: true
    t.index ["nivel_id"], name: "index_asignaturas_on_nivel_id"
  end

  create_table "attendances", force: :cascade do |t|
    t.integer "alumno_id", null: false
    t.date "fecha"
    t.boolean "presente"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alumno_id"], name: "index_attendances_on_alumno_id"
  end

  create_table "cargos", force: :cascade do |t|
    t.string "nombre_cargo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "docentes", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name2"
    t.string "apellido"
    t.string "apellido2"
    t.integer "cedula"
    t.date "birthday"
    t.string "direccion"
    t.integer "telefono"
    t.string "ministerio_id"
  end

  create_table "enrollments", force: :cascade do |t|
    t.integer "academic_period_id", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "alumno_id", null: false
    t.integer "seccion_id", null: false
    t.index ["alumno_id", "academic_period_id"], name: "index_enrollments_on_alumno_and_period", unique: true
    t.index ["alumno_id"], name: "index_enrollments_on_alumno_id"
    t.index ["seccion_id"], name: "index_enrollments_on_seccion_id"
  end

  create_table "niveles", force: :cascade do |t|
    t.string "nombre_nivel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nombre_nivel"], name: "index_niveles_on_nombre_nivel", unique: true
  end

  create_table "obreros", force: :cascade do |t|
    t.string "name"
    t.string "apellido"
    t.string "name2"
    t.string "apellido2"
    t.integer "cedula"
    t.date "birthday"
    t.string "direccion"
    t.integer "telefono"
    t.string "cargo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ministerio_id"
  end

  create_table "representantes", force: :cascade do |t|
    t.string "name"
    t.string "apellido"
    t.string "name2"
    t.string "apellido2"
    t.integer "cedula"
    t.string "direccion"
    t.integer "telefono"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "birthday"
    t.index ["cedula"], name: "index_representantes_on_cedula", unique: true
  end

  create_table "scores", force: :cascade do |t|
    t.integer "asignatura_id"
    t.integer "nota"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "enrollment_id"
    t.integer "lapso"
    t.index ["enrollment_id", "asignatura_id", "lapso"], name: "unique_score_index", unique: true
    t.index ["enrollment_id"], name: "index_scores_on_enrollment_id"
  end

  create_table "seccions", force: :cascade do |t|
    t.string "nombre_seccion"
    t.integer "numero_salon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "docente_id"
    t.integer "nivel_id", null: false
    t.integer "capacidad", default: 30
    t.index ["docente_id"], name: "index_seccions_on_docente_id"
    t.index ["nivel_id"], name: "index_seccions_on_nivel_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.integer "person_id"
    t.string "person_type"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "alumnos", "representantes", primary_key: "cedula"
  add_foreign_key "asignaturas", "niveles"
  add_foreign_key "attendances", "alumnos"
  add_foreign_key "enrollments", "academic_periods"
  add_foreign_key "enrollments", "alumnos"
  add_foreign_key "enrollments", "seccions"
  add_foreign_key "scores", "asignaturas"
  add_foreign_key "scores", "enrollments"
  add_foreign_key "seccions", "docentes"
  add_foreign_key "seccions", "niveles"
  add_foreign_key "sessions", "users"
end

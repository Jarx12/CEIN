class CreateEnrollments < ActiveRecord::Migration[8.0]
  def change
    create_table :enrollments do |t|
      t.references :student, null: false, foreign_key: true
      t.references :academic_period, null: false, foreign_key: true
      t.string :grade_level
      t.string :section
      t.integer :status

      t.timestamps
    end
    add_index :enrollments, [:student_id, :academic_period_id], unique: true
  end
end

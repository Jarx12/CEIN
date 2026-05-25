class RemoveGhostUniqueIndex < ActiveRecord::Migration[8.0]
  def change
    remove_index :enrollments, name: "index_enrollments_on_student_id_and_academic_period_id"
  end
end
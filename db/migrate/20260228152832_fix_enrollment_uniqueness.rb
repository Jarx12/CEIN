class FixEnrollmentUniqueness < ActiveRecord::Migration[8.0]
  def change
    if index_exists?(:enrollments, :academic_period_id, name: "index_enrollments_on_academic_period_id")
      remove_index :enrollments, name: "index_enrollments_on_academic_period_id"
    end

    # Add composite index
    add_index :enrollments, [:alumno_id, :academic_period_id], unique: true, name: "index_enrollments_on_alumno_and_period"
  end
end
class RemoveGradeLevelFromEnrollments < ActiveRecord::Migration[8.0]
  def change
    remove_column :enrollments, :grade_level, :string
  end
end

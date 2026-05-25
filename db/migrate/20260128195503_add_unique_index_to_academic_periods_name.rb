class AddUniqueIndexToAcademicPeriodsName < ActiveRecord::Migration[8.0]
  def change
    add_index :academic_periods, :name, unique: true
  end
end

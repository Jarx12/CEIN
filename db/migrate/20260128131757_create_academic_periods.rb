class CreateAcademicPeriods < ActiveRecord::Migration[8.0]
  def change
    create_table :academic_periods do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.integer :status, default: 0

      t.timestamps
    end
    add_index :academic_periods, :status
  end
end

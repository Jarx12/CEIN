class CreateAttendances < ActiveRecord::Migration[8.0]
  def change
    create_table :attendances do |t|
      t.references :alumno, null: false, foreign_key: true
      t.date :fecha
      t.boolean :presente

      t.timestamps
    end
  end
end

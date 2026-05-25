class CreateScores < ActiveRecord::Migration[8.0]
  def change
    create_table :scores do |t|
      t.integer :id_alumno
      t.integer :id_asignatura
      t.integer :nota
      t.datetime :periodo

      t.timestamps
    end
  end
end

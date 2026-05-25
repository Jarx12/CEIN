class AddForeignKeyToScores < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :scores, :alumnos
    add_foreign_key :scores, :asignaturas
  end
end

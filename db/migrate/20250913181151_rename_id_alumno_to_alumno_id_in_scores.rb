class RenameIdAlumnoToAlumnoIdInScores < ActiveRecord::Migration[8.0]
  def change
    rename_column :scores, :id_alumno, :alumno_id
    rename_column :scores, :id_asignatura, :asignatura_id
    rename_column :scores, :periodo, :periodo_id
  end
end
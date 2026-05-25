class RestoreCursoToAlumno < ActiveRecord::Migration[8.0]
  def change
    add_column :alumnos, :curso_id, :string
  end
end

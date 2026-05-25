class RemoveCursoIdFromAlumnos < ActiveRecord::Migration[8.0]
  def change
    remove_column :alumnos, :curso_id, :integer
  end
end

class RemoveSeccionIdFromAlumnos < ActiveRecord::Migration[8.0]
  def change
    remove_column :alumnos, :seccion_id, :integer
  end
end
class AddNivelAndCodigoToAsignaturas < ActiveRecord::Migration[8.0]
  def change
    add_reference :asignaturas, :nivel, null: false, foreign_key: true, default: 1
    add_column :asignaturas, :codigo_asignatura, :string
    add_index :asignaturas, :codigo_asignatura, unique: true
  end
end

class AddExtraCamposToAlumno < ActiveRecord::Migration[8.0]
  def change
    add_column :alumnos, :name2, :string
    add_column :alumnos, :apellido2, :string
    add_column :alumnos, :representante_id, :integer
    add_column :alumnos, :birthday, :date
    add_column :alumnos, :curso_id, :integer
  end
end

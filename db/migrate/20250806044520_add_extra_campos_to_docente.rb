class AddExtraCamposToDocente < ActiveRecord::Migration[8.0]
  def change
    add_column :docentes, :name2, :string
    add_column :docentes, :apellido, :string
    add_column :docentes, :apellido2, :string
    add_column :docentes, :cedula, :integer
    add_column :docentes, :birthday, :date
    add_column :docentes, :direccion, :string
    add_column :docentes, :telefono, :integer
  end
end

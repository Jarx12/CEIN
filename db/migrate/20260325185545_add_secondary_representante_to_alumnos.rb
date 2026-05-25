class AddSecondaryRepresentanteToAlumnos < ActiveRecord::Migration[8.0]
  def change
    add_column :alumnos, :representante_secundario_id, :string
  end
end

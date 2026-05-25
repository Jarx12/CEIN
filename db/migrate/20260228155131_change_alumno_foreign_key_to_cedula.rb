class ChangeAlumnoForeignKeyToCedula < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :alumnos, :representantes if foreign_key_exists?(:alumnos, :representantes)
    add_foreign_key :alumnos, :representantes, 
                    column: :representante_id, 
                    primary_key: :cedula
  end
end
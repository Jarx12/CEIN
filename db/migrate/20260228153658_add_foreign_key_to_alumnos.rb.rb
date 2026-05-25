class AddForeignKeyToAlumnos < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :alumnos, :representantes, column: :representante_id
  end
end
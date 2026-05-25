class AddUniqueIndexToNivelesNombre < ActiveRecord::Migration[8.0]
  def change
    add_index :niveles, :nombre_nivel, unique: true
  end
end
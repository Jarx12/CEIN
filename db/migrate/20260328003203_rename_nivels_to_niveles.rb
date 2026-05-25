class RenameNivelsToNiveles < ActiveRecord::Migration[8.0]
  def change
    rename_table :nivels, :niveles
  end
end
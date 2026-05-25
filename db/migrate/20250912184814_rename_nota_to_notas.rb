class RenameNotaToNotas < ActiveRecord::Migration[7.0]
  def change
    rename_table :nota, :notas
  end
end
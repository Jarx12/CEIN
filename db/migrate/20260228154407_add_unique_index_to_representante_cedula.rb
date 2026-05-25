class AddUniqueIndexToRepresentanteCedula < ActiveRecord::Migration[8.0]
  def change
    add_index :representantes, :cedula, unique: true
  end
end
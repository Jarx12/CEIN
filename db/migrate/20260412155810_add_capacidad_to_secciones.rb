class AddCapacidadToSecciones < ActiveRecord::Migration[8.0]
  def change
    add_column :seccions, :capacidad, :integer, default: 30
  end
end

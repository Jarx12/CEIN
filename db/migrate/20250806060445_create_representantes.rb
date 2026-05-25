class CreateRepresentantes < ActiveRecord::Migration[8.0]
  def change
    create_table :representantes do |t|
      t.string :name
      t.string :apellido
      t.string :name2
      t.string :apellido2
      t.integer :cedula
      t.string :direccion
      t.integer :telefono
      t.timestamps
    end
  end
end

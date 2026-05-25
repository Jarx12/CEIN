class CreateAdministrativos < ActiveRecord::Migration[8.0]
  def change
    create_table :administrativos do |t|
      t.string :name
      t.string :apellido
      t.string :name2
      t.string :apellido2
      t.integer :cedula
      t.date :birthday
      t.string :direccion
      t.integer :telefono
      t.string :cargo
      t.timestamps
    end
  end
end

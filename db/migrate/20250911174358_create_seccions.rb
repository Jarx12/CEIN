class CreateSeccions < ActiveRecord::Migration[8.0]
  def change
    create_table :seccions do |t|
      t.string :nombre_seccion
      t.integer :numero_salon
      t.string :dependencia

      t.timestamps
    end
  end
end

class CreateAlumnos < ActiveRecord::Migration[8.0]
  def change
    create_table :alumnos do |t|
      t.string :name
      t.string :apellido
      t.timestamps
    end
  end
end

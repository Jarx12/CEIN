class CreateNivels < ActiveRecord::Migration[8.0]
  def change
    create_table :nivels do |t|
      t.string :nombre_nivel

      t.timestamps
    end
  end
end

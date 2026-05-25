class CreateDocentes < ActiveRecord::Migration[8.0]
  def change
    create_table :docentes do |t|
      t.string :name

      t.timestamps
    end
  end
end

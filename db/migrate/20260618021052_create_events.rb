class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.date :event_date, null: false
      t.string :event_time
      t.string :location
      t.integer :category, default: 0, null: false # Para manejar Convocatoria, Institucional, etc.

      t.timestamps
    end
  end
end

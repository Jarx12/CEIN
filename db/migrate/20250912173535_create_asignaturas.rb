class CreateAsignaturas < ActiveRecord::Migration[8.0]
  def change
    create_table :asignaturas do |t|
      t.string :nombre_asignatura

      t.timestamps
    end
  end
end

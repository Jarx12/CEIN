class AddSeccionToEnrollments < ActiveRecord::Migration[8.0]
  def change
    # Agregar la columna seccion_id y vincular con la tabla secciones
    add_reference :enrollments, :seccion, null: false, foreign_key: { to_table: :seccions }
    
    # Borrar la columna vieja que era string para no confundir
    remove_column :enrollments, :section, :string if column_exists?(:enrollments, :section)
  end
end
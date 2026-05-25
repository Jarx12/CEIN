class UpdateScoresToUseEnrollment < ActiveRecord::Migration[8.0]
  def change
    add_reference :scores, :enrollment, foreign_key: true
    # Opcional: Si quieres limpiar tu tabla vieja, podrías eliminar 
    # alumno_id y periodo_id después de migrar los datos.
    remove_column :scores, :alumno_id
    remove_column :scores, :periodo_id
  end
end

class AddMinisterioIdToStaff < ActiveRecord::Migration[8.0]
  def change
    add_column :docentes, :ministerio_id, :string
    add_column :administrativos, :ministerio_id, :string
    add_column :obreros, :ministerio_id, :string
  end
end

class RenameCargoToCargoIdInAdministrativoAndObrero < ActiveRecord::Migration[8.0]
  def change
    rename_column :administrativos, :cargo, :cargo_id
    rename_column :obreros, :cargo, :cargo_id
  end
end

class AddExtraCamposToRepresentante < ActiveRecord::Migration[8.0]
  def change
    add_column :representantes, :birthday, :date
  end
end

class AddRoleAndPersonToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :role, :integer
    add_column :users, :person_id, :integer
    add_column :users, :person_type, :string
  end
end

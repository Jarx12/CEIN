class AddApprovalStatusToEnrollments < ActiveRecord::Migration[8.0]
  def change
    add_column :enrollments, :approval_status, :integer, default: 0, null: false
    add_index :enrollments, :approval_status
  end
end

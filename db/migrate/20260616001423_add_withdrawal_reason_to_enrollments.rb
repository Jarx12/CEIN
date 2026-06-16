class AddWithdrawalReasonToEnrollments < ActiveRecord::Migration[8.0]
  def change
    add_column :enrollments, :withdrawal_reason, :integer
  end
end

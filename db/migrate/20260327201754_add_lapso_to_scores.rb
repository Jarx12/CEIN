class AddLapsoToScores < ActiveRecord::Migration[8.0]
  def change
    add_column :scores, :lapso, :integer
  end
end

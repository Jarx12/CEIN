class AddUniqueIndexToScores < ActiveRecord::Migration[8.0]
  def change
    add_index :scores, [:enrollment_id, :asignatura_id, :lapso], unique: true, name: 'unique_score_index'
  end
end

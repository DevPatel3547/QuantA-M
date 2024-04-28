class ChangeActivityParticipationsStatusToInteger < ActiveRecord::Migration[7.0]
  def change
    remove_column :activity_participations, :status
    add_column :activity_participations, :status, :integer
  end
end

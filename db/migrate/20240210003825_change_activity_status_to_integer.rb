class ChangeActivityStatusToInteger < ActiveRecord::Migration[7.0]
  def change
    remove_column :activities, :status, :string
    add_column :activities, :status, :integer
  end
end

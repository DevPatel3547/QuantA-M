class AddAdditionalActivityFields < ActiveRecord::Migration[7.0]
  def change
    add_column :activities, :location, :string
    add_column :activities, :passcode_valid_at, :timestamp
    add_column :activities, :passcode_valid_end, :timestamp
    add_column :activities, :points, :integer
  end
end

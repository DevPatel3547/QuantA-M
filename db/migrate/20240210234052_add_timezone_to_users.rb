class AddTimezoneToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :timezone, :string, default: 'Central Time (US & Canada)'
  end
end

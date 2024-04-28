class CreateActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :activities, id: :bigserial do |t|
      t.references :activity_type, foreign_key: true
      t.string :title
      t.text :description
      t.timestamp :start_time
      t.timestamp :end_time
      t.string :status
      t.integer :passcode
      t.timestamps
    end
  end
end
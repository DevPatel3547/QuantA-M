class CreateActivityParticipations < ActiveRecord::Migration[7.0]
  def change
    create_table :activity_participations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :activity, null: false, foreign_key: true
      t.text :status
      t.boolean :attended

      t.timestamps
    end
  end
end

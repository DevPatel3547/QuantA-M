class CreateActivityTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :activity_types, id: :bigserial do |t|
      t.string :title

      t.timestamps
    end
  end
end

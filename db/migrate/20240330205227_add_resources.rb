class AddResources < ActiveRecord::Migration[7.0]
  def change
    create_table :article_categories do |t|
      t.string :name

      t.timestamps
    end

    create_table :article_modules do |t|
      t.string :name

      t.timestamps
    end

    create_table :articles do |t|
      t.string :title
      t.text :body
      t.references :article_category, null: true, foreign_key: true
      t.references :article_module, null: true, foreign_key: true

      t.timestamps
    end
  end
end

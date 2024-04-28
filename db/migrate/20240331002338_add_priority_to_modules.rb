class AddPriorityToModules < ActiveRecord::Migration[7.0]
  def change
    add_column :article_modules, :priority, :integer, default: 0
  end
end

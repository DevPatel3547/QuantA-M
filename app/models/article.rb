class Article < ActiveRecord::Base
  belongs_to :article_category
  belongs_to :article_module

  validates :title, presence: true
  validates :body, presence: true
  validates :article_category_id, presence: true
  validates :article_module_id, presence: true
end

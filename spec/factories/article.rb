FactoryBot.define do
  factory :article do
    article_category
    article_module
    title { 'Default Article Title' }
    body { 'Default Article Content' }
  end
end

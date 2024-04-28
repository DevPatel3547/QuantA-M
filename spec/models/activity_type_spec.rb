# spec/models/activity_type_spec.rb
require 'rails_helper'

RSpec.describe ActivityType, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      activity_type = build(:activity_type)
      expect(activity_type).to be_valid
    end

    it 'is not valid without a title' do
      activity_type = build(:activity_type, title: nil)
      expect(activity_type).not_to be_valid
      expect(activity_type.errors[:title]).to include("can't be blank")
    end

    # Add more validation examples based on your model's requirements
  end

  describe 'associations' do
    it 'has many activities' do
      association = described_class.reflect_on_association(:activities)
      expect(association.macro).to eq :has_many
    end

    # Add more association examples based on your model's associations
  end

  # Add more examples for methods, scopes, or any other features of your ActivityType model
end


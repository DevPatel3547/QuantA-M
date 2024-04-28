# spec/models/activity_spec.rb
require 'rails_helper'

RSpec.describe Activity, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      activity = build(:activity)
      expect(activity).to be_valid
    end

    it 'is not valid without a title' do
      activity = build(:activity, title: nil)
      expect(activity).not_to be_valid
      expect(activity.errors[:title]).to include("can't be blank")
    end

    # Add more validation examples based on your model's requirements
  end

  describe 'associations' do
    it 'belongs to an activity type' do
      association = described_class.reflect_on_association(:activity_type)
      expect(association.macro).to eq :belongs_to
    end

    # Add more association examples based on your model's associations
  end

  # Add more examples for methods, scopes, or any other features of your Activity model
end

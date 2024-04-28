class User < ApplicationRecord
  has_many :activity_participations, dependent: :destroy
  before_validation :set_default_timezone, on: [ :create, :update ]

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true, email: true
  validate :timezone_must_be_valid
  devise :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_google(email:, first_name:, last_name:, profile_picture:)
    user = find_or_initialize_by(email: email)
    user.assign_attributes(first_name: first_name, last_name: last_name, profile_picture: profile_picture)
    user.save ? user : nil
  end

  def profile_picture_or_default
    profile_picture.presence || 'pfp_default.jpeg'
  end

  private

  def set_default_timezone
    self.timezone ||= 'Central Time (US & Canada)'
  end
  def timezone_must_be_valid
    errors.add(:timezone, 'is not a valid timezone') unless ActiveSupport::TimeZone.all.map(&:name).include?(timezone)
  end
end

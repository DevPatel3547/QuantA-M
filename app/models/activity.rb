class Activity < ApplicationRecord
  has_many :activity_participations, dependent: :destroy
  belongs_to :activity_type
  validates :activity_type, presence:true
  validates :title, presence:true
  validates :description, presence:true
  validates :start_time, presence:true
  validates :end_time, presence:true
  validates :passcode, presence:true

  enum status: { scheduled: 0, postponed: 1, canceled: 2 }
end

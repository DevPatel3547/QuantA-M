# app/models/activity_participation.rb
class ActivityParticipation < ApplicationRecord
  belongs_to :user
  belongs_to :activity

  enum status: { going: 0, not_going: 1, unsure: 2 }, _prefix: true

  validates :user, presence: true
  validates :activity, presence: true
  validates :status, presence: true

  def status_or_attended
    if attended?
      "Attended"
    else
      status.humanize
    end
  end

  def third_person_status
    if attended?
      "Has Attended"
    else
      "Is #{status.humanize}"
    end
  end
end

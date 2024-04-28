class ActivityType < ApplicationRecord
    has_many :activities
    validates :title, presence:true
end

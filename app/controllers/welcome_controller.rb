class WelcomeController < ApplicationController
  before_action :get_info, only: [:index]

  def index
  end

  private

  def get_points
    attended_activities = current_user.activity_participations.where(attended: true)
    activity_ids = attended_activities.pluck(:activity_id)
    Activity.where(id: activity_ids).sum(:points)
  end

  def get_info
    @total_points = get_points

    @activities = Activity.order(:start_time)
    @upcoming_activities = @activities.where('start_time >= ?', Time.zone.now).where('start_time <= ?', Time.zone.now + 7.days).limit(3)
    @recent_articles = Article.order(created_at: :desc).limit(3)
  end
end

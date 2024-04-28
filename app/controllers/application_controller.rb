# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!
  around_action :set_time_zone, if: :current_user
  layout :set_layout

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private
  def set_layout
    if user_signed_in?
      'user'
    else
      'application'
    end
  end

  def set_time_zone(&block)
    Time.use_zone(current_user.timezone, &block)
  end

  def user_not_authorized
    flash[:notice] = I18n.t 'not_authorized'
    flash[:error] = true
    redirect_to(request.referer || root_path)
  end
end

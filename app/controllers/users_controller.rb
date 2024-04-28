class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @query = params[:query]

    if @query.present?
      @users = User.where("first_name ILIKE :query OR last_name ILIKE :query", query: "%#{@query}%").page(params[:page]).per(10)
    else
      @users = User.page(params[:page]).per(10)
    end

    authorize @users
  end

  def show
    authorize @user
  end

  def update
    authorize @user

    if user_params.key?(:officer)
      authorize @user, :set_officer?
    end

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def get_points
    attended_activities = @user.activity_participations.where(attended: true)
    activity_ids = attended_activities.pluck(:activity_id)
    Activity.where(id: activity_ids).sum(:points)
  end

  private
  def set_user
    @user = User.find(params[:id])
    @total_points = get_points
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :timezone, :officer)
  end
end

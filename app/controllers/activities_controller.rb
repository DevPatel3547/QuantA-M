class ActivitiesController < ApplicationController
    before_action :set_activity, only: %i[edit update destroy delete]
    before_action :set_activity_and_signup, only: %i[show signup verify_attendance]
    helper_method :status_class, :show_verify_attendance_button, :show_signup_button

    def index
      @activities = Activity.order(:start_time)
      @upcoming_activities = @activities.where('start_time >= ?', Time.zone.now).where('start_time <= ?', Time.zone.now + 7.days)

      if params[:view].present?
        session[:view] = params[:view]
      else
        session[:view] ||= 'calendar'
      end

      @preferred_view = session[:view]
    end

    def show
      @first_five_signups = @activity.activity_participations.limit(5)
      @num_signups = @activity.activity_participations.count
    end

    def new
      @activity = Activity.new
      authorize @activity
      if @activity.passcode.nil?
        @activity.passcode = SecureRandom.random_number(1_000_000)
      end
    end

    def edit
      authorize @activity
    end

    def delete
      authorize @activity
    end

    def signups
      @activity = Activity.find(params[:id])
      @signups = @activity.activity_participations
    end

    def create
      # Check if the selected activity_type_id exists
      activity_type_id = params[:activity][:id].to_i
      activity_type = ActivityType.find_by(id: activity_type_id)

      # Create a new ActivityType if it doesn't exist
      activity_type ||= ActivityType.find_or_create_by(title: "Meeting")

      # Create a new Activity
      @activity = Activity.new(activity_params.merge(activity_type_id: activity_type.id))
      authorize @activity

      respond_to do |format|
        if @activity.save
          flash[:notice] = "Activity was successfully created."
          format.html { redirect_to activities_url }
          format.json { render :show, status: :created, location: @activity }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @activity.errors, status: :unprocessable_entity }
        end
      end
    end


    def update
      authorize @activity
      respond_to do |format|
        if @activity.update(activity_params)
          flash[:notice] = "Activity was successfully updated."
          format.html { redirect_to activities_url }
          format.json { render :show, status: :ok, location: @activity }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @activity.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      authorize @activity
      @activity.destroy

      respond_to do |format|
        flash[:notice] = "Activity was successfully deleted."
        format.html { redirect_to activities_url }
        format.json { head :no_content }
      end
    end

    def signup
      respond_to do |format|
        if @signup.present? && @signup.persisted?
          @signup.update(signup_params)
          flash[:notice] = "Sign up status was successfully updated."
          format.html { redirect_to activity_url(@activity) }
        else
          @signup = ActivityParticipation.new(signup_params.merge(user: current_user, activity: @activity))
          @signup.save
          flash[:notice] = "You have successfully signed up for this activity."
          format.html { redirect_to activity_url(@activity) }
        end
      end
    end

    def verify_attendance
      respond_to do |format|
        if @activity.passcode.to_s == params[:passcode_input].to_s
          current_time = Time.now
          if current_time >= @activity.start_time && current_time <= @activity.end_time
            activity_participation = ActivityParticipation.find_or_initialize_by(
              user: current_user,
              activity: @activity
            )
            if activity_participation.persisted?
              # If the record already exists, update attended and status
              activity_participation.update(attended: true, status: ActivityParticipation.statuses[:going])
            else
              # If the record doesn't exist, create a new one with attended and status
              activity_participation.attended = true
              activity_participation.status = ActivityParticipation.statuses[:going]
              activity_participation.save
            end
            flash[:notice] = "Passcode is correct"
            format.html { redirect_to activity_url(@activity) }
          else
            flash[:notice] = "Passcode is no longer valid"
            flash[:error] = true
            format.html { redirect_to activity_url(@activity) }
          end
        else
          flash[:notice] = "Passcode is incorrect"
          flash[:error] = true
          format.html { redirect_to activity_url(@activity) }
        end
      end

    end

    def status_class
      return 'text-bg-success' if @activity.scheduled?
      return 'text-bg-warning' if @activity.postponed?
      'text-bg-danger' if @activity.canceled?
    end

    def show_verify_attendance_button
      return false if @signup.attended?
      return false if @activity.start_time > Time.now
      return false if @activity.end_time < Time.now
      return false if @activity.postponed? || @activity.canceled?
      true
    end

    def show_signup_button
      return false if @signup.attended?
      true
    end

    private

    def set_activity
      @activity = Activity.find(params[:id])
    end

    def set_activity_and_signup
      @activity = Activity.find(params[:id])
      @signup = ActivityParticipation.find_or_initialize_by(user: current_user, activity: @activity)
    end

    def activity_params
      params.require(:activity).permit(:activity_type_id, :title, :description, :start_time, :end_time, :status, :location, :passcode, :points)
    end

    def signup_params
      params.require(:activity_participation).permit(:status)
    end
end

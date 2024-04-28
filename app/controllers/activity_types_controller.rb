# app/controllers/activity_types_controller.rb
class ActivityTypesController < ApplicationController
    before_action :set_activity_type, only: %i[show edit update destroy delete]
  
    def index
      @activity_types = ActivityType.all
    end
  
    def show
    end

    def delete
    end
  
    def new
      @activity_type = ActivityType.new
    end
  
   # app/controllers/activity_types_controller.rb
   def create
    @activity_type = ActivityType.new(activity_type_params)
  
    respond_to do |format|
      if @activity_type.save
        format.html { redirect_to activity_types_url, notice: "Activity type was successfully created." }
        format.json { render :show, status: :created, location: @activity_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @activity_type.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end
  

  
    def edit
    end
  
    # app/controllers/activity_types_controller.rb

    def update
      respond_to do |format|
        if @activity_type.update(activity_type_params)
          format.html { redirect_to activity_types_url, notice: "Activity type was successfully updated." }
          format.json { render :show, status: :ok, location: @activity_type }
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

  
    def destroy
      @activity_type.destroy
    
      respond_to do |format|
        format.html { redirect_to activity_types_url, notice: 'Activity type was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
    
  
    private
  
    def set_activity_type
      @activity_type = ActivityType.find(params[:id])
    end
  
    def activity_type_params
      params.require(:activity_type).permit(:title)
    end
end
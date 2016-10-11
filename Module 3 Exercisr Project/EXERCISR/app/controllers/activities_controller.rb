class ActivitiesController < ApplicationController 
  before_filter :login_required 
  before_filter :find_workout 
  
  # GET /activities 
  # GET /activities.xml 
  def index 
    @activities = @workout.activities.find(:all) 
    respond_to do |format| 
      format.html # index.rhtml 
      format.xml  { render :xml => @activities.to_xml } 
    end 
  end
   
  # GET /activities/1 
  # GET /activities/1.xml 
  def show 
    @activity = @workout.activities.find(params[:id]) 
    respond_to do |format| 
      format.html # show.rhtml 
      format.xml  { render :xml => @activity.to_xml } 
    end 
  end
   
  # GET /activities/new 
  def new 
    @activity = @workout.activities.build 
  end
   
  # GET /activities/1;edit 
  def edit 
    @activity = @workout.activities.find(params[:id]) 
  end
   
  # POST /activities 
  # POST /activities.xml 
  def create 
    @activity = @workout.activities.build(params[:activity]) 
    respond_to do |format| 
      if @activity.save 
        flash[:notice] = 'Activity was successfully created.' 
        format.html { redirect_to workout_url(@workout) } 
        format.xml  { head :created, :location => activity_url(@workout, @activity)} 
      else 
        format.html { render :action => "new" } 
        format.xml  { render :xml => @activity.errors.to_xml } 
      end 
    end 
  end 

  # PUT /activities/1 
  # PUT /activities/1.xml 
  def update 
    @activity = @workout.activities.find(params[:id]) 
    respond_to do |format| 
      if @activity.update_attributes(params[:activity]) 
        flash[:notice] = 'Activity was successfully updated.' 
        format.html { redirect_to workout_url(@workout) } 
        format.xml  { head :ok } 
      else 
        format.html { render :action => "edit" } 
        format.xml  { render :xml => @activity.errors.to_xml } 
      end 
    end 
  end 

  # DELETE /activities/1 
  # DELETE /activities/1.xml 
  def destroy 
    @activity = @workout.activities.find(params[:id]) 
    @activity.destroy 
    respond_to do |format| 
      format.html { redirect_to workout_url(@workout) } 
      format.xml  { head :ok } 
    end 
  end 

  protected 
  def find_workout 
    @workout = current_user.workouts.find(params[:workout_id]) 
  end 
end 

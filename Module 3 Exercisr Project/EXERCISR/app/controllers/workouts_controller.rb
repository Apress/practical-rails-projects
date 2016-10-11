class WorkoutsController < ApplicationController
  before_filter :login_required
  
  # GET /workouts
  # GET /workouts.xml
  def index
    @workouts = current_user.workouts.find(:all, :order => 'date desc', :limit => 10)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @workouts.to_xml }
    end
  end

  # GET /workouts/1
  # GET /workouts/1.xml
  def show
    @workout = current_user.workouts.find(params[:id])
    @activities = @workout.activities.find(:all, :include => :exercise)

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @workout.to_xml }
    end
  end

  # GET /workouts/new
  def new
    @workout = current_user.workouts.build
  end

  # GET /workouts/1;edit
  def edit
    @workout = current_user.workouts.find(params[:id])
  end

  # POST /workouts
  # POST /workouts.xml
  def create
    @workout = current_user.workouts.build(params[:workout])

    respond_to do |format|
      if @workout.save
        flash[:notice] = 'Workout was successfully created.'
        format.html { redirect_to workout_url(@workout) }
        format.xml  { head :created, :location => workout_url(@workout) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @workout.errors.to_xml }
      end
    end
  end

  # PUT /workouts/1
  # PUT /workouts/1.xml
  def update
    @workout = current_user.workouts.find(params[:id])

    respond_to do |format|
      if @workout.update_attributes(params[:workout])
        flash[:notice] = 'Workout was successfully updated.'
        format.html { redirect_to workout_url(@workout) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @workout.errors.to_xml }
      end
    end
  end

  # DELETE /workouts/1
  # DELETE /workouts/1.xml
  def destroy
    @workout = current_user.workouts.find(params[:id])
    @workout.destroy

    respond_to do |format|
      format.html { redirect_to workouts_url }
      format.xml  { head :ok }
    end
  end
end

require 'ziya'
class ExercisesController < ApplicationController
  include Ziya
  
  before_filter :login_required
  
  # GET /exercises
  # GET /exercises.xml
  def index
    @exercises = current_user.exercises.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @exercises.to_xml }
    end
  end

  # GET /exercises/1
  # GET /exercises/1.xml
  def show
    @exercise = current_user.exercises.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @exercise.to_xml }
      format.swf {
        total_weight = @exercise.activities.collect {|e| e.repetitions * e.resistance}
        workout_dates = @exercise.activities.collect {|e| e.workout.date.to_s}        
        # chart = Ziya::Charts::Bar.new
        chart = Ziya::Charts::Bar.new(nil, "", 'my_bar_chart')
        chart.add(:series, "Total Weight Per Set", total_weight)
        chart.add(:axis_category_text, workout_dates)
        render :xml => chart.to_xml
      }
    end
  end

  # GET /exercises/new
  def new
    @exercise = current_user.exercises.build
  end

  # GET /exercises/1;edit
  def edit
    @exercise = current_user.exercises.find(params[:id])
  end

  # POST /exercises
  # POST /exercises.xml
  def create
    @exercise = current_user.exercises.build(params[:exercise])

    respond_to do |format|
      if @exercise.save
        flash[:notice] = 'Exercise was successfully created.'
        format.html { redirect_to exercises_url }
        format.xml  { head :created, :location => exercise_url(@exercise) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @exercise.errors.to_xml }
      end
    end
  end

  # PUT /exercises/1
  # PUT /exercises/1.xml
  def update
    @exercise = current_user.exercises.find(params[:id])

    respond_to do |format|
      if @exercise.update_attributes(params[:exercise])
        flash[:notice] = 'Exercise was successfully updated.'
        format.html { redirect_to exercise_url(@exercise) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @exercise.errors.to_xml }
      end
    end
  end

  # DELETE /exercises/1
  # DELETE /exercises/1.xml
  def destroy
    @exercise = current_user.exercises.find(params[:id])
    @exercise.destroy

    respond_to do |format|
      format.html { redirect_to exercises_url }
      format.xml  { head :ok }
    end
  end
end

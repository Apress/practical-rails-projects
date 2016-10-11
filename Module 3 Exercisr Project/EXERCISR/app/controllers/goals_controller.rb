class GoalsController < ApplicationController 
  before_filter :login_required
  helper :sparklines

  # GET /goals 
  # GET /goals.xml 
  def index 
    @goals = current_user.goals.find(:all) 
    respond_to do |format| 
      format.html # index.rhtml 
      format.xml  { render :xml => @goals.to_xml } 
    end 
  end 

  # GET /goals/1 
  # GET /goals/1.xml 
  def show 
    @goal = current_user.goals.find(params[:id]) 
    @results = @goal.results.find(:all, :order => 'date desc') 
    respond_to do |format| 
      format.html # show.rhtml 
      format.xml  { render :xml => @goal.to_xml } 
    end 
  end 

  # GET /goals/new 
  def new 
    @goal = current_user.goals.build 
  end 

  # GET /goals/1;edit 
  def edit 
    @goal = current_user.goals.find(params[:id]) 
  end 

  # POST /goals 
  # POST /goals.xml 
  def create 
    @goal = current_user.goals.build(params[:goal]) 
    respond_to do |format| 
      if @goal.save 
        flash[:notice] = 'Goal was successfully created.' 
        format.html { redirect_to goal_url(@goal) } 
        format.xml  { head :created, :location => goal_url(@goal) } 
      else 
        format.html { render :action => "new" } 
        format.xml  { render :xml => @goal.errors.to_xml } 
      end 
    end 
  end 

  # PUT /goals/1 
  # PUT /goals/1.xml 
  def update 
    @goal = current_user.goals.find(params[:id]) 
    respond_to do |format| 
      if @goal.update_attributes(params[:goal]) 
        flash[:notice] = 'Goal was successfully updated.' 
        format.html { redirect_to goal_url(@goal) } 
        format.xml  { head :ok } 
      else 
        format.html { render :action => "edit" } 
        format.xml  { render :xml => @goal.errors.to_xml } 
      end 
    end 
  end 

  # DELETE /goals/1 
  # DELETE /goals/1.xml 
  def destroy 
    @goal = current_user.goals.find(params[:id]) 
    @goal.destroy 
    respond_to do |format| 
      format.html { redirect_to goals_url } 
      format.xml  { head :ok } 
    end 
  end
  
  # def report
  #   g = Gruff::Line.new(400)    
  #   goal = current_user.goals.find(params[:id])
  #   results = goal.results.collect {|r| r.value}
  #   g.title = "#{goal.name} to date"
  #   g.data("#{goal.name}", results)
  #   send_data(g.to_blob, :disposition => 'inline', :type => 'image/png', :filename => "gruff.png")
  # end
end
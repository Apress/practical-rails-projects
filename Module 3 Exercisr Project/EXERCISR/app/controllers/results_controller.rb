class ResultsController < ApplicationController 
  before_filter :login_required 
  before_filter :find_goal 
  
  # GET /results 
  # GET /results.xml 
  def index 
    @results = @goal.results.find(:all) 
    respond_to do |format| 
      format.html # index.rhtml 
      format.xml  { render :xml => @results.to_xml } 

      # format.png { 
      #   graph = Scruffy::Graph.new
      #   results = @goal.results.collect {|r| r.value}
      #   graph.add :stacked, 'Weight' do |stacked|
      #     stacked.add :line, '', results
      #   end
      #   send_data(graph.render(:width => 400, :as => 'PNG'))
      #   }
      # 

      format.png { 
        g = Gruff::Line.new(400, false)    
        results = @goal.results.collect {|r| r.value}
        g.title = "#{@goal.name} to date"
        g.data("#{@goal.name}", results)
        send_data(g.to_blob, :disposition => 'inline', :type => 'image/png', :filename => "gruff.png")
        }
      
    end 
  end 

  # GET /results/1 
  # GET /results/1.xml 
  def show 
    @result = @goal.results.find(params[:id]) 
    respond_to do |format| 
      format.html # show.rhtml 
      format.xml  { render :xml => @result.to_xml } 
    end 
  end 

  # GET /results/new 
  def new 
    @result = @goal.results.build 
  end 

  # GET /results/1;edit 
  def edit 
    @result = @goal.results.find(params[:id]) 
  end 

  # POST /results 
  # POST /results.xml 
  def create 
    @result = @goal.results.build(params[:result]) 
    respond_to do |format| 
      if @result.save 
        flash[:notice] = 'Result was successfully created.' 
        format.html { redirect_to goal_url(@goal) } 
        format.xml  { head :created, :location => result_url(@result) } 
      else 
        format.html { render :action => "new" } 
        format.xml  { render :xml => @result.errors.to_xml } 
      end 
    end 
  end 

  # PUT /results/1 
  # PUT /results/1.xml 
  def update 
    @result = @goal.results.find(params[:id]) 
    respond_to do |format| 
      if @result.update_attributes(params[:result]) 
        flash[:notice] = 'Result was successfully updated.' 
        format.html { redirect_to goal_url(@goal) }  
        format.xml  { head :ok } 
      else 
        format.html { render :action => "edit" } 
        format.xml  { render :xml => @result.errors.to_xml } 
      end 
    end 
  end 

  # DELETE /results/1 
  # DELETE /results/1.xml 
  def destroy 
    @result = @goal.results.find(params[:id]) 
    @result.destroy 
    respond_to do |format| 
      format.html { redirect_to goal_url(@goal) }  
      format.xml  { head :ok } 
    end 
  end 

  protected 
  def find_goal 
    @goal = current_user.goals.find(params[:goal_id]) 
  end 
end
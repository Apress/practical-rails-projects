class DevelopersController < ApplicationController
  in_place_edit_for :developer, :Name
  in_place_edit_for :developer, :URL

  make_resourceful do
    build :all
  end

  def index
    limit =  params[:limit] || 25
    start = params[:start] || 0

    respond_to do |format|
      format.html 
      format.json {
        if(params[:search])
          @developers = Developer.find(:all, :limit => limit, :offset => start, 
            :conditions => ["Name like ?","%" + params[:search] + "%"])
            
          dev_count = Developer.count(:conditions => ["Name like ?","%" + params[:search] + "%"])
        else
          @developers = Developer.find(:all, :limit => limit, :offset => start )
          dev_count = Developer.count
        end
        
        griddata = Hash.new
        griddata[:developers] = @developers.collect {|d| {:DevID => d.DevID, :Name => d.Name, :URL => d.URL}}
        griddata[:totalCount] =  dev_count
  
        render :text => griddata.to_json()
      }
    end
  end
end


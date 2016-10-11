class PublishersController < ApplicationController
  in_place_edit_for :publisher, :Name
  in_place_edit_for :publisher, :URL


  make_resourceful do
    build :all
  end

  def index
    limit =  params[:limit] || 25
    start = params[:start] || 0

    respond_to do |format|
      format.html {}
      format.json {
        if(params[:search])
          @publishers = Publisher.find(:all, :limit => limit, :offset => start, 
            :conditions => ["Name like ?","%" + params[:search] + "%"])
            
          dev_count = Publisher.count(:conditions => ["Name like ?","%" + params[:search] + "%"])
        else
          @publishers = Publisher.find(:all, :limit => limit, :offset => start )
          dev_count = Publisher.count
        end
        
        griddata = Hash.new
        griddata[:publishers] = @publishers.collect {|p| {:PubID => p.PubID, :Name => p.Name, :URL => p.URL}}
        griddata[:totalCount] =  dev_count

        render :text => griddata.to_json()
      }
    end
  end
  
end

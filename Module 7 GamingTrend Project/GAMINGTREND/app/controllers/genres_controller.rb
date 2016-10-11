class GenresController < ApplicationController
  in_place_edit_for :genre, :TYPE

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
          @genres = Genre.find(:all, :limit => limit, :offset => start, 
            :conditions => ["Name like ?","%" + params[:search] + "%"])
            
          genre_count = Genre.count(:conditions => ["Name like ?","%" + params[:search] + "%"])
        else
          @genres = Genre.find(:all, :limit => limit, :offset => start )
          genre_count = Genre.count
        end
        
        griddata = Hash.new
        griddata[:genres] = @genres.collect {|g| 
            {:GenreID => g.GenreID, :TYPE => g.TYPE}}
        griddata[:totalCount] =  genre_count
  
        render :text => griddata.to_json()
      }
    end
  end
end


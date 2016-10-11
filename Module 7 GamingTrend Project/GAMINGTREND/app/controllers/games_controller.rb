class GamesController < ApplicationController
  in_place_edit_for :game, :Console
  in_place_edit_for :game, :DevID
  in_place_edit_for :game, :PubID
  in_place_edit_for :game, :ESRB 
  in_place_edit_for :game, :GenreID
  in_place_edit_for :game, :SiteURL  
  
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
          @games = Game.find(:all, :limit => limit, :offset => start, 
            :conditions => ["Title like ?","%" + params[:search] + "%"])
            game_count = Game.count(:conditions => ["Title like ?","%" + params[:search] + "%"])
        else
          @games = Game.find(:all, :limit => limit, :offset => start )
          game_count = Game.count
        end
        
        griddata = Hash.new
        griddata[:games] = @games.collect {|g| {:GameID => g.GameID, :Console => g.Console, :Title => g.Title}}
        griddata[:totalCount] =  game_count

        render :text => griddata.to_json()
      }
    end
  end
  
  def search
     @results = Game.find(:all, 
                          :conditions => ["Title like ?", "%" + params[:search] + "%"], 
                          :limit => 20)
  end
  
end

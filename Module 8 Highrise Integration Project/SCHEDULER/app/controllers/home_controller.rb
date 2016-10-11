class HomeController < ApplicationController

  def index
    @tasks = Task.upcoming
  end

  def detail
    @customer = Person.find(params[:id])
  end
  
  def test

  end
end

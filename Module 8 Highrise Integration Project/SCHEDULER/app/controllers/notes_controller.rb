class NotesController < ApplicationController
  def create
    @note = Note.new(params[:note])
    @note.save
    head :created
    # redirect_to root_url
  end
  
  def update_page
    @person = Person.find(params[:id])
  end
end

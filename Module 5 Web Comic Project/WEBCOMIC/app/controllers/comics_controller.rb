class ComicsController < ApplicationController
  before_filter :verify_admin
  cache_sweeper :comic_sweeper, :only => [:create, :update, :destroy]

  layout 'adfree'

  # GET /comics
  # GET /comics.xml
  def index
    @comics = Comic.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @comics.to_xml }
    end
  end

  # GET /comics/1
  # GET /comics/1.xml
  def show
    @comic = Comic.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @comic.to_xml }
    end
  end

  # GET /comics/new
  def new
    @comic = Comic.new
  end

  # GET /comics/1;edit
  def edit
    @comic = Comic.find(params[:id])
  end

  # POST /comics
  # POST /comics.xml
  def create
    @comic = Comic.new(params[:comic])

    respond_to do |format|
      if @comic.save
        flash[:notice] = 'Comic was successfully created.'
        format.html { redirect_to comic_url(@comic) }
        format.xml  { head :created, :location => comic_url(@comic) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @comic.errors.to_xml }
      end
    end
  end

  # PUT /comics/1
  # PUT /comics/1.xml
  def update
    @comic = Comic.find(params[:id])

    respond_to do |format|
      if @comic.update_attributes(params[:comic])
        flash[:notice] = 'Comic was successfully updated.'
        format.html { redirect_to comic_url(@comic) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comic.errors.to_xml }
      end
    end
  end

  # DELETE /comics/1
  # DELETE /comics/1.xml
  def destroy
    @comic = Comic.find(params[:id])
    @comic.destroy

    respond_to do |format|
      format.html { redirect_to comics_url }
      format.xml  { head :ok }
    end
  end
  
  protected
  def verify_admin
    unless admin?
      redirect_to login_path
      return false      
    end
    true
  end
  
  
end

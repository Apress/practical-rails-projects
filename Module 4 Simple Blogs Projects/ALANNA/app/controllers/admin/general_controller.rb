class Admin::GeneralController < Admin::BaseController
  def index
    if this_blog.canonical_server_url.blank?
      this_blog.canonical_server_url = server_url
    end
    @page_cache_size = PageCache.count
  end

  def redirect
    flash[:notice] = "Please review and save the settings before continuing"
    redirect_to :action => "index"
  end

  def update_database
    @current_version = Migrator.current_schema_version
    @needed_version = Migrator.max_schema_version
    @support = Migrator.db_supports_migrations?
    @needed_migrations = Migrator.available_migrations[@current_version..@needed_version].collect do |mig|
      mig.scan(/\d+\_([\w_]+)\.rb$/).flatten.first.humanize
    end
  end

  def migrate
    if request.post?
      Migrator.migrate
      redirect_to :action => 'update_database'
    end
  end

  def update
    if request.post?
      Blog.transaction do
        params[:setting].each { |k,v| this_blog[k] = v}
        this_blog.save
        flash[:notice] = 'config updated.'
      end
      redirect_to :action => 'index'
    end
  end

  private
end

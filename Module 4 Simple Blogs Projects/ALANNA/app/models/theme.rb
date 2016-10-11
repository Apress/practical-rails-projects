class Theme
  cattr_accessor :cache_theme_lookup
  @@cache_theme_lookup = false

  attr_accessor :name, :path, :description_html

  def initialize(name, path)
    @name, @path = name, path
  end

  def layout
    "../../themes/#{name}/layouts/default"
  end

  def description
    File.read("#{path}/about.markdown") rescue "### #{name}"
  end

  def self.themes_root
    RAILS_ROOT + "/themes"
  end

  def self.theme_from_path(path)
    name = path.scan(/[-\w]+$/i).flatten.first
    self.new(name, path)
  end

  def self.find_all
    installed_themes.inject([]) do |array, path|
      array << theme_from_path(path)
    end
  end

  def self.installed_themes
    cache_theme_lookup ? @theme_cache ||= search_theme_directory : search_theme_directory
  end

  def self.search_theme_directory
    glob = "#{themes_root}/[a-zA-Z0-9]*"
    Dir.glob(glob).select do |file|
      File.readable?("#{file}/about.markdown")
    end.compact
  end
end

module ArticlesHelper
  def admin_tools_for(model)
    type = model.class.to_s.downcase
    tag = []
    tag << content_tag("div",
      link_to_remote('nuke', {
          :url => { :action => "nuke_#{type}", :id => model },
          :complete => visual_effect(:puff, "#{type}-#{model.id}", :duration => 0.6),
          :confirm => "Are you sure you want to delete this #{type}?"
        }, :class => "admintools") <<
      link_to('edit', {
        :controller => "admin/#{type.pluralize}",
        :article_id => model.article.id,
        :action => "edit", :id => model
        }, :class => "admintools"),
      :id => "admin_#{type}_#{model.id}", :style => "display: none")
    tag.join(" | ")
  end

  def onhover_show_admin_tools(type, id = nil)
    tag = []
    tag << %{ onmouseover="if (getCookie('is_admin') == 'yes') { Element.show('admin_#{[type, id].compact.join('_')}'); }" }
    tag << %{ onmouseout="Element.hide('admin_#{[type, id].compact.join('_')}');" }
    tag
  end

  def render_errors(obj)
    return "" unless obj
    tag = String.new

    unless obj.errors.empty?
      tag << %{<ul class="objerrors">}

      obj.errors.each_full do |message|
        tag << "<li>#{message}</li>"
      end

      tag << "</ul>"
    end

    tag
  end

  def page_title
    if @page_title
      # this is where the page title prefix (string) should go
      (this_blog.title_prefix ? "#{this_blog.blog_name || "Typo"} : " : '') + @page_title
    else
      this_blog.blog_name || "Typo"
    end
  end

  def page_header
    page_header_includes = contents.collect { |c| c.whiteboard }.collect { |w| w.select {|k,v| k =~ /^page_header_/}.collect {|(k,v)| v} }.flatten.uniq
    (
    <<-HTML
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
  #{ meta_tag 'ICBM', this_blog.geourl_location unless this_blog.geourl_location.empty? }
  <link rel="EditURI" type="application/rsd+xml" title="RSD" href="#{ server_url_for :controller => 'xml', :action => 'rsd' }" />
  <link rel="alternate" type="application/atom+xml" title="Atom" href="#{ @auto_discovery_url_atom }" />
  <link rel="alternate" type="application/rss+xml" title="RSS" href="#{ @auto_discovery_url_rss }" />
  #{ javascript_include_tag "cookies" }
  #{ javascript_include_tag "prototype" }
  #{ javascript_include_tag "effects" }
  #{ javascript_include_tag "typo" }
  #{ page_header_includes.join("\n") }
  <script type="text/javascript">#{ @content_for_script }</script>
    HTML
    ).chomp
  end

  def article_links(article)
    returning code = [] do
      code << category_links(article)   unless article.categories.empty?
      code << tag_links(article)        unless article.tags.empty?
      code << comments_link(article)    if article.allow_comments?
      code << trackbacks_link(article)  if article.allow_pings?
    end.join("&nbsp;<strong>|</strong>&nbsp;")
  end

  def category_links(article)
    "Posted in " + article.categories.collect { |c| link_to h(c.name),
    { :controller => "/articles", :action => "category", :id => c.permalink },
      :rel => "tag"
    }.join(", ")
  end

  def tag_links(article)
    "Tags " + article.tags.collect { |tag| link_to tag.display_name,
      { :controller => "/articles", :action => "tag", :id => tag.name },
      :rel => "tag"
    }.sort.join(", ")
  end

  def author_link(article)
    if this_blog.link_to_author and article.user and article.user.email.to_s.size>0
      "<a href=\"mailto:#{h article.user.email}\">#{h article.user.name}</a>"
    elsif article.user and article.user.name.to_s.size>0
      h article.user.name
    else
      h article.author
    end
  end

  def next_link(article)
    n = article.next
    return  n ? article_link("#{n.title} &raquo;", n) : ''
  end

  def prev_link(article)
    p = article.previous
    return p ? article_link("&laquo; #{p.title}", p) : ''
  end

  def render_sidebars
    # ugly ugly hack to fix the extremely verbose sidebar logging
    options = { :controller => SidebarController,
                :action => 'display_plugins',
                :params => {:contents => contents,
                            :request_params => params} }
    render_component(options)
  end

  # Generate the image tag for a commenters gravatar based on their email address
  # Valid options are described at http://www.gravatar.com/implement.php
  def gravatar_tag(email, options={})
    options.update(:gravatar_id => Digest::MD5.hexdigest(email.strip))
    options[:default] = CGI::escape(options[:default]) if options.include?(:default)
    options[:size] ||= 60

    image_tag("http://www.gravatar.com/avatar.php?" <<
      options.map { |key,value| "#{key}=#{value}" }.sort.join("&"), :class => "gravatar")
  end

  def calc_distributed_class(articles, max_articles, grp_class, min_class, max_class)
    (grp_class.to_prefix rescue grp_class.to_s) +
      ((max_articles == 0) ?
           min_class.to_s :
         (min_class + ((max_class-min_class) * articles.to_f / max_articles).to_i).to_s)
  end

  def link_to_grouping(grp)
    link_to( grp.display_name, urlspec_for_grouping(grp),
             :rel => "tag", :title => title_for_grouping(grp) )
  end

  def urlspec_for_grouping(grouping)
    { :controller => "/articles", :action => grouping.class.to_prefix, :id => grouping.permalink }
  end

  def title_for_grouping(grouping)
    "#{pluralize(grouping.article_counter, 'post')} with #{grouping.class.to_s.underscore} '#{grouping.display_name}'"
  end

  def ul_tag_for(grouping_class)
    case
    when grouping_class == Tag
      %{<ul id="taglist" class="tags">}
    when grouping_class == Category
      %{<ul class="categorylist">}
    else
      '<ul>'
    end
  end
end

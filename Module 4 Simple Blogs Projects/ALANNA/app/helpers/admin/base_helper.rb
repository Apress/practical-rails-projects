module Admin::BaseHelper

  def state_class(item)
    item.state.memento.underscore.sub(/.*\//, '')
  end

  def render_flash
    output = []

    for key,value in flash
      output << "<span class=\"#{key.to_s.downcase}\">#{value}</span>"
    end if flash

    output.join("<br/>\n")
  end

  def render_tasks
     output = []

      for key,value in @tasks
      output << "<a href=\"#{value}\">#{key}</a>"
    end if @tasks

    output.join("<br/>\n")
  end

  def current_user_notice
    unless session[:user]
      link_to "log in", :controller => "/accounts", :action=>"login"
    else
      link_to "log out", :controller => "/accounts", :action=>"logout"
    end
  end

  def tab(label, options = {})
    if controller.controller_name =~ /#{options[:controller].split('/').last}/
      content_tag :li, link_to(label, options, {"class"=> "active"}), {"class"=> "active"}
    else
      content_tag :li, link_to(label, options)
    end
  end

  def cancel(url = {:action => 'list'})
    link_to "Cancel", url
  end

  def save(val = "Store")
    '<input type="submit" value="' + val + '" class="primary" />'
  end

  def confirm_delete(val = "Delete")
   '<input type="submit" value="' + val + '" />'
  end

  def link_to_show(record)
    link_to image_tag('go'), :action => 'show', :id => record.id
  end

  def link_to_edit(record)
    link_to image_tag('go'), :action => 'edit', :id => record.id
  end

  def link_to_destroy(record)
    link_to image_tag('delete'), :action => 'destroy', :id => record.id
  end

  def text_filter_options
    TextFilter.find(:all).collect do |filter|
      [ filter.description, filter ]
    end
  end

  def alternate_class
    @class = @class != '' ? '' : 'class="shade"'
  end

  def reset_alternation
    @class = nil
  end

  def task_quickpost(title)
    content_tag :li, link_to_function(title, toggle_effect('quick-post', 'Effect.BlindUp', "duration:0.4", "Effect.BlindDown", "duration:0.4"))
  end

  def task_quicknav(title)
    content_tag :li, link_to_function(title, toggle_effect('quick-navigate', 'Effect.BlindUp', "duration:0.4", "Effect.BlindDown", "duration:0.4"))
  end

  def task_overview
    task('Back to overview', 'list')
  end

  def task_new(title)
    task(title, 'new')
  end

  def task_destroy(title, id)
    task(title, 'destroy', id)
  end

  def task_edit(title, id)
    task(title, 'edit', id)
  end

  def task_show(title, id)
    task(title, 'show', id)
  end

  def task_help(title, id)
    task(title, 'show_help', id)
  end

  def task(title, action, id = nil)
    content_tag :li, link_to(title, :action => action, :id => id)
  end

  def task_add_resource_metadata(title,id)
    link_to_function(title, toggle_effect('add-resource-metadata-' + id.to_s, 'Effect.BlindUp', "duration:0.4", "Effect.BlindDown", "duration:0.4"))
  end

  def task_edit_resource_metadata(title,id)
    link_to_function(title, toggle_effect('edit-resource-metadata-' + id.to_s, 'Effect.BlindUp', "duration:0.4", "Effect.BlindDown", "duration:0.4"))
  end

  def task_edit_resource_mime(title,id)
    link_to_function(title, toggle_effect('edit-resource-mime-' + id.to_s, 'Effect.BlindUp', "duration:0.4", "Effect.BlindDown", "duration:0.4"))
  end
end

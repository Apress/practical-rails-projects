# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def ext_javascript_tags
    sources = %w(prototype effects dragdrop controls ext-prototype-adapter ext-all)
    sources.collect do |source|
      source = javascript_path(source)        
      content_tag("script", "", { "type" => "text/javascript", "src" => source })
    end.join("\n")
  end
  
  def ext_stylesheet_tags
    sources = %w(ext-all.css xtheme-vista.css application.css)
    sources.collect do |source|
      source = stylesheet_path(source)
      tag("link", { "rel" => "Stylesheet", "type" => "text/css", "media" => "screen", "href" => source })
    end.join("\n")    
  end
  
  def ext_layout(titlebar)
    function = "var PageLayout = function() {"
    function << "var layout;"
    function << "return{"
    function << "init : function(){"
    function << "var layout = new Ext.BorderLayout(document.body, {"
    function << "north: {split:false,initialSize:65},"
    function << "center: {titlebar: true,autoScroll:true}," 
    function << "west: {initialSize: 125,minSize: 125, maxSize:125,titlebar: true, split:true, collapsible:true, animate:true}"
    function << "});"    
    function << "layout.beginUpdate();"          
    function << "layout.add('north', new Ext.ContentPanel('header'));"
    function << "layout.add('center', new Ext.ContentPanel('content', {title:'#{titlebar}'}));"         
    function << "layout.add('west', new Ext.ContentPanel('sidebar', {title: 'Navigation'}));"        
    function << "layout.endUpdate();"
    function << "}};}();"
    function << "Ext.EventManager.onDocumentReady(PageLayout.init, PageLayout, true);"
    javascript_tag(function)
  end
  
  def ext_grid(model, primary_key, fields, columns, height)
    xml_fields = fields
    xml_fields << primary_key
    xml_fields.collect! {|x| "'#{x}'"}

    function = "var pageGrid = function() {"
    function << " var grid; var dialog; var ds;"
    function << " return{ init : function(){"
    function << " ds = new Ext.data.Store({"    
    function << " proxy: new Ext.data.HttpProxy({method: 'GET', url: '#{model.pluralize}.json'}),"
    
    function << "reader: new Ext.data.JsonReader({"
    function << "root: '#{model.pluralize}',"
    function << " totalProperty: 'totalCount',"
    function << " id: '#{primary_key}'"
    function << "}, [#{xml_fields.to_sentence(:connector => '')}])"
    function << " });"    

    function << " var cm = new Ext.grid.ColumnModel([#{columns}]);"
    function << " cm.defaultSortable = true;"
    function << " grid = new Ext.grid.Grid('content', { ds: ds, cm: cm });"    
    function << " grid.render();"
    
    function << "var gridFoot = grid.getView().getFooterPanel(true);"
    function << "var paging = new Ext.PagingToolbar(gridFoot, ds, {"
    function << "pageSize: 20,"
    function << "displayInfo: true,"
    function << "displayMsg: 'Displaying topics {0} - {1} of {2}',"    
    function << "emptyMsg: 'No topics to display'});"
    function << "ds.load({params:{start:0, limit:20}});"
    
    function << " grid.on('rowdblclick', editResource);"
    
    function << " var gridHead = grid.getView().getHeaderPanel(true);"    
    function << " var tb = new Ext.Toolbar(gridHead);"
    function << " tb.add({ text: 'Create New #{model.capitalize}', handler: createResource }, '-', { text: 'Delete Selected #{model.capitalize}', handler: deleteResource });"
    function << " tb.add('-', 'Filter: ', \"<input type='text' id='text_filter'>\");"    
    function << " Ext.get('text_filter').on('keyup', filterResource);"
    function << " }}\n"  
    
    function << " function filterResource() {"    
    function << " filtervalue = Ext.get('text_filter').dom.value;"
    function << " ds.proxy = new Ext.data.HttpProxy({method: 'GET', url: '#{model.pluralize}.json?search=' + filtervalue});"
    function << " ds.reload();}\n"    

    function << " function deleteResource() {"
    function << " var id = grid.getSelectionModel().getSelected(); "
    function << " if(id){"      
    function << " Ext.MessageBox.confirm('Confirm', 'Are you sure you want to delete this #{model}?', postDelete);"
    function << "  } else {"
    function << " Ext.MessageBox.alert('DOH!', 'Maybe you want to try again after ACTUALLY selecting something?')}}\n"    

    function << " function submitResource(){"
    function << " document.create_resource.submit();}\n"

    function << " function postDelete(btn){"    
    function << " if(btn == 'yes') {"
    function << " var id = grid.getSelectionModel().getSelected();"
    function << " var deleteme = id.get('#{primary_key}');"    
    function << " window.location.href = '/#{model.pluralize}/destroy/' + deleteme;}}\n"

    function << " function editResource(grid, rowIndex) {"
    function << " var id = grid.getSelectionModel().getSelected();"    
    function << " if(id) { "    
    function << " window.location.href = '/#{model.pluralize}/' + id.get('#{primary_key}'); }}\n"

    function << " function createResource() {"    
    function << " if(!dialog) {"    
    function << " dialog = new Ext.BasicDialog('newDialog', {"
    function << " width:500, height:#{height}, shadow:true, minWidth:300, minHeight:#{height}, proxyDrag:true, autoScroll:false, animEl:true });"
    function << " dialog.addKeyListener(27, dialog.hide, dialog);"    
    function << " postBtn = dialog.addButton('Submit', submitResource, this);"
    function << " dialog.addButton('Close', dialog.hide, dialog); }\n"    

      

    function << " dialog.show();"
    function << " dialog.on('hide', function(){"    
    function << " document.create_resource.reset();})"    
    function << " } }();"    
    function << " Ext.onReady(pageGrid.init, pageGrid, true);"    
    javascript_tag(function)    
  end
    
    
    
  def ext_news_grid(model, primary_key, fields, columns, height)
    xml_fields = fields
    xml_fields << primary_key
    xml_fields.collect! {|x| "'#{x}'"}

    function = "var pageGrid = function() {"
    function << " var grid; var dialog; var ds;"
    function << " return{ init : function(){"
    function << " ds = new Ext.data.Store({"    
    function << " proxy: new Ext.data.HttpProxy({method: 'GET', url: '#{model.pluralize}.json'}),"
    
    function << "reader: new Ext.data.JsonReader({"
    function << "root: '#{model.pluralize}',"
    function << " totalProperty: 'totalCount',"
    function << " id: '#{primary_key}'"
    function << "}, [#{xml_fields.to_sentence(:connector => '')}])"
    function << " });"    

    function << "function renderNews(value, p, record) {"
    function << "return String.format('<b>{0}</b><br />{1}', value, Ext.util.Format.stripTags(record.data['Body']).substr(0,100) + \"....\");}"

    function << "function renderNewsPlain(value) {"
    function << "return String.format('<b><i>{0}</i></b>', value); }"
    


    function << " var cm = new Ext.grid.ColumnModel([#{columns}]);"
    function << " cm.defaultSortable = true;"
    function << " grid = new Ext.grid.Grid('content', { ds: ds, cm: cm });"    
    function << " grid.render();"
    
    function << "var gridFoot = grid.getView().getFooterPanel(true);"
    function << "var paging = new Ext.PagingToolbar(gridFoot, ds, {"
    function << "pageSize: 13,"
    function << "displayInfo: true,"
    function << "displayMsg: 'Displaying topics {0} - {1} of {2}',"    
    function << "emptyMsg: 'No topics to display'});"
    function << "ds.load({params:{start:0, limit:13}});"
    
    function << "function toggleNews(btn, pressed) {"
    function << "cm.getColumnById('Headline').renderer = pressed ? renderNews : renderNewsPlain;"
    function << "grid.getView().refresh(); }"
    
    
    function << " grid.on('rowdblclick', editResource);"
    
    function << " var gridHead = grid.getView().getHeaderPanel(true);"    
    function << " var tb = new Ext.Toolbar(gridHead);"
    function << " tb.add({ text: 'Create New #{model.capitalize}', handler: createResource }, '-', { text: 'Delete Selected #{model.capitalize}', handler: deleteResource });"
    function << " tb.add('-',{ pressed: true,"
    function << " enableToggle: true, text: 'Detailed View',"
    function << " toggleHandler: toggleNews });"
    function << " }}\n"  
    
    function << "function formatBoolean(value) {"
    function << "return (value == 1) ? 'Yes' : '<b class=\"alert\">No</b>';}"      
    
    function << " function deleteResource() {"
    function << " var id = grid.getSelectionModel().getSelected(); "
    function << " if(id){"      
    function << " Ext.MessageBox.confirm('Confirm', 'Are you sure you want to delete this #{model}?', postDelete);"
    function << "  } else {"
    function << " Ext.MessageBox.alert('DOH!', 'Maybe you want to try again after ACTUALLY selecting something?')}}\n"    

    function << " function submitResource(){"
    function << " document.create_resource.submit();}\n"

    function << " function postDelete(btn){"    
    function << " if(btn == 'yes') {"
    function << " var id = grid.getSelectionModel().getSelected();"
    function << " var deleteme = id.get('#{primary_key}');"    
    function << " window.location.href = '/#{model.pluralize}/destroy/' + deleteme;}}\n"

    function << " function editResource(grid, rowIndex) {"
    function << " var id = grid.getSelectionModel().getSelected();"    
    function << " if(id) { "    
    function << " window.location.href = '/#{model.pluralize}/' + id.get('#{primary_key}'); }}\n"

    function << " function createResource() {"    
    function << " if(!dialog) {"    
    function << " dialog = new Ext.BasicDialog('newDialog', {"
    function << " width:630, height:#{height}, shadow:true, minWidth:300, minHeight:#{height}, proxyDrag:true, autoScroll:false, animEl:true });"
    function << " dialog.addKeyListener(27, dialog.hide, dialog);"    
    function << " postBtn = dialog.addButton('Submit', submitResource, this);"
    function << " dialog.addButton('Close', dialog.hide, dialog); }\n"    

    function << " dialog.show();"
    function << " dialog.on('hide', function(){"    
    function << " document.create_resource.reset();})"    
    function << " } }();"    
    function << " Ext.onReady(pageGrid.init, pageGrid, true);"    
    javascript_tag(function)    
  end

end


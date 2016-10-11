Ext.onReady(function() {
	var ds; //hold our data
	var grid; //component
	var columnModel; // definition of the columns

	var gridData = [
	<% for task in @tasks %>
		<% for address in task.person.contact_data.addresses %>
		[	'<%= task.subject_id %>',
			'<%= task.person.name %>',
			'<%= task.body %>',
			'<%= task.frame || task.alert_at.localtime.to_s(:appt) %>',
			'<%= address.street %>', 
			'<%= address.city %>', 
			'<%= address.state %>', 						
			'<%= address.zip %>'			
		],
		<% end %>
	<% end %>
	];		
	
	
	function displayOnMap() {
		totalRecords = ds.getCount();
		for (var x=0; x < ds.getCount(); x++) {
			marker = new CustomPOIMarker(  ds.getAt(x).data.customer, ds.getAt(x).data.task, ds.getAt(x).data.street + '<br />' +ds.getAt(x).data.city + ' ' + ds.getAt(x).data.state + ' ' + ds.getAt(x).data.zip, '0xFF0000', '0xFFFFFF'); 
			address = ds.getAt(x).data.street + ' ' + ds.getAt(x).data.city + ' ' + ds.getAt(x).data.state + ' ' + ds.getAt(x).data.zip;
			map.addMarkerByAddress( marker, address);
		}			
	}
	
	
	function setupDataSource() {
		ds = new Ext.data.Store({
			proxy: new Ext.data.MemoryProxy(gridData),
			reader: new Ext.data.ArrayReader(
				{id: 0}, 
				[
					{name: 'id'},
					{name: 'customer'},
					{name: 'task'},
					{name: 'dueDate'},
					{name: 'street'},
					{name: 'city'},
					{name: 'state'},
					{name: 'zip'},																								
				]
			)
		});
		ds.load();
	}
	
	function getColumnModel() {
		if(!columnModel) {
			columnModel = new Ext.grid.ColumnModel(
				[
					{
						header: 'Customer',
						width: 250,
						sortable: true,
						dataIndex: 'customer'
					},

					{
						header: 'Task',
						width:250,
						sortable: true,
						dataIndex: 'task'
					},
					{
						header: 'Date Due',
						width:100,
						sortable: true,
						dataIndex: 'dueDate'
					}
				]
			);
		}
		return columnModel;
	}
	
	function buildGrid() {
		grid = new Ext.grid.Grid(
			'customers_grid',
			{
				ds: ds,
				cm: getColumnModel(),
				autoSizeColumns: true
			}
		);

		grid.on("rowclick", function(grid) {
			new Ajax.Request('/notes/update_page/' + grid.getSelectionModel().getSelected().data.id, {asynchronous:true, evalScripts:true}); return false;
			// alert(grid.getSelectionModel().getSelected().data.id);
		});

		grid.render();
	}
	
	setupDataSource();
	buildGrid();
	ds.on('load', displayOnMap());

		layout = new Ext.BorderLayout(document.body, {
		north: {
			split:false, 
			initialSize:50
			 }, 
		center: {
			titlebar:false,
			autoScroll: true
			 }
	});
	
	layout.beginUpdate();  
		layout.add('north', new Ext.ContentPanel('header'));
		var innerLayout = new Ext.BorderLayout('content', {
			south: {
				split:true,
				initialSize: 300,
				minSize: 200,
				maxSize: 500,
				autoScroll:true,
				collapsible:true,
				titlebar:true
			},
			center: {
				autoScroll:true,
				titlebar:true
			},
			east: {
				split:true,
				autoScroll:true,
				titlebar:true,
				initialSize: 470,	
			}
		});
		innerLayout.add('east', new Ext.ContentPanel('notes', {title: 'Notes'}));
		innerLayout.add('east', new Ext.ContentPanel('add_note', {title: 'Add Note'}));			
		innerLayout.add('center', new Ext.GridPanel(grid, {title: 'Customers'}));
		innerLayout.add('south', new Ext.ContentPanel('map_pane', {title:'Map'}));
		layout.add('center', new Ext.NestedLayoutPanel(innerLayout));
	layout.endUpdate();
});
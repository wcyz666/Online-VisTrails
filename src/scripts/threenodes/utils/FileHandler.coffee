define [
	'Underscore',
	'Backbone',
	'cs!threenodes/utils/Utils',
	'cs!threenodes/utils/CodeExporter',
	"libs/BlobBuilder.min",
	"libs/FileSaver.min",
	"libs/json2",
], (_, Backbone, Utils) ->
	#"use strict"

	namespace "ThreeNodes",
		FileHandler: class FileHandler extends Backbone.Events
			constructor: (@app, @nodes, @group_definitions) ->
        		_.extend(FileHandler::, Backbone.Events)

			replaceWorkflow:(workflow)->
				@workflow = workflow

			saveLocalFile: () =>
				bb = new BlobBuilder()
				result_string = @getLocalJson()
				bb.append(result_string)
				fileSaver = saveAs(bb.getBlob("application/json;charset=utf-8"), "nodes.json")
				# console.log fileSaver

			exportCode: () =>
				# get the json export and convert it to code
				json = @getLocalJson(false)
				exporter = new ThreeNodes.CodeExporter()
				res = exporter.toCode(json)

				bb = new BlobBuilder()
				bb.append(res)
				fileSaver = saveAs(bb.getBlob("text/plain;charset=utf-8"), "nodes.js")

			getLocalJson: (stringify = true) =>
				res =
					uid: @nodes.indexer.getUID(false)
					workflow: @app.workflow.toJSON()
					nodes: jQuery.map(@nodes.models, (n, i) -> n.toJSON())
					connections: jQuery.map(@nodes.connections.models, (c, i) -> c.toJSON())
					groups: jQuery.map(@group_definitions.models, (g, i) -> g.toJSON())

				if stringify
					return JSON.stringify(res)
				else
					return res

			loadFromJsonData: (txt) =>
				# Parse the json string
				loaded_data = JSON.parse(txt)

				# load workflow model
				workflow = new ThreeNodes.Workflow(loaded_data.workflow)
				@app.replaceWorkflow(workflow)

	        # First recreate the group definitions
				if loaded_data.groups
					for grp_def in loaded_data.groups
						@group_definitions.create(grp_def)

    	    # Create the nodes
				for node in loaded_data.nodes
					if node.type != "Group"
					# Create a simple node
						@nodes.createNode(node)
					else
    	        # If the node is a group we first need to get the previously created group definition
						def = @group_definitions.getByGid(node.definition_id)
						if def
							node.definition = def
							grp = @nodes.createGroup(node)
						else
							console.log "can't find the GroupDefinition: #{node.definition_id}"

			# Create the connections
				for connection in loaded_data.connections
					@nodes.createConnectionFromObject(connection)

				@nodes.indexer.uid = loaded_data.uid
				delay = (ms, func) -> setTimeout func, ms
				delay 1, => @nodes.renderAllConnections()

			loadLocalFile: (e) =>
				# Clear the workspace first
				@trigger("ClearWorkspace")

				# Load the file
				file = e.target.files[0]
				reader = new FileReader()
				self = this
				reader.onload = (e) ->
					txt = e.target.result
					# Call loadFromJsonData when the file is loaded
					self.loadFromJsonData(txt)
				reader.readAsText(file, "UTF-8")

		# Execute event to give output
			executeAndSave: () =>
				#convert to JSON and send to Server
				console.log "execute and save"
				json = @getLocalJson(true)
				res = @sendToServer(json)
				console.log res.responseText
				bb = new BlobBuilder()
				bb.append(res.responseText)
				fileSaver = saveAs(bb.getBlob("text/html;charset=utf-8"), "result.txt")
		# Send Data to the server
			sendToServer: (data) =>
				console.log "sending to server"
				console.log JSON.stringify(data)
				$.ajax
					type: "POST"
					url: "/vistrails"#"http://einstein.sv.cmu.edu:9018/vistrails"
					data: data
					contentType: 'application/json'
					# crossDomain: true
					# dataType: "json"
					cache: false
					async: false
					success: (xml) ->
						console.log "success"
						return xml
					error: (xml) ->
						console.log "error case"
						console.log xml
						return "Error from Server"





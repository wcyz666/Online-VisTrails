CMUOnlineWorkflow
=================

Online VisTrails UI
<h2>Development setup</h2>

This will automatically compile coffescript files to javascript, sass to css and haml to html.

    install node.js 0.8.x or later (http://nodejs.org/)
    install compass (http://compass-style.org/install/)
    install grunt (http://gruntjs.com/getting-started#installing-the-cli)
    cd in ThreeNodes
    npm install -d

<h2> To Run in Development environment </h2>
    cd in ThreeNodes (project folder)
    node server.js
    
<h2>To deploy on server </h2>
    cd in ThreeNodes
    node server.js build
    A "dist" folder is created including the index.html file
    Copy this folder to serve and deploy the index.html file

##  Todos

* ~~clean up: follow github: console logs and coffee generated files~~
* ~~add submit button to replace return kepress event~~
* add filter for user defined field
* refactor the NodeSidebarView: extract the add input port form out as 
	a stand alone view
* clean up the nodeWithCentralTextfield tmpl
* onCodeUpdate is useful? Maybe a better way to determine
* add type informatin to the json result

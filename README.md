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

<h2>Build / Deploy</h2>

    cd in ThreeNodes
    grunt build
    
<h2>To deploy on server </h2>
    cd in Three Nodes
    node server.js build
    A "dest" folder is created including the index.html file
    Copy this folder to serve and deploy the index.html file

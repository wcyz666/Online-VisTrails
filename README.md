CMUOnlineWorkflow
=================

# Online VisTrails UI

## Development setup

This will automatically compile coffescript files to javascript, sass to css and haml to html.

    install node.js 0.8.x or later (http://nodejs.org/)
    install compass (http://compass-style.org/install/)
    install grunt (http://gruntjs.com/getting-started#installing-the-cli)
    cd in ThreeNodes
    npm install -d

## To Run in Development environment 
    cd in ThreeNodes (project folder)
    node server.js
    
## To build and deploy
    cd in ThreeNodes
    node server.js build
    A "dist" folder is created including the index.html file
    Copy this folder to serve and deploy the index.html file




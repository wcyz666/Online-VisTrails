//require('coffee-script') this was existing, modified by Gautam as below
require('coffee-script').register();
// Check for "build" parameter (node server.js build)
var is_build = (process.argv[2] == "build");

global.basePath = __dirname;

if (is_build == false) {
  require(__dirname + '/src/scripts/server/server');
}
else {
  require(__dirname + '/src/scripts/server/build');
}

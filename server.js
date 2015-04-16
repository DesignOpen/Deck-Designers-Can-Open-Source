var Primus = require('primus.io');
var http = require("http");
var express = require("express");
var app = express();
var pub = __dirname + '/_site';
var port = process.env.PORT || 5000;

app.use(express.static(pub));

var server = http.createServer(app)
server.listen(port)

/* Web Socket Server */

console.log("http server listening on %d", port);

var primus = new Primus(server, { transformer: 'websockets', parser: 'JSON' });
console.log("websocket server created")

primus.on('connection', function (spark) {
  console.log("websocket connection open");

  spark.on('slide', function(message) {
    primus.forEach(function (spark, id, connections){
      spark.send('slide', message);
    });
    console.log(message);
  });
})

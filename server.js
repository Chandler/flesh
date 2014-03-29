var http      = require('http')
var proxy     = require('http-proxy');

//test server
var crypto = require('crypto');
var fs = require("fs");
var host = "127.0.0.1";
var port = 8000;
var express = require("express");

var app = express();

// app.use(express.bodyParser())

app.use(express.methodOverride())
   .use(app.router);

var httpProxy = require('http-proxy');

var apiProxy = httpProxy.createProxyServer();

// a very fake authentication endpoint
// app.post("/api/user/login", function(req, res){
//   var fake_credentials = {
//     sasha:    {id: 3, password: "s"},
//     mike:     {id: 2, password: "m"},
//     chandler: {id: 922, password: "c"}
//   }

//   var username = req.body["username"]
//   var password = req.body["password"]

//   var user     = fake_credentials[username]
  
//   if(user && (user["password"] == password)){
//     res.json({
//       authentication_token: require('crypto').createHash('md5').update(username).digest("hex"),
//       id: user["id"]
//     })
//   } else {
//     res.status(401).json({ error: "incorrect password" })
//   }
// });

// app.all("/api/*", function(req, res){ 
//  apiProxy.web(req, res, { target: 'http://127.0.0.1:3000' });
// });


app.all("/api/*", function(req, res){ 
 apiProxy.web(req, res, { target: 'https://flesh.io' });
});


//static files
app.get("/public/*", function(req, res){ 
  res.sendfile(__dirname+"/public/"+req.params[0]);
});



//if it's anything else serve the application
app.get("/*", function(request, res){ 
  res.sendfile(__dirname+"/public/index.html");
});


app.listen(port, host);

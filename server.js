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

app.all("/api/*", function(req, res){ 
 apiProxy.web(req, res, { target: 'http://127.0.0.1:3000' });
});


//static files
app.get("/public/*", function(req, res){ 
  res.sendfile(__dirname+"/public/"+req.params[0]);
});

//a very fake authentication endpoint
app.post("/token", function(req, res){
  var fake_credentials = {
    sasha:    {id: 3, password: "s"},
    mike:     {id: 2, password: "m"},
    chandler: {id: 791, password: "c"}
  }

  var username = req.body["username"]
  var password = req.body["password"]

  var user     = fake_credentials[username]
  
  if(user && (user["password"] == password)){
    res.json({
      access_token: require('crypto').createHash('md5').update(username).digest("hex"),
      token_type: "bearer",
      user_id: user["id"]
    })
  } else {
    res.status(401).json({ error: "incorrect password" })
  }
});

//if it's anything else serve the application
app.get("/*", function(request, res){ 
  res.sendfile(__dirname+"/index.html");
});


app.listen(port, host);

const express = require("express");
const httpProxy = require("http-proxy");

const proxy = httpProxy.createProxyServer(); //the proxy forwards client requests to the respective microservice server

const app = express(); 

app.use("/auth", (req, res)=>{
    proxy.web(req, res, {target: "http://auth:3000"}); 
});

app.use("/products", (req, res)=>{
    proxy.web(req,res, {target:"http://product:3001"});
});

app.use("/orders", (req, res)=>{
    proxy.web(req, res, {target:"http://order:3002"});
});

/*
if we run e.g. PORT=4444 node index.js, we'll use port 4444, otherwise 3003
*/
const port = process.env.PORT || 3003; 

app.listen(port, ()=>{
    console.log(`API Gateway listening on port ${port}`);
})
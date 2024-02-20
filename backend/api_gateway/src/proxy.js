const {createProxyMiddleware}= require("http-proxy-middleware");
const {authMiddleware} = require("./middlewares/authMiddleware");

const setupProxies = (app, routes) =>{
    routes.forEach(r => {
        if(r.auth){
            app.use(r.url, authMiddleware, createProxyMiddleware(r.proxy));
        }else{
            app.use(r.url, createProxyMiddleware(r.proxy));
        }
    });
}

module.exports = {setupProxies};
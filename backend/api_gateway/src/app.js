require('dotenv').config();
const express = require("express");
const {setupProxies}=require("./proxy");
const {ROUTES} = require("./routes");
const {setupLogging} = require("./logging");

/*
if we run e.g. PORT=4444 node index.js, we'll use port 4444, otherwise 3003
*/
const port = process.env.PORT || 3003; 

class App {
    constructor() {
      this.app = express();
      this.setHttpProxy();
      this.setLogging(this.app);
    }
  
    setHttpProxy(){
       setupProxies(this.app, ROUTES);
    }
    
    setLogging(){
        setupLogging(this.app);
    }

    start() {
        this.server = this.app.listen(port, ()=>{
            console.log(`API Gateway listening on port ${port}`);
        })
    }
  
    async stop() {
      await mongoose.disconnect();
      this.server.close();
      console.log("Server stopped");
    }
}
  
module.exports = App;


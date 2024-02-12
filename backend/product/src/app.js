require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
const config = require("./config");
const MessageBroker = require("./utils/messageBroker");
const multer = require('multer');
const ProductController = require("./controllers/productController");
const isAuthenticated = require("./utils/isAuthenticated");
const storage = config.storage;
const upload=multer({storage});
const {productValidator} = require('./utils/validators')

class App {
  constructor() {
    this.app = express();
    this.connectDB();
    this.setMiddlewares();
    this.setRoutes();
    this.setupMessageBroker();
    this.productController = new ProductController();

  }

  async connectDB() {
    await mongoose.connect(config.mongoURI, {
      useNewUrlParser: true,
      user: process.env.DB_USERNAME,
      pass: process.env.DB_PASSWORD,
      useUnifiedTopology: true,
    });
    
    console.log("MongoDB connected");
  }

  async disconnectDB() {
    await mongoose.disconnect();
    console.log("MongoDB disconnected");
  }

  setMiddlewares() {
    this.app.use(express.json());
    this.app.use(express.urlencoded({ extended: false }));
  }

  setRoutes() {
    this.app.post("/api/products", isAuthenticated, upload.single('img'), productValidator, (req,res)=>this.productController.createProduct(req, res));
    this.app.post("/api/buy", isAuthenticated, (req,res)=>this.productController.createProduct(req,res));
    this.app.get("/api/products", isAuthenticated, (req, res)=>this.productController.getAllProducts(req,res)); 
    this.app.get("/api/products/popular", isAuthenticated, (req,res)=>this.productController.getPopularProducts(req,res));
    this.app.get("/api/products/recommended", isAuthenticated, (req,res)=>this.productController.getRecommendedProducts(req,res));
    this.app.get("/api/products/images/:filename", isAuthenticated, (req, res)=>this.productController.getImageById(req,res)); 
    
    //this.app.get("/api/products/:productId", isAuthenticated, (req,res)=>this.productController.getProduct());
    //this.app.put("/api/products/:productId", isAuthenticated, (req,res)=>this.productController.updateProduct(req,res));
  }

  setupMessageBroker() {
    MessageBroker.connect();
  }

  start() {
    this.server = this.app.listen(3001, () =>
      console.log("Server started on port 3001")
    );
  }

  async stop() {
    await mongoose.disconnect();
    this.server.close();
    console.log("Server stopped");
  }
}

module.exports = App;
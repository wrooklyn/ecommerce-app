const Product = require("../models/product");
const messageBroker = require("../utils/messageBroker");
const uuid = require('uuid');
const ProductService = require("../services/productsService");
const {validationResult} = require('express-validator');
const mongoose = require("mongoose");
const config = require("../config");

/**
 * Class to hold the API implementation for the product services
 */
class ProductController {

  constructor() {
    this.createOrder = this.createOrder.bind(this);
    this.getOrderStatus = this.getOrderStatus.bind(this);
    this.ordersMap = new Map();
    this.productService = new ProductService();
  }

  async createProduct(req, res) {
    try {
      const token = req.headers.authorization;
      if (!token) {
        return res.status(401).json({ message: "Unauthorized" });
      }
      const errors = validationResult(req)
      if(errors.isEmpty()){
        const result = await this.productService.createProduct(req);
        res.status(201).json(result);
      }else{
        const url = config.mongoURI; 
        const connect = mongoose.createConnection(url, {
          useNewUrlParser: true,
          useUnifiedTopology:true
        });
        let gfs; 
        connect.once('open', ()=>{
          gfs=new mongoose.mongo.GridFSBucket(connect.db, {bucketName: "images"});
          gfs.delete(req.file.id);
        })
        res.status(422).json({errors: errors.array()})
      }
    } catch (error) {
      res.status(500).json({ message: "Server error" });
    }
  }

  async getAllProducts(req, res, next) {
    try {
      const products = await this.productService.getAllProducts();
      res.status(200).json(products);
    } catch (error) {
      res.status(500).json({ message: "Server error" });
    }
  }

  async getImageById(req, res, next){
    try{
      await this.productService.getImageById(req.params.filename, res);
      
    }catch(error){
      console.log(error);
      res.status(500).json({ message: "Server error" });
    }
  }
  
  async getPopularProducts(req, res, next){
    try{
      const products = await this.productService.getPopularProducts(); 
      res.status(200).json(products);

    }catch(error){
      console.log(error);
      res.status(500).json({message:"Server error"});
    }
  }

  async getRecommendedProducts(req, res, next){
    try{
      const products = await this.productService.getRecommendedProducts(); 
      res.status(200).json(products);

    }catch(error){
      console.log(error);
      res.status(500).json({message:"Server error"});
    }
  }


  async createOrder(req, res, next) {
    try {
      const token = req.headers.authorization;
      if (!token) {
        return res.status(401).json({ message: "Unauthorized" });
      }
  
      const { ids } = req.body;
      const products = await Product.find({ _id: { $in: ids } });
  
      const orderId = uuid.v4(); // Generate a unique order ID
      this.ordersMap.set(orderId, { 
        status: "pending", 
        products, 
        username: req.user.username
      });
  
      await messageBroker.publishMessage("orders", {
        products,
        username: req.user.username,
        orderId, // include the order ID in the message to orders queue
      });

      messageBroker.consumeMessage("products", (data) => {
        const orderData = JSON.parse(JSON.stringify(data));
        const { orderId } = orderData;
        const order = this.ordersMap.get(orderId);
        if (order) {
          // update the order in the map
          this.ordersMap.set(orderId, { ...order, ...orderData, status: 'completed' });
          console.log("Updated order:", order);
        }
      });
  
      // Long polling until order is completed
      let order = this.ordersMap.get(orderId);
      while (order.status !== 'completed') {
        await new Promise(resolve => setTimeout(resolve, 1000)); // wait for 1 second before checking status again
        order = this.ordersMap.get(orderId);
      }
  
      // Once the order is marked as completed, return the complete order details
      return res.status(201).json(order);
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Server error" });
    }
  }
  

  async getOrderStatus(req, res, next) {
    const { orderId } = req.params;
    const order = this.ordersMap.get(orderId);
    if (!order) {
      return res.status(404).json({ message: 'Order not found' });
    }
    return res.status(200).json(order);
  }

}

module.exports = ProductController;
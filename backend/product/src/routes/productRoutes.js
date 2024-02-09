const express = require("express");
const ProductController = require("../controllers/productController");
const isAuthenticated = require("../utils/isAuthenticated");

const router = express.Router();
const productController = new ProductController();

//create new product
router.post("/", isAuthenticated, productController.createProduct);

//api to call when an order is issued, this adds an entry to the queue after retrieving product info
router.post("/buy", isAuthenticated, productController.createOrder);

//retrieve all products
router.get("/", isAuthenticated, productController.getProducts);

//retrieve popular products
//router.get("/popular", isAuthenticated, productController.getPopularProducts);

//retrieve recommended products
//router.get("/recommended", isAuthenticated, productController.getRecommendedProducts);


module.exports = router;
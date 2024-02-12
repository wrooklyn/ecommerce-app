const ProductsRepository = require("../repositories/productsRepository");
const ErrorCodes = require("../utils/errorCodeConstants");

/**
 * Class that ties together the business logic and the data access layer
 */
class ProductsService {
  constructor() {
    this.productsRepository = new ProductsRepository();
  }

  async createProduct(product) {
    try{ 
      const createdProduct = await this.productsRepository.createProduct(product);
      return createdProduct;
    }catch(error){
      return error;
    }
  }
 async getAllProducts() {
  try{
    const products = await this.productsRepository.getAllProducts();
    return products;
  }catch(error){
    return error; 
  }
    
  }

  async getImageById(imageId, res) {
    try{
      await this.productsRepository.getImageById(imageId, res);
    }catch(error){
      console.log(error);
      res.status(500).json({message:"Server error"});
    }
  }

  async getPopularProducts(){
    try{
      var products = await this.productsRepository.getPopularProducts();      
      return {total_size: products.length, type_id: "popular", offset: 0, products: products}; 
    }catch(error){
      return error; 
    }
  }

  async getRecommendedProducts(){
    try{
      var products = await this.productsRepository.getRecommendedProducts();
      return {total_size: products.length, type_id: "recommended", offset: 0, products: products}; 
    }catch(error){
      return error; 
    }
  }

  async getProductById(productId) {
    const product = await this.productsRepository.findById(productId);
    return product;
  }

 
}

module.exports = ProductsService;
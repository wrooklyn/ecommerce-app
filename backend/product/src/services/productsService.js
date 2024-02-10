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
    const products = await this.productsRepository.getAllProducts();
    return products;
  }

  async getImageById(imageId, res) {
    var image = await this.productsRepository.getImageById(imageId, res);
    console.log("servizio");
    console.log(image);
    return image;
  }

  async getProductById(productId) {
    const product = await this.productsRepository.findById(productId);
    return product;
  }

 
}

module.exports = ProductsService;
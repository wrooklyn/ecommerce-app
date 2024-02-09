import ProductsRepository from ".repositories/productsRepository";

/**
 * Class that ties together the business logic and the data access layer
 */
class ProductsService {
  constructor() {
    this.productsRepository = new ProductsRepository();
  }

  async createProduct(product) {
    //make checks 
    const createdProduct = await this.productsRepository.create(product);
    return createdProduct;
  }

  async getProductById(productId) {
    const product = await this.productsRepository.findById(productId);
    return product;
  }

  async getProducts() {
    const products = await this.productsRepository.findAll();
    return products;
  }
}

export default ProductsService;
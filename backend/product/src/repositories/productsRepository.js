const Product = require("../models/product");

/**
 * Class that contains the business logic for the product repository interacting with the product model
 */

class ProductsRepository {
  async createProduct(product) {
    const product = new Product(
      {
        ...product.body,img:product.file.id
      }
    );

    const validationError = product.validateSync();

    if (validationError) {
      return res.status(400).json({ message: validationError.message });
    }

    await product.save({ timeout: 50000 });
//    const createdProduct = await Product.create(product);
    return product.toObject();
  }

  // async findById(productId) {
  //   const product = await Product.findById(productId).lean();
  //   return product;
  // }

  // async findAll() {
  //   const products = await Product.find().lean();
  //   return products;
  // }
}

module.exports = ProductsRepository;
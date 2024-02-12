const Product = require("../models/product");
const mongoose = require("mongoose");
const config = require("../config");
/**
 * Class that contains the business logic for the product repository interacting with the product model
 */

class ProductsRepository {
  async createProduct(product) {

    const newProduct = new Product(
      {
        ...product.body,img:product.file.id
      }
    );

    const validationError = newProduct.validateSync();

    if (validationError) {
      return res.status(400).json({ message: validationError.message });
    }

    newProduct.save({ timeout: 30000 });
    return newProduct.toObject();
  }

  // async findById(productId) {
  //   const product = await Product.findById(productId).lean();
  //   return product;
  // }

  async getAllProducts() {
    const products = await Product.find({});
    return products;
  }

  async getImageById(imageId, res){
      var image; 
      const url = config.mongoURI; 
      const connect = mongoose.createConnection(url, {
        useNewUrlParser: true,
        useUnifiedTopology:true
      });
      let gfs; 
      connect.once('open', async () => {
        gfs = new mongoose.mongo.GridFSBucket(connect.db, { bucketName: "images" });
        image = await gfs.find({ _id: new mongoose.Types.ObjectId(imageId) }).toArray();
        if(image.length>0){
          gfs.openDownloadStreamByName(image[0].filename).pipe(res);
        }
      });

  }

  async getPopularProducts() {
    try{
      const products = await Product.find({category: "popular"});
      return products;
    }catch(error){
      console.log(error);
      return error;
    }
    
  }

  async getRecommendedProducts() {
    try{
      const products = await Product.find({category: "recommended"});
      return products;
    }catch(error){
      console.log(error);
      return error;
    }
    
  }
}

module.exports = ProductsRepository;
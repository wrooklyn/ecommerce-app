require("dotenv").config();
const {GridFsStorage} = require('multer-gridfs-storage');
const path = require('path');
const crypto = require("crypto");

module.exports = {
  port: process.env.PORT || 3001,
  mongoURI: process.env.MONGODB_PRODUCT_URI || "mongodb://localhost/products",
  rabbitMQURI: process.env.RABBITMQ_URI || "amqp://localhost",
  exchangeName: "products",
  queueName: "products_queue",
  storage: new GridFsStorage({
    url: process.env.MONGODB_PRODUCT_URI,
    file: (req, file)=>{
      return new Promise((resolve, reject)=>{
        const token = req.headers.authorization;
        if (!token) {
          return res.status(401).json({ message: "Unauthorized" });
        }
        crypto.randomBytes(16, (err, buf)=>{
          if(err){
            return reject(err);
          }
          const filename=buf.toString('hex')+path.extname(file.originalname);
          const fileInfo={
            filename: filename,
            bucketName: 'images'
          };
          resolve(fileInfo);
        })
      })
    }
  })
};
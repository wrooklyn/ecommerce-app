const mongoose = require("mongoose");

const productSchema = new mongoose.Schema({
  name: { type: String, required: true },
  description: { type: String },
  price: { type: Number, required: true },
  location: {type: String, required:true},
  category: {type: String, required: true},
  createdAt: {type: String, required: false, default: Date.now().toString()},
  updatedAt: {type: String, required: false, default: ""},
  stars: {type: Number, required:false, default:-1},
  img: {type: String, required: false, default:""}
}, { collection : 'products' });

const Product = mongoose.model("Product", productSchema);

module.exports = Product;
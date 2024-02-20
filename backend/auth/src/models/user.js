const mongoose = require("mongoose");

const UserSchema = new mongoose.Schema({
  email: {
    type: String, 
    required: true,
    unique: true
  },
  phone: {
    type: String, 
    required: false,
  },
  name: {
    type: String,
    required: true
  },
  hash: String, 
  salt: String,
  isVerified:{
    type: Boolean,
    default: false
  },
  tokens:[{type: Object}]
});

module.exports = mongoose.model("User", UserSchema);

const mongoose = require("mongoose");

const UserSchema = new mongoose.Schema({
  email: {
    type: String, 
    required: true,
    unique: true
  },
  phone: {
    type: String, 
    required: true,
  },
  name: {
    type: String,
    required: true
  },
  password: {
    type: String,
    required: true
  },
  isVerified:{
    type: Boolean,
    default: false
  },
  
});

module.exports = mongoose.model("User", UserSchema);

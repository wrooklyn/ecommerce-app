const mongoose = require("mongoose");

const TokenSchema = new mongoose.Schema({
userId: {
    type: String,
    ref: "User",
    required: true
},
token: {
    type: String, 
    required: true
}

});

module.exports = mongoose.model("Token", TokenSchema);

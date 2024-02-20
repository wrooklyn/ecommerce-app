require("dotenv").config();

module.exports = {
    secret_key: process.env.SECRET_KEY,
    secret_iv: process.env.SECRET_IV,
    ecnryption_method: process.env.ECNRYPTION_METHOD,
    salt: process.env.SALT
};
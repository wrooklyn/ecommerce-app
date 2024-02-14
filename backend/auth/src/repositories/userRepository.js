const User = require("../models/user");
const Token = require("../models/token");
const {verifyEmail} = require("../utils/utils");

/**
 * Class to encapsulate the logic for the user repository
 */
class UserRepository {
  async createUser(user) {
    try{
      const newUser = await User.create(user); 
      const token= await Token.create({userId: newUser._id, token: require('crypto').randomBytes(16).toString('hex')});
      const link = `http://localhost:3003/auth/confirm/${token.token}`;
      const res = await verifyEmail(newUser.email, link);
      if(res.success){
        return {success:true, msg: "Operation successful! Please verify your email to complete your registration."};
      }
    }catch(err){
      return {success:false, msg: err};
    }
  }

  async getUserByEmail(email) {
    return await User.findOne({ email });
  }

  async getToken(token){
    return await Token.findOne({token: token});
  }

  async getTokenByUserId(userId){
    return await Token.findOne({userId: userId});
  }

  async deleteToken(tokenId){
    return await Token.findByIdAndRemove(tokenId);
  }

  async updateUser(userId){
    return await User.updateOne({_id: userId}, {$set:{isVerified: true}});
  }
}

module.exports = UserRepository;
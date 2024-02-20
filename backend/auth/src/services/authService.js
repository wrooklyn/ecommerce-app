const UserRepository = require("../repositories/userRepository");
const User = require("../models/user");
const {genPassword, validPassword, issueJWT} = require("../utils/utils");

/**
 * Class to hold the business logic for the auth service interacting with the user repository
 */
class AuthService {
  constructor() {
    this.userRepository = new UserRepository();
  }

  async findUserByEmail(email) {
    const user = await this.userRepository.getUserByEmail(email);
    return user;
  }

  async login(email, password) {
    const user = await this.userRepository.getUserByEmail(email);

    if (!user) {
      return { success: false, message: "The email address "+email+" is not associated with any account." };
    }

    const isPasswordValid = validPassword(password, user.hash, user.salt);

    if (!isPasswordValid) {
      return { success: false, message: "Invalid username or password" };
    }

    if(!user.isVerified){
      return {success: false, message: 'Your account has not been verified.'}
    }

    const token = issueJWT(user);
    const saltHash = genPassword(token);
    const salt = saltHash.salt; 
    const hash = saltHash.hash; 

    let oldTokens = user.tokens || [];
    if(oldTokens.length){
      oldTokens=oldTokens.filter( tok => {
        const timeDiff = (Date.now() - parseInt(tok.signedAt))/1000;
        if(timeDiff<604800){ //1w expiration time in seconds
          return tok;
        }
      })
    }
    await User.findByIdAndUpdate(user._id, {tokens:[...oldTokens, {hash:hash, salt:salt, signedAt: Date.now().toString()}]});
    return { success: true, token };
  }

  async loginWithGoogle(user) {
    let resUser = await this.userRepository.getUserByEmail(user.email);

    if (!resUser) {
      //create new user 
      resUser = await this.userRepository.registerWithGoogle(user);      
    }

    const token = issueJWT(resUser);
    const saltHash = genPassword(token);
    const salt = saltHash.salt; 
    const hash = saltHash.hash; 

    let oldTokens = user.tokens || [];
    if(oldTokens.length){
      oldTokens=oldTokens.filter( tok => {
        const timeDiff = (Date.now() - parseInt(tok.signedAt))/1000;
        if(timeDiff<604800){ //1w expiration time in seconds
          return tok;
        }
      })
    }
    await User.findByIdAndUpdate(resUser._id, {tokens:[...oldTokens, {hash:hash, salt:salt, signedAt: Date.now().toString()}]});
    return { success: true, token };
    
  }

  async register(user) {
    const saltHash = genPassword(user.password);
    const salt = saltHash.salt; 
    const hash = saltHash.hash; 
  
    return await this.userRepository.createUser({email: user.email, phone: user.phone? user.phone:'', name: user.name, hash: hash, salt: salt});
  }

  async getToken(token){
    return await this.userRepository.getToken(token);
  }

  async getTokenByUserId(userId){
    return await this.userRepository.getTokenByUserId(userId);
  }
  
  async deleteToken(tokenId){
    return await this.userRepository.deleteToken(tokenId);
  }

  async updateUser(userId){
    return await this.userRepository.updateUser(userId);
  }
  async deleteTestUsers() {
    // Delete all users with a username that starts with "test"
    await User.deleteMany({ username: /^test/ });
  }

  async logout(newTokens, userId){
    return await this.userRepository.logout(newTokens, userId);
  }
}

module.exports = AuthService;
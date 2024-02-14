const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const UserRepository = require("../repositories/userRepository");
const config = require("../config");
const User = require("../models/user");

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

    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      return { success: false, message: "Invalid username or password" };
    }

    if(!user.isVerified){
      return {success: false, message: 'Your account has not been verified.'}
    }

    const token = jwt.sign({ id: user._id }, config.jwtSecret);

    return { success: true, token };
  }

  async register(user) {
    const salt = await bcrypt.genSalt(10);
    user.password = await bcrypt.hash(user.password, salt);

    return await this.userRepository.createUser(user);
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
}

module.exports = AuthService;
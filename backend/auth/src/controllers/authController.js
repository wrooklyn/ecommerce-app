const AuthService = require("../services/authService");
const {validationResult} = require('express-validator');
const {verifyEmail, validPassword} = require("../utils/utils");
const jwt = require("jsonwebtoken");
require("dotenv").config();
const {OAuth2Client} = require('google-auth-library');


/**
 * Class to encapsulate the logic for the auth routes
 */

class AuthController {
  constructor() {
    this.authService = new AuthService();
  }

  async loginWithGoogle(req, res){
    try{
      const expectedAudience = process.env.GOOGLE_AUTH_IOS_CLIENT_ID;
      const issuers = ['https://accounts.google.com'];
      const oAuth2Client = new OAuth2Client();
      const user = req.body;
      const idToken = user.idToken; 
      const tokenVerification = await oAuth2Client.verifyIdToken({
        idToken,
        expectedAudience,
        issuers
      });
      if (tokenVerification.payload['sub'] && tokenVerification.payload['email_verified']) {
        //should check req.body email and name parameters with tokenVerification.payload[email] and [name] parameters
        const result = await this.authService.loginWithGoogle(user);
        
        if (result.success) {
          res.status(200).json({ token: result.token });
        } else {
          res.status(401).json({ message: result.message });
        }
      }
    }catch(e){
      res.status(400).json({ message: e.message });
    }
    
  }
  
  async login(req, res) {
    const errors = validationResult(req)
    if(!errors.isEmpty()){
       res.status(400).json({errors: errors.array()})
    }else{
      const result = await this.authService.login(req.body.email, req.body.password);
      if (result.success) {
        res.status(200).json({ token: result.token });
      } else {
        res.status(401).json({ message: result.message });
      }
    }
  }

  async register(req, res) {
    const user = req.body;
    try {
      const errors = validationResult(req)
      if(!errors.isEmpty()){
        res.status(422).json({errors: errors.array()})
      }else{

        const existingUser = await this.authService.findUserByEmail(user.email);
    
        if (existingUser) {
          console.log("An account with this email already exists!");
          throw new Error("An account with this email already exists!");
        }
    
        const result = await this.authService.register(user);
        if(result.success){
          res.status(200).json(result.msg);

        }else{
          res.status(400).json({ message: result.msg });
        }
      }
    } catch (err) {
      res.status(400).json({ message: err.message });
    }
  }

  async confirmEmail(req, res){
    try{
      const token = await this.authService.getToken(req.params.token);
      await this.authService.updateUser(token.userId);
      await this.authService.deleteToken(token._id);
      res.status(200).json({msg: "Email has been verified!"});
    }catch(error){
      res.status(500).json({msg:"Server error"});
    }
  }

  async resendEmail(req, res){
    try{
      const errors = validationResult(req)
      if(!errors.isEmpty()){
        res.status(422).json({errors: errors.array()})
      }else{
        //check if user exists 
        const user = await this.authService.findUserByEmail(req.body.email);
        //check if user is verified
        if(user && user.isVerified){
          return res.status(400).send({ msg: 'This account has already been verified Please log in.' });
        }
        const token = await this.authService.getTokenByUserId(user._id);
        const link = `http://localhost:3003/auth/confirm/${token.token}`;
        const result = await verifyEmail(user.email, link);
        if(result.success){
          return res.status(200).json({ msg: "Operation successful! Please verify your email to complete your registration."});
        }
      }
    }catch(error){
      console.log(error);
      res.status(500).json({msg:"Server error"});
    }
  }

  async getProfile(req, res) {
    const userId = req.user.id;

    try {
      const user = await this.authService.getUserById(userId);
      res.json(user);
    } catch (err) {
      res.status(400).json({ message: err.message });
    }
  }

  async logout(req,res){
    const token = req.headers.authorization.split(' ')[1];
    if(!token){
      return res.status(401).json({message: "Unauthorized Access"});
    }
    const tokens = req.user.tokens;
    const newTokens = tokens.filter(t=>!validPassword(token, t.hash, t.salt));
    await this.authService.logout(newTokens, req.user._id);
    res.status(200).json({success: true, message: "Logged out successfully!", sig: token.split('.')[2]});
  }
}

module.exports = AuthController;
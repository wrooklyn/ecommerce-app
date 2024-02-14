const AuthService = require("../services/authService");
const {validationResult} = require('express-validator');
const {verifyEmail} = require("../utils/utils");
const jwt = require("jsonwebtoken");
require("dotenv").config();

/**
 * Class to encapsulate the logic for the auth routes
 */

class AuthController {
  constructor() {
    this.authService = new AuthService();
  }

  async isLogged(req, res){
    const authHeader = req.headers.authorization;
    console.log(req);
    if (!authHeader) {
      return res.status(401).json({ message: "Unauthorized" });
    }

    // Extract the token from the header
    const token = authHeader.split(" ")[1];

    try {
      // Verify the token using the JWT library and the secret key
      const decodedToken = jwt.verify(token, process.env.JWT_SECRET);
      req.user = decodedToken;
      res.status(200).json({message: "Authorized"});
    } catch (err) {
      console.error(err);
      return res.status(401).json({ message: "Unauthorized" });
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
          throw new Error(result.msg);
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

}

module.exports = AuthController;
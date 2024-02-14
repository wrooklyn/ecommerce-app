const express = require("express");
const mongoose = require("mongoose");
const config = require("./config");
const authMiddleware = require("./middlewares/authMiddleware");
const AuthController = require("./controllers/authController");
const {registerValidator, loginValidator, emailValidator} = require('./utils/validators')

class App {
  constructor() {
    this.app = express();
    this.authController = new AuthController();
    this.connectDB();
    this.setMiddlewares();
    this.setRoutes();
  }

  async connectDB() {
    await mongoose.connect(config.mongoURI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log("MongoDB connected");
  }

  async disconnectDB() {
    await mongoose.disconnect();
    console.log("MongoDB disconnected");
  }

  setMiddlewares() {
    this.app.use(express.json());
    this.app.use(express.urlencoded({ extended: false }));
  }

  setRoutes() {
    this.app.get("/isLogged", (req, res)=>this.authController.isLogged(req,res));
    this.app.post("/login", loginValidator, (req, res) => this.authController.login(req, res));
    this.app.post("/register", registerValidator, (req, res) => this.authController.register(req, res));
    this.app.get("/dashboard", authMiddleware, (req, res) => res.json({ message: "Welcome to dashboard" }));
    this.app.get("/confirm/:token", (req, res) => this.authController.confirmEmail(req, res));
    this.app.post("/resend", emailValidator, (req, res) => this.authController.resendEmail(req, res));
  }

  start() {
    this.server = this.app.listen(3000, () => console.log("Server started on port 3000"));
  }

  async stop() {
    await mongoose.disconnect();
    this.server.close();
    console.log("Server stopped");
  }
}

module.exports = App;
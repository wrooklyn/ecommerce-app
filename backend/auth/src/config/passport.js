const fs=require('fs');
const path=require('path');
const User = require("../models/user");
const JwtStrategy = require('passport-jwt').Strategy;
const ExtractJwt = require('passport-jwt').ExtractJwt;

const pathToKey = path.join(__dirname, 'pub.pem');
const PUB_KEY = fs.readFileSync(pathToKey, 'utf-8');

const options={
    jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
    secretOrKey: PUB_KEY,
    algorithms:['RS256']
};

//passport.authenticate callback 
const JWTstrategy = new JwtStrategy(options, async (payload, done)=>{
    await User.findOne({_id:payload.sub}).then((user)=>{
        if(user){
            return done(null, user);
        }
        else{
            return done(null,false);
        }
    }).catch(err=>done(err,null));
});

module.exports = {JWTstrategy}
const nodemailer = require('nodemailer');
const crypto = require('crypto');
const jwt = require('jsonwebtoken');
const fs = require('fs');
const path = require('path');

const pathToKey = path.join(__dirname,'../config', 'private.pem');
const PRIV_KEY = fs.readFileSync(pathToKey, 'utf-8');

const verifyEmail = async(email, link)=>{
    try{
        let transporter = nodemailer.createTransport({
                service: "Gmail",
                auth:{
                    user: process.env.VERIFICATION_MAIL_USER,
                    pass: process.env.VERIFICATION_MAIL_PASS
                }
            }
        );
        let info = await transporter.sendMail({
            from:process.env.VERIFICATION_MAIL_USER,
            to:email,
            subject: "Food Express - Account Verification",
            text: "Welcome",
            html: `<span>Please, click <a href=${link}>here</a> to verify your email.</span>`
        })
        return {success: true, msg: "Operation successful."};
    }catch(err){
        console.log(err);
        return {success:false, msg: err}; 
    }
}

const validPassword=(password, hash, salt)=>{
    var hashVerify=crypto.pbkdf2Sync(password, salt, 100000, 64, 'sha512').toString('hex');
    return hash === hashVerify;
}

const genPassword=(password)=>{
    var salt = crypto.randomBytes(32).toString('hex');
    var genHash = crypto.pbkdf2Sync(password, salt, 100000, 64, 'sha512').toString('hex');
    return{
        salt: salt,
        hash: genHash
    }
}

const issueJWT = (user)=>{
    const _id = user._id; 
    const payload = {
        sub: _id,
        exp: Math.floor((Date.now() / 1000 + 604800)), //1 week
        iat: Math.floor(Date.now()/1000),
    };
    const signedToken = jwt.sign(payload, PRIV_KEY, {algorithm:'RS256', issuer: 'auth-service'});
    return signedToken;
}
module.exports = { verifyEmail, validPassword, genPassword, issueJWT}


const jwt = require('jsonwebtoken');
const fs=require('fs');
const path=require('path');
const RedisService = require("../services/redisService");
const {genHash, encryptData} = require('../utils/utils');
const redisService = new RedisService();
const pathToKey = path.join(__dirname, '../', 'pub.pem');
const PUB_KEY = fs.readFileSync(pathToKey, 'utf-8');

const cacheToken = async (responseBuffer, proxyRes, req, res) => {
    
    let responseObj = {
        statusCode: 0,
        errorMsg: "",
        data: {}
    }

    const token = responseBuffer.toString('utf8').split('"')[3];
    const response = responseBuffer.toString('utf8');
    if(!token){
        res.statusCode = 401; 
        return response; 
    }else{
        //verify signature of jwt 
        let payload; 
        try{
            payload=jwt.verify(token, PUB_KEY, {algorithms: ['RS256'], issuer: 'auth-service'});
        }catch(err){
            if (err instanceof jwt.JsonWebTokenError) {
                // if the error thrown is because the JWT is unauthorized, return a 401 error
                res.statusCode = 401; 
                return response.replaceAll(token, "Unauthorized Access."); 
            }
            res.statusCode = 400; 
            return response; 
        }
        //should check jti parameter as well (jwtid)

        //key = hash of the signature
        //note we're not using a salt to generate the hash because otherwise it would not be possible to retrieve the entry from the cache
        const hash = genHash(token.split('.')[2]); 
        const cacheValue = token.split('.')[0]+"."+token.split('.')[1];
        const encryptedValue = encryptData(cacheValue);
        //value = headers, payload, salt (encrypt headers and payload for better confidentiality)
        try{
            await redisService.set({
                key: hash, 
                value: encryptedValue, 
                timeType: "EX", 
                time: payload.exp
            });
            //modify response body and return 
            return responseBuffer.toString('utf8').replaceAll(token, token.split('.')[2]);
        }catch(err){
            responseObj.data=err;
            responseObj.statusCode=500;
            responseObj.errorMsg = "Server Error.";
            return res.status(responseObj.statusCode).json(responseObj); 
        }
    }
}

const revokeToken = async (responseBuffer, proxyRes, req, res) => {
    
    let responseObj = {
        statusCode: 0,
        errorMsg: "",
        data: {}
    }
    responseBuffer=JSON.parse(responseBuffer);
    const sig = responseBuffer.sig;

    if(!sig){
        res.statusCode = 500; 
        response="Internal Server Error.";
        return responseBuffer; 
    }else{
        const hash = genHash(sig); 
        try{
            await redisService.del(hash);
            res.statusCode=200;
            delete responseBuffer.sig;
            return JSON.stringify(responseBuffer);
        }catch(err){
            responseObj.data=err;
            responseObj.statusCode=500;
            responseObj.errorMsg = "Server Error.";
            return res.status(responseObj.statusCode).json(responseObj); 
        }
    }
}

module.exports = { cacheToken, revokeToken }
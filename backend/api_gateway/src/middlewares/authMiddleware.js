const RedisService = require("../services/redisService");
const {genHash, matchHash, decryptData} = require('../utils/utils');
const redisService = new RedisService();

const authMiddleware = async (req, res, next) => {
    
    let responseObj = {
        statusCode: 0,
        errorMsg: "",
        data: {}
    }
    if(!req.headers.authorization){
        responseObj.data = "";
        responseObj.statusCode = 401
        responseObj.errorMsg = "Unauthorized access."
        return res.status(responseObj.statusCode).json(responseObj)
        
    }
    console.log("AuthMiddleware");
    const hashedSignature = genHash(req.headers.authorization.split(' ')[1]);

    //hash signature, get hash of the signature from redis
    try{
        let reply = await redisService.get(hashedSignature)
        if(reply==null){
            responseObj.data = "";
            responseObj.statusCode = 401
            responseObj.errorMsg = "Unauthorized access."
            return res.status(responseObj.statusCode).json(responseObj)
        }else{
            //substitute the signature in the header with the jwt retrieved from the cache + signature received from the header
            req.headers.authorization = "Bearer "+decryptData(reply)+"."+req.headers.authorization.split(' ')[1];
            next(); //forward request through to proxy middleware
        }
    }catch(err){
        console.log(err);
        responseObj.data=err;
        responseObj.statusCode=500;
        responseObj.errorMsg = "Server Error.";
        return res.status(responseObj.statusCode).json(responseObj); 
    }
}

module.exports = { authMiddleware }
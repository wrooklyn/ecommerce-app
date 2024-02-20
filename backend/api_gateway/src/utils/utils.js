const crypto = require('crypto');
const config = require("./config");

const key = crypto
  .createHash('sha512')
  .update(config.secret_key)
  .digest('hex')
  .substring(0, 32)
const encryptionIV = crypto
  .createHash('sha512')
  .update(config.secret_iv)
  .digest('hex')
  .substring(0, 16)

const genHash=(signature)=>{
    var genHash = crypto.pbkdf2Sync(signature, config.salt, 100000, 64, 'sha512').toString('hex');
    return genHash ;
}

const matchHash=(signature, hash)=>{
    var hashVerify=crypto.pbkdf2Sync(signature, config.salt, 100000, 64, 'sha512').toString('hex');
    return hash === hashVerify;
}

const encryptData=(data)=> {
    const cipher = crypto.createCipheriv(config.ecnryption_method, key, encryptionIV)
    return Buffer.from(
      cipher.update(data, 'utf8', 'hex') + cipher.final('hex')
    ).toString('base64') 
}

const decryptData = (encryptedData) =>{
    const buff = Buffer.from(encryptedData, 'base64')
    const decipher = crypto.createDecipheriv(config.ecnryption_method, key, encryptionIV)
    return (
      decipher.update(buff.toString('utf8'), 'hex', 'utf8') +
      decipher.final('utf8')
    )
}
module.exports={genHash, matchHash, encryptData, decryptData};
const redis = require('redis');

class RedisService {
  constructor() {
    this.client = redis.createClient({
      socket:{host:'redis',port:6379, password:'redis-pass-key'},
    });
    this.handleErrors();
  }

  handleErrors(){
    this.client.on('error', (err) => {
        console.log(err);
        console.log('Error occured while connecting or accessing redis server');
    });
  }

  async set({ key, value, timeType, time }) {
    try{
        await this.client.connect();
        await this.client.set(key, value, timeType, time);
        await this.client.disconnect();
    }catch(err){
        return err; 
    }
  }

  async get(key) {
    try{
        await this.client.connect();
        const result = await this.client.get(key);
        console.log(key);
        await this.client.disconnect();
        return result;
    }catch(err){
        return err;
    }
  }

  async del(key) {
    try{
        await this.client.connect();
        const result = await this.client.del(key);
        await this.client.disconnect();
        return result;
    }catch(err){
        return err;
    }
  }
}

module.exports = RedisService;

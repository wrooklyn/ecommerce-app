const {cacheToken, revokeToken} = require('./middlewares/cacheMiddleware');
const { responseInterceptor } = require('http-proxy-middleware');

const ROUTES=[
    {
        url: '/auth/logout',
        auth: true,
        rateLimit: {
            windowMs: 15 * 60 * 1000,
            max: 5
        },
        proxy: {
            target: "http://auth:3000",
            changeOrigin: true,
            pathRewrite: {
                [`^/auth`]: '',
            },
            selfHandleResponse: true, 
            onProxyRes: responseInterceptor((responseBuffer,proxyRes, req, res)=>revokeToken(responseBuffer, proxyRes, req, res)), 
        }
    },
    {
        url: '/auth/login',
        auth: false,
        rateLimit: {
            windowMs: 15 * 60 * 1000,
            max: 5
        },
        proxy: {
            target:  "http://auth:3000",
            changeOrigin: true,
            pathRewrite: {
                [`^/auth`]: '',
            },
            selfHandleResponse: true, 
            onProxyRes: responseInterceptor((responseBuffer,proxyRes, req, res)=>cacheToken(responseBuffer, proxyRes, req, res)), 
        }
    },
    {
        url: '/auth/google',
        auth: false,
        rateLimit: {
            windowMs: 15 * 60 * 1000,
            max: 5
        },
        proxy: {
            target:  "http://auth:3000",
            changeOrigin: true,
            pathRewrite: {
                [`^/auth`]: '',
            },
            selfHandleResponse: true, 
            onProxyRes: responseInterceptor((responseBuffer,proxyRes, req, res)=>cacheToken(responseBuffer, proxyRes, req, res)), 
        }
    },
    {
        url: '/auth',
        auth: false,
        rateLimit: {
            windowMs: 15 * 60 * 1000,
            max: 5
        },
        proxy: {
            target:  "http://auth:3000",
            changeOrigin: true,
            pathRewrite: {
                [`^/auth`]: '',
            },
        }
    },
    {
        url: '/products/api/createProduct',
        auth: true,
        rateLimit: {
            windowMs: 15 * 60 * 1000,
            max: 5
        },
        proxy: {
            target: "http://product:3001",
            changeOrigin: true,
            pathRewrite: {
                [`^/products`]: '',
            },
        }
    },
    {
        url: '/products/api/products',
        auth: false,
        rateLimit: {
            windowMs: 15 * 60 * 1000,
            max: 5
        },
        proxy: {
            target: "http://product:3001",
            changeOrigin: true,
            pathRewrite: {
                [`^/products`]: '',
            },
        }
    },
]

module.exports = {ROUTES};


// this.app.use("/orders", (req, res)=>{
//     proxy.web(req, res, {target:"http://order:3002"});
// });
const {body} = require( 'express-validator');

module.exports={
    registerValidator:[
        body('email').exists().withMessage('Email is a required field').isEmail().withMessage('Email format is not valid.'),
        body('password').exists().withMessage('Password is a required field.').isStrongPassword().withMessage('Password is not strong enough.'),
        body('name').exists().withMessage('Name is a required field.').isString().withMessage('Name must be a string.'),
        body('phone').exists().withMessage('Phone is a required field').isFloat({min:0}).withMessage('Price must be a number greater than 0.'),
    ],
    loginValidator:[
        body('email').exists().withMessage('Email is a required field').isEmail().withMessage('Email format is not valid.'),
        body('password').exists().withMessage('Password is a required field.')
    ],
    emailValidator:[
        body('email').exists().withMessage('Email is a required field').isEmail().withMessage('Email format is not valid.'),
    ]
};
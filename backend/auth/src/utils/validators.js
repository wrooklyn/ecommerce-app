const {body} = require( 'express-validator');

module.exports={
    registerValidator:[
        body('email').exists().withMessage('Email is a required field').isEmail().withMessage('Email format is not valid.'),
        body('password').exists().withMessage('Password is a required field.').isStrongPassword().withMessage('Password is not strong enough.'),
        body('name').exists().withMessage('Name is a required field.').isString().withMessage('Name must be a string.'),
    ],
    loginValidator:[
        body('email').exists().withMessage('Email is a required field').isEmail().withMessage('Email format is not valid.'),
        body('password').exists().withMessage('Password is a required field.')
    ],
    emailValidator:[
        body('email').exists().withMessage('Email is a required field').isEmail().withMessage('Email format is not valid.'),
    ]
};
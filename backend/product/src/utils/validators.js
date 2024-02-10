const {body} = require( 'express-validator');

module.exports={
    productValidator:[
        body('name').exists().withMessage('Name is a required field').isString().withMessage('Name must be a string.'),
        body('description').exists().withMessage('Description is a required field.').isString().withMessage('Description must be a string.'),
        body('location').exists().withMessage('Location is a required field.').isString().withMessage('Location must be a string.'),
        body('price').exists().withMessage('Price is a required field').isFloat({min:0}).withMessage('Price must be a number greater than 0.'),
        body('category').exists().withMessage( 'Category field is required.').isString().withMessage('Category must be a string.').isIn(['popular', 'recommended']).withMessage('Category must be either popular or recommended'),
      ]
};
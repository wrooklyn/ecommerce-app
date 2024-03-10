# E-commerce Mobile Application

This repository contains the code for an e-commerce application I built to learn about Flutter and microservices architecture. 

I've always been interested in building cross-platform applications with scalable architecture and this project was perfect to experiment with new technologies while building something useful. 

In this documentation, I'll start by sharing insights into the backend setup of our e-commerce app. I'll cover why certain design choices were made, with a particular focus on security, authentication and authorization across our services. 

I'll add in details about how the frontend ties into everything, as well as testing and deployment strategies as the project evolves. 

## Backend Overview 

The backend is composed of several services, including Authentication, Order Management, Product Management and Infrastructure services like RabbitMQ, Redis, and multiple databases (AuthDB, OrderDB, ProductDB).

### Microservices 

* <b>Authentication Service</b>: Handles user registration, login, logout and security tokens. 
* <b>Product Service</b>: Oversees product inventory, details and categorization. 
* <b>Order Service</b>: Manages order processing and tracking. 

### Infrastructure Services

* <b>RabbitMQ</b>: Facilitates message queing for inter-service communication. 
* <b>Redis</b>: Provides caching mechanisms for quick data retrieval and session management.  
* <b>Databases</b>: Separate databases for authentication, orders, and products to isolate responsibilities. 

## API Gateway 
The API Gateway acts as the primary entry point for all incoming requests to the backend services, enabling a secure, scalable and efficient microservice architecture.

The API Gateway makes use of Express.js to route incoming HTTP requests to the appropriate backend service (Authentication, Order, Product) based on predefined routes. It plays an important role in security, by implementing authentication and authorization for these services. 

### Core Components 

* <b>Express Server (`app.js`)</b>: Initializes the API Gateway with necessary middleware for request handling, logging and dynamic routing to microservices. 
* <b>Proxy Middleware (`proxy.js`)</b>: Handles the routing of requests to corresponding microservices with support for authentication and rate limiting.
* <b>Routes Configuration (`routes.js`)</b>: Defines API endpoints, their authentication requirements and the mapping to target microservices. It also manages token operations like caching and revocation. 

### Main Functionalities
* <b>Request Routing</b>: Directs client requests to the appropriate microservice while abstracting the underlying architecture from the client.
* <b>Authentication and Authorization</b>: Implements the Split Token approach for enhanced security, ensuring only authorized requests are processed. 
* <b>Rate Limiting</b>: Protects against denial-of-service (DoS) attacks by limiting the rate of incoming requests. 

### Security Measures 
The API Gateway employs a Split Token approach for authentication, where: 
* The JWT is split into two parts: signature + payload and header.
* The signature is returned to the client as an opaque token and the payload and header are cached in the API Gateway, keyed by a hashed version of the signature. 

This method prevents the full JWT from being stored or transmitted in its entirety, significantly reducing the risk of token theft or misuse. It also reduces overhead by eliminating the need for token introspection at the API Gateway. 

### Scalability
The architecture supports scalable operations through:
* <b>Independent Service Scaling</b>: Each microservice can be scaled based on its own demand without affecting others.
* <b>Load Balancing</b>: Distributes incoming traffic across multiple instances of the API Gateway and microservices. 
* <b>Caching</b>: Makes use of Redis to reduce the load on services and improve response times. 

### Considerations and Future Works 

The API Gateway decouples clients from direct service interactions, facilitating flexibility in service development and deployment. It centralizes security, simplifying management of authentication and authorization. It also enables traffic control and provides a mechanism to monitor and mitigate potential abuse. 

However, it also introduces a few disadvantages. For example, it represents a critical point in the infrastructure and requires robust high-availability strategies to avoid becoming a single point of failure. 
It also adds compleixty to the system, requiring careful configuration and monitoring. 

Future improvements include:
* Implementation of multiple instances of the API Gateway with a load balancer to ensure reliability. 
* Explore adopting a service mesh for more granular traffic management and security. 

## Authentication Service

The authentication service is responsible for managing user authentication, including registration, login, email verification and integration with third-party authentication providers like Google. 

The service leverages several Node.js modules to ensure secure user authentication and management:

* `Express.js` for server framework.
* `Mongoose` for MongoDB interactions.
* `Passport.js` with JWT (JSON Web Tokens) for authentication.
* `Nodemailer` for email verification.
* `crypto` and `jsonwebtoken` for password hashing and token management. 

### Security Measures 

* <b>Password Hashing and Salting</b>: User passwords are hashed and salted using `crypto` module, making it virtually impossible to reverse-engineer the original password from the stored hash. 
* <b>JWT for Secure Tokens</b>: Secure JWTs are issued for user authentication, signed with a private key (`RS256` algorithm), ensuring that tokens can be verified but not tampered with or forged.
* <b>Email Verification</b>: Ensures that users verify their email addresses before they can use the application, reducing the risk of spam or unauthorized registrations. 
* <b>OAuth2 with Google</b>: Provides users with the option to authenticate using their Google accounts, leveraging Google's robust security measures. 
* <b>Validation Middlewares</b>: Request validations for login, registration and email operations help prevent common web vulnerabilities like SQL injection or cross-site scripting (XSS). 
* <b>Secure Environment Variables</b>: Sensitive information, including database credentials and token secrets are stored in environment variables, not hard-coded into the appliation. 

### Workflow 

The authentication service works as follows: 

1. <b>User Registration</b>: Users register with email, password, and optionally, phone number. Passwords are hashed and salted for storage. A verification token is generated and sent to the user's email.
2. <b>Email Verification</b>: Users must verify their email by clicking a link that hits the /confirm/:token endpoint, marking their account as verified.
3. <b>Login</b>: Upon login, the user's password is validated. A JWT token is issued if the credentials are valid and the email is verified. This token is intercepted by the API Gateway, which splits the token, returns the signature to the client for subsequent requests to other services, and caches the payload/header. 
4. <b>OAuth2 Authentication</b>: Users can also log in using their Google accounts. The service validates the Google ID token, creates or updates the user record, and issues a JWT. 
5. <b>Logout and Token Management</b>: Authenticated users can log out, and their current token is invalidated to prevent further use. 

### API Documentation 

#### 1. User Registration

* <b>Method</b>: `POST`
* <b>URL</b>: `/register`
* <b>Body Parameters</b>:
  * `email`: user's email (required)
  * `password`: user's password (must be strong as per `isStrongPassword` validation)
  * `name`: user's name (required)
* <b>Success Response</b>:
  * <b>Code</b>: `200 OK` 
  * <b>Content</b>:  `"Operation successful! Please verify your email to complete your registration."`
* <b>Error Response</b>: 
  * <b>Code</b>: `422 Unprocessable Entity` (Validation Error)
  * <b>Content</b>:  List of validation errors. 
  * <b>Code</b>: `400 Bad Request` (Email Already Exists)
  * <b>Content</b>:  `"An account with this email already exists!"`

##### Example 

`POST /register`
```json
{
  "email": "user@example.com",
  "password": "SecurePassword123!",
  "name": "John Doe"
}
```

#### 2. User Login

* <b>Method</b>: `POST`
* <b>URL</b>: `/login`
* <b>Body Parameters</b>:
  * `email`: user's email (required)
  * `password`: user's password (required)
* <b>Success Response</b>:
  * <b>Code</b>: `200 OK` 
  * <b>Content</b>:  `{"token": "JWT_TOKEN_HERE"}`
* <b>Error Response</b>: 
  * <b>Code</b>: `400 Bad  Request` (Validation Error)
  * <b>Content</b>:  List of validation errors. 
  * <b>Code</b>: `401 Unauthorized` (Invalid Credentials)
  * <b>Content</b>:  `"Invalid username or password"`
  * <b>Code</b>: `401 Unauthorized` (Account not verified.)
  * <b>Content</b>:  `"Your account has not been verified."`
  

##### Example 

`POST /login`
```json
{
  "email": "user@example.com",
  "password": "SecurePassword123!"
}
```

#### 3. Google Login

* <b>Method</b>: `POST`
* <b>URL</b>: `/google`
* <b>Body Parameters</b>:
  * `idToken`: Google ID token obtained from the client-side Google sign-in process. 
* <b>Success Response</b>:
  * <b>Code</b>: `200 OK` 
  * <b>Content</b>:  `{"token": "JWT_TOKEN_HERE"}`
* <b>Error Response</b>: 
  * <b>Code</b>: `400 Bad  Request` 
  * <b>Content</b>:  `"Invalid or expired Google ID token."`  

##### Example 

`POST /google`
```json
{
  "idToken": "GOOGLE_ID_TOKEN_HERE"
}
```

#### 4. Email Verification

* <b>Method</b>: `GET`
* <b>URL</b>: `/confirm/:token`
* <b>URL Parameters</b>:
  * `token`: Verification token sent via email.
* <b>Success Response</b>:
  * <b>Code</b>: `200 OK` 
  * <b>Content</b>:  `"Email has been verified!"`
* <b>Error Response</b>: 
  * <b>Code</b>: `500 Internal  Server Error` 
  * <b>Content</b>:  `"Server Error."`  

##### Example 
`GET /confirm/12345abcdef`

#### 5. Resend Verification Email

* <b>Method</b>: `POST`
* <b>URL</b>: `/resend`
* <b>Body Parameters</b>:
  * `email`: User's email address (required). 
* <b>Success Response</b>:
  * <b>Code</b>: `200 OK` 
  * <b>Content</b>:  `"Operation successful! Please verify your email to complete your registration."`
* <b>Error Response</b>: 
  * <b>Code</b>: `422 Unprocessable Entity` (Validation Error)
  * <b>Content</b>:  List of validation errors. 
  * <b>Code</b>: `400 Bad Request` (Account already verified.)
  * <b>Content</b>: `"This account has already been verified. Please log in."`
  * <b>Code</b>: `500 Internal Server Error` (Server Error)
  * <b>Content</b>:  `"Server Error"`

##### Example 

`POST /resend`

```json
{
  "email": "user@example.com"
}
```

#### 6. User Logout

* <b>Method</b>: `GET`
* <b>URL</b>: `/logout`
* <b>Headers</b>: `Authorization`: `Bearer OPAQUE_TOKEN_HERE`
* <b>Success Response</b>:
  * <b>Code</b>: `200 OK` 
  * <b>Content</b>:  
  ```json 
  { "success": true, "message": "Logged out successfully!" }
* <b>Error Response</b>: 
  * <b>Code</b>: `401 Unauthorized`
  * <b>Content</b>:  `"Unauthorized Access.`

##### Example 

`GET /logout`
`Authorization`: `Bearer OPAQUE_TOKEN_HERE`

Remember to replace placeholders like JWT_TOKEN_HERE with actual data from your application's context.

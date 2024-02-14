class AppConstants{
  static const String APP_NAME = "PandaExpress";
  static const int APP_VERSION = 1; 

  static const String BASE_URL = "http://localhost:3003";
  static const String GET_ALL_PRODUCTS="/products/api/products";
  static const String POPULAR_PRODUCT_URI="/products/api/products/popular";
  static const String RECOMMENDED_PRODUCT_URI="/products/api/products/recommended";
  static const String LOGGED_IN_URI="/auth/isLogged";
  //static const String DRINKS_PRODUCT_URI="/products/api/products/drinks";

  static const String REGISTRATION_URI="/auth/register";
  static const String LOGIN_URI="/auth/login";

  static const String TOKEN="AuthToken";
  static const String USER_EMAIL = "";
  static const String USER_PASS = "";
  static const String UPLOAD_URL = "/products/api/products/images/";

  static const String CART_LIST="cart-list";
  static const String CART_HISTORY_LIST="cart-history-list";
}
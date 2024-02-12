class AppConstants{
  static const String APP_NAME = "PandaExpress";
  static const int APP_VERSION = 1; 

  static const String BASE_URL = "http://localhost:3003";
  static const String GET_ALL_PRODUCTS="/products/api/products";
  static const String POPULAR_PRODUCT_URI="/products/api/products/popular";
  static const String RECOMMENDED_PRODUCT_URI="/products/api/products/recommended";
  //static const String DRINKS_PRODUCT_URI="/products/api/products/drinks";

  static const String TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY1YzkwYjUyNGRhZjU0MGU2MWUxYjZkNSIsImlhdCI6MTcwNzY3NDQ1OH0.CChWLSbE3CjGwNarDbALMV5gmDHkzhql0d6eBVhitcI";
  static const String UPLOAD_URL = "/products/api/products/images/";

  static const String CART_LIST="cart-list";
  static const String CART_HISTORY_LIST="cart-history-list";
  static const Map<String, String> HEADERS={
      'Content-type':'application/json; charset=UTF-8',
      'Authorization': 'Bearer $TOKEN',
    };
}
import 'package:ecommerce/controllers/cart_controller.dart';
import 'package:ecommerce/controllers/popular_product_controller.dart';
import 'package:ecommerce/controllers/recommended_product_controller.dart';
import 'package:ecommerce/data/api/api.dart';
import 'package:ecommerce/data/repository/cart_repo.dart';
import 'package:ecommerce/data/repository/popular_product_repo.dart';
import 'package:ecommerce/data/repository/recommended_product_repo.dart';
import 'package:ecommerce/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  //load dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  //api client
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.BASE_URL));
  
  //repos
  //NOTE, whatever name we use in repo file for the api client, we have to use the same in the constructor of the repo file
  Get.lazyPut(() => PopularProductRepo(apiClient: Get.find())); //Getx will find the client url for us
  Get.lazyPut(() => RecommendedProductRepo(apiClient: Get.find())); 
  Get.lazyPut(() => CartRepo(sharedPreferences:Get.find())); 

  //controllers
  Get.lazyPut(() => PopularProductController(popularProductRepo: Get.find()));
  Get.lazyPut(() => RecommendedProductController(recommendedProductRepo: Get.find()));
  Get.lazyPut(() => CartController(cartRepo: Get.find()));

}
import 'package:ecommerce/pages/food_details/popular_food_detail.dart';
import 'package:ecommerce/pages/food_details/recommended_food_detail.dart';
import 'package:ecommerce/pages/home/main_food_page.dart';
import 'package:get/get.dart';

class RouteHelper{
  static const String homePage="/";
  static const String popularFood="/popular-food";
  static const String recommendedFood="/recommended-food";
  static String getHomePage()=>'$homePage';
  static String getPopularFood (int pageId)=>'$popularFood?pageId=$pageId';
  static String getRecommendedFood (int pageId)=>'$recommendedFood?pageId=$pageId';

  static List<GetPage> routes = [
    GetPage(
      name: homePage, 
      page: (){
        return const MainFoodPage();
      }
    ),

    GetPage(
      name: popularFood, 
      page: (){
        var pageId=Get.parameters['pageId'];
        return PopularFoodDetail(pageId:int.parse(pageId!));
      },
      transition: Transition.fadeIn
    ),

    GetPage(
      name: recommendedFood, 
      page: (){
        var pageId=Get.parameters['pageId'];
        return RecommendedFoodDetail(pageId:int.parse(pageId!));
      },
      transition: Transition.fadeIn,
    ),
  ]; 
}
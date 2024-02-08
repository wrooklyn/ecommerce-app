import 'package:ecommerce/pages/cart/cart.dart';
import 'package:ecommerce/pages/food_details/popular_food_detail.dart';
import 'package:ecommerce/pages/food_details/recommended_food_detail.dart';
import 'package:ecommerce/pages/home/home_page.dart';
import 'package:ecommerce/pages/splash/splash_page.dart';
import 'package:get/get.dart';

class RouteHelper{
  static const String splashScreen = "/splash-screen";
  static const String homePage="/";
  static const String popularFood="/popular-food";
  static const String recommendedFood="/recommended-food";
  static const String cart="/cart";
  static String getSplashScreen ()=>'$splashScreen';
  static String getHomePage()=>'$homePage';
  static String getPopularFood (int pageId, String prevPage)=>'$popularFood?pageId=$pageId&page=$prevPage';
  static String getRecommendedFood (int pageId, String prevPage)=>'$recommendedFood?pageId=$pageId&page=$prevPage';
  static String getCart (String prevPage)=>'$cart?prevPage=$prevPage';

  static List<GetPage> routes = [
    GetPage(
      name: splashScreen, 
      page: (){
        return const SplashScreen();
      }
    ),

    GetPage(
      name: homePage, 
      page: (){
        return const HomePage();
      }
    ),

    GetPage(
      name: popularFood, 
      page: (){
        var pageId=Get.parameters['pageId'];
        var prevPage=Get.parameters['page'];
        return PopularFoodDetail(pageId:int.parse(pageId!), page: prevPage!);
      },
      transition: Transition.fadeIn
    ),

    GetPage(
      name: recommendedFood, 
      page: (){
        var pageId=Get.parameters['pageId'];
        var prevPage=Get.parameters['page'];
        return RecommendedFoodDetail(pageId:int.parse(pageId!), page: prevPage!);
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: cart, 
      page: (){
        var prevPage=Get.parameters['prevPage']!;
        return CartPage(prevPage: prevPage);
      },
      transition: Transition.fadeIn,
    ),
  ]; 
}
import 'package:get/get.dart';

class Dimensions{
  //get context lies inside the get x package
  static double screenHeight = Get.context!.height; 
  static double screenWidth = Get.context!.width; 

  //Take for example the height of the image container, whatever device we're in, we want it to 
  //be around 220, that should be based on a factor: e.g. 844/220 , which gives us our factor.
  //Consider that the one making the turoial is working on an iphone 12, so the height he's starting from is 844
  static double pageView = screenHeight/2.64;
  static double pageViewContainer = screenHeight/3.84; 
  static double pageViewTextContainer = screenHeight/6.4; 

  //dynamic heights - padding/margin
  static double height10 = screenHeight/84.4;
  static double height15 = screenHeight/56.27;
  static double height20 = screenHeight/42.2;
  static double height25 = screenHeight/35;
  static double height30 = screenHeight/28.13;
  static double height35 = screenHeight/20;
  static double height45 = screenHeight/18.76;
  
  //dynamic widths - padding/margin
  static double width10 = screenHeight/84.4;
  static double width15 = screenHeight/56.27;
  static double width20 = screenHeight/42.2;
  static double width30 = screenHeight/28.13;

  static double font14 = screenWidth/30;
  static double font15 = screenWidth/25;
  static double font20 = screenHeight/42.2; 
  static double font26 = screenHeight/32.46;
  static double font16 = screenHeight/52;
  
  static double radius15 = screenHeight/56.27;
  static double radius20 = screenHeight/42.2; 
  static double radius30 = screenHeight/28.13; 
  
  //icon size
  static double iconSize24 = screenHeight/41; 
  static double iconSize16 = screenHeight/52;
  static double iconSize18 = screenHeight/45;

  static double listViewImgSize = screenWidth/3.25; 

  //popualr food detail
  static double popularFoodImgSize=screenHeight/2.41;

  //bottom height
  static double bottomHeightBar = screenHeight/7.03;

  //sliver height
  static double sliverHeight = screenHeight/17;
}
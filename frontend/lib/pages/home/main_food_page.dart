import 'package:ecommerce/controllers/popular_product_controller.dart';
import 'package:ecommerce/controllers/recommended_product_controller.dart';
import 'package:ecommerce/pages/home/food_page_body.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:ecommerce/utils/dimensions.dart';
import 'package:ecommerce/widgets/big_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/small_text.dart';

class MainFoodPage extends StatefulWidget {
  const MainFoodPage({Key? key}): super(key:key) ;

  @override
  State<MainFoodPage> createState() => _MainFoodPageState();
}

class _MainFoodPageState extends State<MainFoodPage> {
  Future<void> _loadResource() async {
    await Get.find<PopularProductController>().getPopularProductList();
    await Get.find<RecommendedProductController>().getRecommendedProductList();
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadResource,
      child: Column(
        children:[
          //header
          // ignore: avoid_unnecessary_containers
          Container(
            //add scrolling parameter
            child: Container(
              //adding margin 
              margin: EdgeInsets.only(top:Dimensions.height45, bottom:Dimensions.height15),
              padding: EdgeInsets.only(left:Dimensions.width20, right:Dimensions.width20),
              child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      //column's default property is to be at the top
                      children: [
                        BigText(text:"Country", color: AppColors.mainColor),
                        Row(
                          children: [
                              SmallText(text:"City", color: Colors.black54),
                              const Icon(Icons.arrow_drop_down_rounded)
                          ]
                        ,)
                      ],),
                    Center(
                      child: Container(
                          //row's default property is to put its children vertically centered
                          //the container is using row's default property
                          width: Dimensions.height45,
                          height: Dimensions.height45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radius15),
                            color: AppColors.mainColor,
                          ),
                          child: Icon(Icons.search, color: Colors.white, size:Dimensions.iconSize24), 
                        ),
                    )
                ],
              )
            ),
          ),
          //body
          const Expanded(child: SingleChildScrollView(
            child: FoodPageBody(),
          ))
        ]
      ),
    );
  }
}
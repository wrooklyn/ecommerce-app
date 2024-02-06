import 'package:ecommerce/controllers/cart_controller.dart';
import 'package:ecommerce/controllers/popular_product_controller.dart';
import 'package:ecommerce/controllers/recommended_product_controller.dart';
import 'package:ecommerce/routes/route_helper.dart';
import 'package:ecommerce/utils/app_constants.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:ecommerce/utils/dimensions.dart';
import 'package:ecommerce/widgets/app_icon.dart';
import 'package:ecommerce/widgets/big_text.dart';
import 'package:ecommerce/widgets/bold_title.dart';
import 'package:ecommerce/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer';

class CartPage extends StatelessWidget {
  
  String prevPage="screen"; 

  CartPage({super.key, required this.prevPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children:[
            Positioned(
              top: Dimensions.height20*3,
              left: Dimensions.width30,
              right: Dimensions.width30,
              child: prevPage!="screen"? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  GestureDetector(
                    onTap: (){
                      Get.back();
                    }, 
                    child: Icon(Icons.arrow_back_ios, color: AppColors.darkBlue, size:Dimensions.iconSize18*1.3)
                  ),
                  BoldTitle(text: "Cart", color: AppColors.darkBlue, size: Dimensions.font26*0.9),
                  GestureDetector(
                    onTap: (){

                    }, 
                    child: Icon(Icons.delete_outline_rounded, color: AppColors.darkBlue, size: Dimensions.iconSize18*1.4)),
                ]
              ): Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  BoldTitle(text: "Shopping Cart", color: AppColors.darkBlue, size: Dimensions.font26*0.9),
                  GestureDetector(
                    onTap: (){

                    }, 
                    child: Icon(Icons.delete_outline_rounded, color: AppColors.darkBlue, size: Dimensions.iconSize18*1.4)),
                ]
              )
            ),
            Positioned(
              top: Dimensions.height20*5, 
              left: Dimensions.width15,
              right: Dimensions.width15,
              bottom:0,
              child: Container(
                child: GetBuilder<CartController>(builder:(controller){
                  return ListView.builder(
                    itemCount: controller.getCart.length, 
                    padding: EdgeInsets.only(top:Dimensions.height20),
                    itemBuilder: (_, index){
                      return Container(
                        color: Colors.white, 
                        margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, bottom: Dimensions.height15),
                        child: Row(
                          children: [
                            //image section
                              GestureDetector(
                                onTap: (){
                                  var popularIndex = Get.find<PopularProductController>().popularProductList.indexOf(controller.getCart[index].product!);
                                  Get.smartManagement;
                                  if(popularIndex>=0){
                                    Get.toNamed(RouteHelper.getPopularFood(popularIndex, "cart"));
                                  }else{
                                    var recommendedIndex = Get.find<RecommendedProductController>().recommendedProductList.indexOf(controller.getCart[index].product!);
                                    Get.toNamed(RouteHelper.getRecommendedFood(recommendedIndex, "cart"));
                                  }
                                },
                                child: Container(
                                  width: Dimensions.listViewImgSize,
                                  height: Dimensions.listViewImgSize, 
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(Dimensions.radius20), 
                                      bottomLeft: Radius.circular(Dimensions.radius20)
                                    ),
                                    color: Colors.white,
                                    boxShadow: const [
                                        BoxShadow(
                                          color: Color(0xFFe8e8e8),
                                          blurRadius: 3.0, 
                                          offset: Offset(6,5)
                                        ),
                                        BoxShadow(
                                          color: Colors.white,
                                          offset: Offset(-5,0)
                                        ),
                                        BoxShadow(
                                          color: Colors.white,
                                          offset: Offset(5,0)
                                        )
                                    ],
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          "${AppConstants.BASE_URL}${AppConstants.UPLOAD_URL}${controller.getCart[index].img!}"
                                        )
                                    )
                                  ),
                                ),
                              ),
                              Expanded( //force container to take all the available space
                                child:  Container(
                                  height:Dimensions.listViewImgSize,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(Dimensions.radius20), 
                                      bottomRight: Radius.circular(Dimensions.radius20),
                                    ),
                                    color: const Color(0xfff4f6f5),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0xFFe8e8e8),
                                        blurRadius: 3.0, 
                                        offset: Offset(5,5)
                                      ),
                                      BoxShadow(
                                        color: Color(0xfff4f6f5),
                                        offset: Offset(-5,0)
                                      ),
                                      BoxShadow(
                                        color: Color(0xfff4f6f5),
                                        offset: Offset(5,0)
                                      )
                                    ]
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(top: Dimensions.height15,left:Dimensions.width15, right: Dimensions.width15, bottom: Dimensions.height15,),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        BoldTitle(text: controller.getCart[index].name!, size:Dimensions.font16),
                                        SmallText(text: controller.getCart[index].description!, maxLines: 1, color: const Color(0xffa7a9a8)),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children:[
                                                      GestureDetector(
                                                    onTap:(){
                                                      controller.addItem(controller.getCart[index].product!, -1);
                                                    },
                                                    child: AppIcon(icon: Icons.remove, 
                                                          size: Dimensions.height15*1.7, 
                                                          iconColor: Colors.white, 
                                                          backgroundColor: AppColors.mainColor,
                                                          iconSize: Dimensions.iconSize18,),
                                                  ),
                                                  SizedBox(width: Dimensions.width15),
                                                  BigText(text: "${controller.getCart[index].quantity}", size: Dimensions.font20*0.95),                                                 
                                                  SizedBox(width: Dimensions.width15),
                                                  GestureDetector(
                                                    onTap:(){
                                                      controller.addItem(controller.getCart[index].product!, 1);
                                                    }, 
                                                    child: AppIcon(icon: Icons.add, 
                                                          size: Dimensions.height15*1.7, 
                                                          iconColor: Colors.white, 
                                                          backgroundColor: AppColors.mainColor,
                                                          iconSize: Dimensions.iconSize18,
                                                          )
                                                  )
                                                  ]
                                                ),
                                                BoldTitle(text: "\$${controller.getCart[index].price}", size: Dimensions.font16*1.15)
                                            ],
                                        )
                                      ],
                                    )
                                  )
                                ),
                              )
                            ],)
                        );
                    },
                  );
                })
              )
            )
          ]
        ),
        bottomNavigationBar: GetBuilder<CartController>(builder:(controller){
        return Container(
            height:Dimensions.bottomHeightBar*1.6,
            padding: EdgeInsets.only(
                top:Dimensions.height15, 
                bottom:Dimensions.height35, 
                left: Dimensions.width20, 
                right:Dimensions.width20
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimensions.radius30), topRight: Radius.circular(Dimensions.radius30)),
              color: const Color.fromARGB(255, 252, 251, 251), 
              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(255, 240, 238, 238),
                                  blurRadius: 4.0,
                                  offset: Offset(0,-3)
                                ),
                            ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Container(
                  padding: EdgeInsets.only(
                    top:Dimensions.height15, 
                    left: Dimensions.width20, 
                    right: Dimensions.width20
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Row(
                        children: [
                          BoldTitle(text: "Total", size: Dimensions.font20),
                          SizedBox(width: Dimensions.width10),
                          SmallText(text: "(VAT included)",  size: Dimensions.font20/1.5),
                        ],
                      ),
                      BoldTitle(text: "\$ ${controller.totalAmount}", size: Dimensions.font20),
                    ]
                  )
                ),
                GestureDetector(
                  onTap:(){
                    controller.addToHistory();
                  },
                  child: Container(
                    width: double.maxFinite,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: Dimensions.width15, right: Dimensions.width15),
                    padding: EdgeInsets.only(
                      top:Dimensions.height15, 
                      bottom: Dimensions.height15, 
                      left: Dimensions.width20, 
                      right: Dimensions.width20
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius30),
                      color: AppColors.mainColor
                    ),
                    child: BoldTitle(text:"Checkout", color: Colors.white)
                    
                  )
                ),
              ]
            )
          );
        }
      ),
    );
  }
}
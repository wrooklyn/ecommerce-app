import 'package:ecommerce/controllers/cart_controller.dart';
import 'package:ecommerce/controllers/popular_product_controller.dart';
import 'package:ecommerce/routes/route_helper.dart';
import 'package:ecommerce/utils/app_constants.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:ecommerce/utils/dimensions.dart';
import 'package:ecommerce/widgets/app_icon.dart';
import 'package:ecommerce/widgets/big_text.dart';
import 'package:ecommerce/widgets/expandable_text.dart';
import 'package:ecommerce/widgets/food_column_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class PopularFoodDetail extends StatelessWidget {

  int pageId; 
  String page; 

  PopularFoodDetail({Key? key, required this.pageId, required this.page,}):super(key:key);

  @override
  Widget build(BuildContext context) {
    var productController = Get.find<PopularProductController>();
    var product=productController.popularProductList[pageId];
    productController.initProduct(product, Get.find<CartController>());

    return Scaffold(
      body: Stack(
        children:[
          Positioned(
            left:0,
            right:0,
            child: Container(
              width: double.maxFinite,
              height: Dimensions.popularFoodImgSize, 
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit:BoxFit.cover,
                  image: NetworkImage(
                    AppConstants.BASE_URL+AppConstants.UPLOAD_URL+product.img!
                  )
                )
              )
            )
          ),
          Positioned(
            top:Dimensions.height45,
            left:Dimensions.width20,
            right: Dimensions.width20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                GestureDetector(
                  onTap: (){
                    // if(page=="cart"){
                    //   Get.toNamed(RouteHelper.getCart());
                    // }else{
                    //   Get.toNamed(RouteHelper.getHomePage());
                    // }
                    Get.back();
                    
                  },
                  child: AppIcon(icon: Icons.arrow_back_ios, size: Dimensions.height35),
                ),
                GetBuilder<PopularProductController>(builder: (controller){
                  return GestureDetector(
                        onTap: (){
                          Get.toNamed(RouteHelper.getCart("popular"));
                        },
                        child: Stack(
                          children: [
                            AppIcon(icon: Icons.shopping_bag_outlined, size: Dimensions.height35),
                            controller.totalItems>=1? 
                            Positioned(
                              right:0, 
                              top:0,
                              child:Container(
                                width: Dimensions.iconSize24,
                                height: Dimensions.iconSize24,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.mainColor
                                ),
                                child:BigText(
                                      text:controller.totalItems.toString(), 
                                      size:Dimensions.font13,
                                      color:Colors.white
                                ),
                                ),
                              ):Container()
                              ]
                          )
                  );
                })
              ]
            )
          ),
          Positioned(
            left:0,
            right:0,
            bottom:0,
            top:Dimensions.popularFoodImgSize-20,
            child: Container(
              padding: EdgeInsets.only(left:Dimensions.width20, right: Dimensions.width20, top: Dimensions.height20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Dimensions.radius20),
                  topLeft: Radius.circular(Dimensions.radius20)
                ),
                color: Colors.white
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FoodColumnDetail(text:product.name!),
                  SizedBox(height:Dimensions.height20),
                  BigText(text: "Description"),
                  SizedBox(height: Dimensions.height15),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ExpandableText(text: product.description!)

                    ),
                  )
                ],
              )
            )
          )
        ]
      ),
      bottomNavigationBar: GetBuilder<PopularProductController>(builder:(productController){
        return Container(
          color: Colors.white, 
          height:Dimensions.bottomHeightBar,
          padding: EdgeInsets.only(
              top:Dimensions.height20, 
              bottom:Dimensions.height20, 
              left: Dimensions.width20, 
              right:Dimensions.width20
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Container(
                padding: EdgeInsets.only(
                  top:Dimensions.height15, 
                  bottom: Dimensions.height15, 
                  left: Dimensions.width20, 
                  right: Dimensions.width20
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius15), 
                  color: AppColors.buttonBackgroundColor,
                  boxShadow: const [
                              BoxShadow(
                                color: Color(0xFFe8e8e8),
                                blurRadius: 3.0, 
                                offset: Offset(0,5)
                              ),
                              
                          ],
                ),
                child: Row(
                  children:[
                    GestureDetector(
                      onTap: (){
                        productController.setQuantity(false);
                      },
                      child: Icon(Icons.remove, color: AppColors.signColor)

                    ),
                    SizedBox(width: Dimensions.width10),
                    BigText(text: productController.inCartItems.toString()),
                    SizedBox(width: Dimensions.width10),
                    GestureDetector(
                      onTap:(){
                        productController.setQuantity(true);
                      },
                      child: Icon(Icons.add, color:AppColors.signColor)
                    )
                  ]
                )
              ),
              GestureDetector(
                onTap:(){
                  productController.addItem(product);
                },
                child: Container(
                  padding: EdgeInsets.only(
                    top:Dimensions.height15, 
                    bottom: Dimensions.height15, 
                    left: Dimensions.width20, 
                    right: Dimensions.width20
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    color: AppColors.mainColor
                  ),
                  child: BigText(text:"\$${product.price!} | Add to Cart", color: Colors.white)
                  
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
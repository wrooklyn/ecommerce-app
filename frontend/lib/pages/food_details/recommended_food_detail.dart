import 'package:ecommerce/controllers/cart_controller.dart';
import 'package:ecommerce/controllers/popular_product_controller.dart';
import 'package:ecommerce/controllers/recommended_product_controller.dart';
import 'package:ecommerce/data/api/api.dart';
import 'package:ecommerce/routes/route_helper.dart';
import 'package:ecommerce/utils/app_constants.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:ecommerce/utils/dimensions.dart';
import 'package:ecommerce/widgets/app_icon.dart';
import 'package:ecommerce/widgets/big_text.dart';
import 'package:ecommerce/widgets/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecommendedFoodDetail extends StatelessWidget {
  
  final int pageId; 
  final String page; 
  const RecommendedFoodDetail({Key? key, required this.pageId, required this.page}):super(key:key);

  //slivers are widgets with special effects 
  @override
  Widget build(BuildContext context) {
    var product = Get.find<RecommendedProductController>().recommendedProductList[pageId];
    var productController = Get.find<PopularProductController>();
    var apiClient = Get.find<ApiClient>();
    productController.initProduct(product, Get.find<CartController>());

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers:[
          SliverAppBar(
            automaticallyImplyLeading: false,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                GestureDetector(
                  onTap: (){
                    Get.back();
                  },
                  child: AppIcon(icon: Icons.arrow_back_ios, size: Dimensions.height35),
                ),
                GetBuilder<PopularProductController>(builder: (controller){
                  return GestureDetector(
                        onTap:(){
                          Get.toNamed(RouteHelper.getCart("recommended"));
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
            ),
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(Dimensions.sliverHeight),
              child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Dimensions.radius20),
                  topLeft: Radius.circular(Dimensions.radius20)
                  ),
                  color: Colors.white
                ),
                height: Dimensions.height30
              )
            ),
            pinned: true,
            backgroundColor: Colors.white,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                  AppConstants.BASE_URL+AppConstants.UPLOAD_URL+product.img!,
                  headers: apiClient.mainHeaders, 
                  width: double.maxFinite,
                  fit: BoxFit.cover
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.only(top:Dimensions.height15, left: Dimensions.height25, right: Dimensions.height25),
                child: Column(
                  children: [
                    Center(child: BigText(size: Dimensions.font26, text:product.name!)),
                    SizedBox(height: Dimensions.height20),
                    Center(child: ExpandableText(height:1.6, text:product.description!))
                  ],
                ),
              )
          )
        ]
      ),
      bottomNavigationBar: GetBuilder<PopularProductController>(builder: (controller){
        return Column(
          mainAxisSize: MainAxisSize.min,
          children:[
            Container(
              padding: EdgeInsets.only(
                left:Dimensions.width20*2.5,
                right: Dimensions.width20*2.5,
                top:Dimensions.height30,
                bottom:Dimensions.height15),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap:(){
                        controller.setQuantity(false);
                      },
                      child: AppIcon(icon: Icons.remove, 
                            size: Dimensions.height35, 
                            iconColor: Colors.white, 
                            backgroundColor: AppColors.mainColor,
                            iconSize: Dimensions.iconSize18,),
                    ),
                    BigText(text: "\$ ${product.price} x ${controller.inCartItems}", size: Dimensions.font26),
                    GestureDetector(
                      onTap:(){
                        controller.setQuantity(true);
                      }, 
                      child: AppIcon(icon: Icons.add, 
                            size: Dimensions.height35, 
                            iconColor: Colors.white, 
                            backgroundColor: AppColors.mainColor,
                            iconSize: Dimensions.iconSize18)
                    )
                    
                  ],
              )
            ),
            Container(
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
                    child: Icon(
                      Icons.favorite,
                      color: AppColors.darkPink
                    )
                  ),
                  GestureDetector(
                    onTap:(){
                      controller.addItem(product);
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
                      child: BigText(text:"\$ ${product.price} | Add to Cart", color: Colors.white)
                    )
                  )
                ]
              )
            ),
          ]
        );
      },)
    );
  }
}
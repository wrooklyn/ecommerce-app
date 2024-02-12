// ignore_for_file: library_private_types_in_public_api

import 'package:dots_indicator/dots_indicator.dart';
import 'package:ecommerce/controllers/popular_product_controller.dart';
import 'package:ecommerce/controllers/recommended_product_controller.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/routes/route_helper.dart';
import 'package:ecommerce/utils/app_constants.dart';
import 'package:ecommerce/utils/dimensions.dart';
import 'package:ecommerce/widgets/food_column_detail.dart';
import 'package:ecommerce/widgets/icon_and_text.dart';
import 'package:ecommerce/widgets/list_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';
import '../../widgets/big_text.dart';
import '../../widgets/small_text.dart';

class FoodPageBody  extends StatefulWidget {
  const FoodPageBody ({super.key});

  @override
  _FoodPageBodyState createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody > {
  PageController pageController = PageController(viewportFraction: 0.86);
  //variables needed for "slider animation"
  var _currPageValue = 0.0; 
  final double _scaleFactor=0.8;
  final double _height = Dimensions.pageViewContainer;
  
  @override 
  void initState(){ //it is a method inside any stateful class, but in order to use it we need to override it 
    super.initState();
    //to get the currentPageValue, as we go back and forth, we need to attach a listener to this page controller
    pageController.addListener(() {
      setState(() {
          _currPageValue=pageController.page!;
      });
    });
  }

  //to avoid memory leaks, we implement dispose method
  @override
  void dispose(){
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Column(
      children: [
        GetBuilder<PopularProductController>(builder:(popularProducts){
          // ignore: sized_box_for_whitespace
          return popularProducts.isLoaded? Container(
            //to overlap widgets, we use stack
            //to allow scrolling, use page builder 
            height: Dimensions.pageView,              
            child: PageView.builder(
              controller: pageController, 
              itemCount: popularProducts.popularProductList.length, //position starts from 0 and it's connected to the number of items
              itemBuilder: (context, position){
              return _buildPageItem(position, popularProducts.popularProductList[position]);
            })
            
          ) : Container(
              margin: EdgeInsets.only(bottom:Dimensions.height30),
              child: CircularProgressIndicator(
                color: AppColors.mainColor,
                strokeWidth: Dimensions.height10/3,
              )
          );
        }),
        GetBuilder<PopularProductController>(builder: (popularProducts){
          return DotsIndicator(
            dotsCount: popularProducts.popularProductList.isEmpty?1:popularProducts.popularProductList.length,
            position: _currPageValue,
            decorator: DotsDecorator(
              activeColor: AppColors.mainColor,
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
          );
        }),
        //Popular Category
        SizedBox(height:Dimensions.height20),
        Container(
          margin: EdgeInsets.only(left:Dimensions.width30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BigText(text: "Recommended"),
              SizedBox(width: Dimensions.width10),
              Container(
                margin: const EdgeInsets.only(bottom:3),
                child:BigText(text:".", color:Colors.black26),
              ),
              SizedBox(width: Dimensions.width10,),
              Container(
                margin: const EdgeInsets.only(bottom:4),
                child: SmallText(text: "Food Pairing", color: Colors.black26)
              )
            ]
          )
        ),
        //List
        GetBuilder<RecommendedProductController>(builder: (recommendedProduct){
          return recommendedProduct.isLoaded? ListView.builder(
          //remember that list view takes the height of its parent
            physics:const NeverScrollableScrollPhysics(),
            itemCount: recommendedProduct.recommendedProductList.length, 
            shrinkWrap: true,
            padding: EdgeInsets.only(top:Dimensions.height20),
            itemBuilder: (context, index){
              return GestureDetector(
                onTap:(){
                  Get.toNamed(RouteHelper.getRecommendedFood(index, "home"));
                },
                child: Container(
                  margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, bottom: Dimensions.height15),
                  child: Row(
                    children: [
                      //image section
                        Container(
                          width: Dimensions.listViewImgSize,
                          height: Dimensions.listViewImgSize, 
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Dimensions.radius20), 
                              bottomLeft: Radius.circular(Dimensions.radius20)
                            ),
                            color: Colors.white38,
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
                                  "${AppConstants.BASE_URL}${AppConstants.UPLOAD_URL}${recommendedProduct.recommendedProductList[index].img!}",headers: AppConstants.HEADERS
                                )
                            )
                          ),
                        ),
                        Expanded( //force container to take all the available space
                          child:  Container(
                            height:Dimensions.listViewImgSize,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(Dimensions.radius20), 
                                bottomRight: Radius.circular(Dimensions.radius20)
                              ),
                              color: Colors.white70,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xFFe8e8e8),
                                  blurRadius: 3.0, 
                                  offset: Offset(5,5)
                                ),
                                BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(-5,0)
                                ),
                                BoxShadow(
                                  color: Colors.white,
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
                                  ListText(text: recommendedProduct.recommendedProductList[index].name!),
                                  SmallText(text: recommendedProduct.recommendedProductList[index].description!, maxLines: 1,),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconAndTextWidget(icon: Icons.circle_sharp, 
                                                          text: "Normal", 
                                                          iconColor: AppColors.iconColor1,
                                                          ),
                                        IconAndTextWidget(icon: Icons.location_on, 
                                                          text: "1.7km", 
                                                          iconColor: AppColors.mainColor),
                                        IconAndTextWidget(icon: Icons.access_time_rounded, 
                                                          text: "32min", 
                                                          iconColor: AppColors.iconColor2)
                                      ],
                                    )
                                ],
                              )
                            )
                          ),
                        )
                      ],)
                  )
              );
            }
          ) : Container(
                margin: EdgeInsets.only(top:Dimensions.screenHeight/3.5),
                child: CircularProgressIndicator(
                  color: AppColors.mainColor,
                  strokeWidth: Dimensions.height10/3,
                )
          );
        }),
      ],
    
    );
  }
  Widget _buildPageItem(int position, ProductModel popularProduct){

    Matrix4 matrix = Matrix4.identity(); //it returns 3 coord (x,y,z)
    //we're gonna scale up/down our y axis
    if(position==_currPageValue.floor()){ //current page
        var currScale = 1-(_currPageValue-position)*(1-_scaleFactor);
        var currTrans = _height*(1-currScale)/2;
        matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);

    }else if(position==_currPageValue.floor()+1){ //upcoming page 
        var currScale=_scaleFactor+(_currPageValue-position+1)*(1-_scaleFactor);
        var currTrans = _height*(1-currScale)/2; //(220*(1-0.8)/2) = 22 
        matrix = Matrix4.diagonal3Values(1, currScale, 1);
        matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);

    }else if(position==_currPageValue.floor()-1){
        var currScale = 1-(_currPageValue-position)*(1-_scaleFactor);
        var currTrans = _height*(1-currScale)/2; //(220*(1-0.8)/2) = 22 
        matrix = Matrix4.diagonal3Values(1, currScale, 1);
        matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    }else{
        var currScale = 0.8;
        var currTrans = _height*(1-currScale)/2; //(220*(1-0.8)/2) = 22 
        matrix = Matrix4.diagonal3Values(1, currScale, 1);
        matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    }

    return Transform(
      transform: matrix, 
      child: GestureDetector(
              onTap:(){
                //in flutter, to move between pages, we can just call Get.to

                Get.toNamed(RouteHelper.getPopularFood(position, "home"));
              },
              child: Stack(
                children:[
                  Container(
                      height:Dimensions.pageViewContainer, 
                      //even though we specified the height, it's not taking effect and the child container is taking up all the space of the parent container
                      //to deal with this problem, we can solve this by wrapping this container with a Stack widget
                      margin: EdgeInsets.only(left:Dimensions.width10, right:Dimensions.width10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radius30),
                        color: position.isEven? const Color(0xFF69c5df) : const Color(0xFF9294cc),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              "${AppConstants.BASE_URL}${AppConstants.UPLOAD_URL}${popularProduct.img!}", headers: AppConstants.HEADERS
                            )
                          )
                      ),
                    ),
                  //we can wrap these widgets inside align widgets to tell each child where to stay (e.g. second container to come down)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child:  Container(
                              height:Dimensions.pageViewTextContainer, 
                              //even though we specified the height, it's not taking effect and the child container is taking up all the space of the parent container
                              //to deal with this problem, we can solve this by wrapping this container with a Stack widget
                              margin: EdgeInsets.only(left:Dimensions.width30, right:Dimensions.width30, bottom:Dimensions.height30),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radius20),
                                color: Colors.white, 
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0xFFe8e8e8),
                                    blurRadius: 3.0, 
                                    offset: Offset(0,5)
                                  ),
                                  BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(-5,0)
                                  ),
                                  BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(5,0)
                                  )
                                ]
                              ),
                              child: Container( // we can use padding with containers
                                padding: EdgeInsets.only(top:Dimensions.height15, left:Dimensions.width15, right:Dimensions.width15),
                                child: FoodColumnDetail(text: popularProduct.name!)
                              )
                            ),
                  ),
                ],
              )
            )
      );
  }
}
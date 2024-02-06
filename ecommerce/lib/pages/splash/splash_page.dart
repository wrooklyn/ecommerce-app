import 'dart:async';
import 'package:ecommerce/controllers/popular_product_controller.dart';
import 'package:ecommerce/controllers/recommended_product_controller.dart';
import 'package:ecommerce/routes/route_helper.dart';
import 'package:ecommerce/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{
  late Animation<double> animation;
  late AnimationController controller;

  Future<void> _loadResource() async {
    await Get.find<PopularProductController>().getPopularProductList();
    await Get.find<RecommendedProductController>().getRecommendedProductList();
  }
  @override
  void initState(){
    super.initState();
    _loadResource();
    controller = AnimationController(vsync:this, duration:const Duration(seconds:2))..forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    Timer(
      const Duration(seconds:3),
      ()=>Get.offNamed(RouteHelper.getHomePage())
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: animation,
            child: Center(child: Image.asset("assets/image/logo part 1.png", width: Dimensions.height25*10))

          ),
          ScaleTransition(
            scale: animation,
            child: Center(child: Image.asset("assets/image/logo part 2.png", width: Dimensions.height25*10))
          )
        ],
      )
    );
  }
}
import 'package:ecommerce/utils/dimensions.dart';
import 'package:ecommerce/widgets/app_icon.dart';
import 'package:ecommerce/widgets/big_text.dart';
import 'package:flutter/material.dart';

class ProfileDetail extends StatelessWidget {
  AppIcon appIcon; 
  BigText bigText; 
  ProfileDetail({super.key, required this.appIcon, required this.bigText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.only(
        left: Dimensions.width30, 
        top: Dimensions.height15,
        bottom: Dimensions.height15
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          appIcon, 
          SizedBox(width: Dimensions.width20),
          bigText,
        ]
      )
    );
  }
}
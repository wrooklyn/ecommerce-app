import 'package:ecommerce/utils/colors.dart';
import 'package:ecommerce/utils/dimensions.dart';
import 'package:ecommerce/widgets/app_icon.dart';
import 'package:ecommerce/widgets/big_text.dart';
import 'package:ecommerce/widgets/bold_title.dart';
import 'package:ecommerce/widgets/profile_detail.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: BoldTitle(text: "Profile", size: Dimensions.font20, color: Colors.white)
      ),
      body: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(top: Dimensions.height30),
        child: Column(
          children: [
            AppIcon(icon: Icons.person, 
                    iconSize: Dimensions.iconSize24*3,
                    size: Dimensions.iconSize24*5,
                    iconColor: Colors.white,
                    backgroundColor: AppColors.mainColor,
            ),
            SizedBox(height: Dimensions.height20),
            //name
            ProfileDetail(
              appIcon: AppIcon(icon: Icons.person_outline_rounded, 
                    iconSize: Dimensions.iconSize24*1.5,
                    size: Dimensions.iconSize24*1.5,
                    backgroundColor: Colors.transparent,
                    iconColor: AppColors.darkBlue,
              ),
              bigText: BigText(text: "Brooklyn Wright"),
            ),
            Divider(indent: Dimensions.width20*1.2,endIndent: Dimensions.width20*1.2, color: Colors.grey.withOpacity(0.25)),
            //phone
            ProfileDetail(
              appIcon: AppIcon(icon: Icons.phone_iphone_outlined, 
                    iconSize: Dimensions.iconSize24*1.5,
                    size: Dimensions.iconSize24*1.5,
                    backgroundColor: Colors.transparent,
                    iconColor: AppColors.darkBlue,
              ),
              bigText: BigText(text: "+39 3339588765"),
            ),
            Divider(indent: Dimensions.width20*1.2,endIndent: Dimensions.width20*1.2, color: Colors.grey.withOpacity(0.25)),
            //email
            ProfileDetail(
              appIcon: AppIcon(icon: Icons.email_outlined, 
                    iconSize: Dimensions.iconSize24*1.5,
                    size: Dimensions.iconSize24*1.5,
                    backgroundColor: Colors.transparent,
                    iconColor: AppColors.darkBlue,
              ),
              bigText: BigText(text: "brooklynwright@gmail.com"),
            ),
            Divider(indent: Dimensions.width20*1.2,endIndent: Dimensions.width20*1.2, color: Colors.grey.withOpacity(0.25)),
            //address
            ProfileDetail(
              appIcon: AppIcon(icon: Icons.location_on_outlined, 
                    iconSize: Dimensions.iconSize24*1.5,
                    size: Dimensions.iconSize24*1.5,
                    backgroundColor: Colors.transparent,
                    iconColor: AppColors.darkBlue,
              ),
              bigText: BigText(text: "Via Pesaro 34, Torino"),
            ),
            Divider(indent: Dimensions.width20*1.2,endIndent: Dimensions.width20*1.2, color: Colors.grey.withOpacity(0.25)),
            //messages
            ProfileDetail(
              appIcon: AppIcon(icon: Icons.message_outlined, 
                    iconSize: Dimensions.iconSize24*1.5,
                    size: Dimensions.iconSize24*1.5,
                    backgroundColor: Colors.transparent,
                    iconColor: AppColors.darkBlue,
              ),
              bigText: BigText(text: "No messages"),
            ),
          ]
      )
      )
    );
  }
}
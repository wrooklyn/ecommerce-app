import 'package:ecommerce/utils/colors.dart';
import 'package:ecommerce/utils/dimensions.dart';
import 'package:ecommerce/widgets/big_text.dart';
import 'package:ecommerce/widgets/icon_and_text.dart';
import 'package:ecommerce/widgets/small_text.dart';
import 'package:flutter/material.dart';

class FoodColumnDetail extends StatelessWidget {
  final String text; 
  const FoodColumnDetail({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              BigText(text: text, size:Dimensions.font20),
              SizedBox(height: Dimensions.height10),
              Row(
                children: [
                  Wrap( // we can use this widget to draw the same thing multiple times 
                    children: List.generate(5, (index) => Icon(Icons.star, color: AppColors.mainColor, size: Dimensions.iconSize16))
                  ),
                  const SizedBox(width:10),
                  SmallText(text: "4.5"),
                  const SizedBox(width:10),
                  SmallText(text:"1287"),
                  const SizedBox(width:10),
                  SmallText(text:"Comments"),
                  ],
                ),
                SizedBox(height:Dimensions.height20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconAndTextWidget(icon: Icons.circle_sharp, 
                                      text: "Normal", 
                                      iconColor: AppColors.iconColor1,
                                      size: Dimensions.iconSize24,
                                      ),
                    IconAndTextWidget(icon: Icons.location_on, 
                                      text: "1.7km", 
                                      iconColor: AppColors.mainColor,
                                      size: Dimensions.iconSize24,
                                      ),
                    IconAndTextWidget(icon: Icons.access_time_rounded, 
                                      text: "32min", 
                                      iconColor: AppColors.iconColor2,
                                      size: Dimensions.iconSize24,
                                      )
                  ],
                )
            ],);
  }
}
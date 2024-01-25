import 'package:ecommerce/utils/colors.dart';
import 'package:ecommerce/widgets/big_text.dart';
import 'package:flutter/material.dart';

class MainFoodPage extends StatefulWidget {
  const MainFoodPage({Key? key}): super(key:key) ;

  @override
  State<MainFoodPage> createState() => _MainFoodPageState();
}

class _MainFoodPageState extends State<MainFoodPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children:[
          Container(
            //add scrolling parameter

            child: Container(
              //adding margin 
              margin: const EdgeInsets.only(top:45, bottom:15),
              padding: const EdgeInsets.only(left:20, right:20),
              child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      //column's default property is to be at the top
                      children: [
                        BigText(text:"Country", color: AppColors.mainColor),
                        BigText(text:"City")
                      ],),
                    Center(
                      child: Container(
                          //row's default property is to put its children vertically centered
                          //the container is using row's default property
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: AppColors.mainColor,
                          ),
                          child: const Icon(Icons.search, color: Colors.white), 
                        ),
                    )
                ],
              )
            ),
          )
        ]
      )
    );
  }
}
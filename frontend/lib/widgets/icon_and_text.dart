

import 'package:ecommerce/utils/dimensions.dart';
import 'package:flutter/cupertino.dart';

import 'small_text.dart';

class IconAndTextWidget extends StatelessWidget {
  final IconData icon; 
  final String text;
  final Color iconColor; 
  final double size; 
  const IconAndTextWidget({super.key, required this.icon, required this.text, required this.iconColor, this.size=0});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children:[
        Icon(icon, color: iconColor, size: size==0? Dimensions.iconSize16 : size),
        const SizedBox(width:5),
        Container(
          margin: const EdgeInsets.only(top:3),
          child:SmallText(text: text),
        )
      ]
    );
  }
}
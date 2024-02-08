import 'package:ecommerce/utils/dimensions.dart';
import 'package:flutter/cupertino.dart';

class BigText extends StatelessWidget {
  final String text; 
  Color? color; //this means we'll pass a color variable to this widget
  double size; 
  TextOverflow overFlow; 

  //constructor 
  BigText({
    Key? key, 
    required this.text,
    //to set default colors, you need to declare it as follows, 
    //and cannot use the static final variable in Colors class. 
    this.color=const Color(0xFF332d2b), 
    this.size=0,
    this.overFlow=TextOverflow.ellipsis //(three dots if overflow by default)
    }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text, 
      maxLines: 1,
      overflow: overFlow,
      style: TextStyle(
          color: color, 
          fontWeight: FontWeight.w400, 
          fontFamily: 'Roboto',
          fontSize: size==0? Dimensions.font20:size, 
      ),
          
    );
  }
}
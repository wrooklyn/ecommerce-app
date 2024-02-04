import 'package:ecommerce/utils/dimensions.dart';
import 'package:flutter/cupertino.dart';

class SmallText extends StatelessWidget {
  final String text; 
  Color? color; //this means we'll pass a color variable to this widget
  double size; 
  double height;
  TextOverflow overFlow; 
  int maxLines;

  //constructor 
  SmallText({
    Key? key, 
    required this.text,
    //to set default colors, you need to declare it as follows, 
    //and cannot use the static final variable in Colors class. 
    this.color=const Color(0xFFccc7c5), 
    this.size=0,
    this.height=1.2,
    this.overFlow=TextOverflow.ellipsis,
    this.maxLines=0,
    }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text, 
      maxLines: maxLines==0?null:1,
      overflow: maxLines==0?null:overFlow,
      style: TextStyle(
          color: color, 
          fontFamily: 'Roboto',
          fontSize: size==0? Dimensions.font14:size, 
          height:height
      ),
          
    );
  }
}
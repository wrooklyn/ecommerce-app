import 'package:ecommerce/utils/colors.dart';
import 'package:ecommerce/utils/dimensions.dart';
import 'package:ecommerce/widgets/small_text.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final double height; 
  const ExpandableText({Key? key, required this.text, this.height=1.5}): super(key:key);

  @override
  // ignore: library_private_types_in_public_api
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  late String firstHalf; //we call them late because we'll initialize them later 
  late String secondHalf; //if we do not initialize it, it will give error at run time
  bool hiddenText=true;
  double textHeight = Dimensions.screenHeight/3;

  @override 
  void initState(){
    super.initState();
    if(widget.text.length>textHeight){
      firstHalf = widget.text.substring(0, textHeight.toInt());
      secondHalf = widget.text.substring(textHeight.toInt()+1, widget.text.length);
    }else{
      firstHalf=widget.text;
      secondHalf="";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty? SmallText(height: widget.height, color: AppColors.paraColor, text: firstHalf) : Column(
        children: [
          SmallText(height: widget.height, color: AppColors.paraColor, size: Dimensions.font16, text: hiddenText? ("$firstHalf ...") : firstHalf+secondHalf),
          const SizedBox(height: 3),
          InkWell(
            onTap:(){
              setState(() {
                hiddenText=!hiddenText;
              });
            },
            child: Row(
              children: [
                SmallText(size:Dimensions.font16, text: hiddenText? "Show More": "Show Less", color: AppColors.mainColor),
                Icon(hiddenText? Icons.arrow_drop_down: Icons.arrow_drop_up, color: AppColors.mainColor)
              ],
            )
          )
        ],
      ),
    );
  }
}
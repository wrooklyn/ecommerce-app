import 'package:ecommerce/utils/dimensions.dart';
import 'package:ecommerce/widgets/bold_title.dart';
import 'package:ecommerce/widgets/small_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackBar(String message, {bool isError=true, String title="Error"}){
  Get.snackbar(
    title,
    message,
    titleText: BoldTitle(text: title, color: Colors.white,),
    messageText: Text(message, style: TextStyle(color: Colors.white, fontSize: Dimensions.font16)),
    snackPosition: SnackPosition.TOP,
    backgroundColor: isError? Color.fromARGB(255, 238, 97, 97) : Color.fromARGB(255, 119, 195, 142)
  );
}

//curly braces for optional fields
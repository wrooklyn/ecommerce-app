import 'package:ecommerce/controllers/auth_controller.dart';
import 'package:ecommerce/models/signup_model.dart';
import 'package:ecommerce/routes/route_helper.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:ecommerce/utils/dimensions.dart';
import 'package:ecommerce/widgets/bold_title.dart';
import 'package:ecommerce/widgets/custom_snackbar.dart';
import 'package:ecommerce/widgets/text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
  
    Future<void> registration(AuthController authController) async {
      String name = nameController.text.trim();
      String phone = phoneController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text;

      if(name.isEmpty){
        showCustomSnackBar("Name field is empty!", title: "Missing Field");
      }else if(email.isEmpty){
        showCustomSnackBar("Email field is empty!", title: "Missing Field");
      }else if(!GetUtils.isEmail(email)){
        showCustomSnackBar("Email format incorrect! (e.g. example@email.com)", title: "Invalid Field");
      }else if(password.isEmpty){
        showCustomSnackBar("Password field is empty!", title: "Missing Field");
      }else if(password.length<6){
        showCustomSnackBar("Password must be at least 7 characters long!", title: "Invalid Field");
      }else{
        SignUpBody signUpBody= SignUpBody(
                                  email: email, 
                                  name: name, 
                                  password: password, 
                                  phone: phone);
        await authController.registration(signUpBody).then((status){
          if(status.isSuccess){
            emailController.clear();
            nameController.clear();
            passwordController.clear();
            phoneController.clear();
            Get.toNamed(RouteHelper.getSignIn());
            showCustomSnackBar(status.message, isError: false, title: "Success");
          }else{
            showCustomSnackBar(status.message);
          }
        });

      }

    }
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AuthController>(builder:(authController){
        return !authController.isLoading? SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // ignore: avoid_unnecessary_containers
              Container(
                margin: EdgeInsets.only(top: Dimensions.height45*1.8),
                child: Center(
                  child:CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: Dimensions.height30*2,
                    backgroundImage: const AssetImage("assets/image/logo part 1.png"),
                  )
                )
              ),
              SizedBox(height: Dimensions.height20),
              AppTextField(textController: emailController, hintText: "Email", icon: Icons.email_rounded, backgroundColor: Colors.white, iconColor: AppColors.darkBlue),
              SizedBox(height:Dimensions.height20),
              AppTextField(textController: passwordController, hintText: "Password", icon: Icons.password_rounded, backgroundColor: Colors.white, iconColor: AppColors.darkBlue),
              SizedBox(height:Dimensions.height20),
              AppTextField(textController: nameController, hintText: "Name", icon: Icons.person_rounded, backgroundColor: Colors.white, iconColor: AppColors.darkBlue),
              SizedBox(height:Dimensions.height20),
              AppTextField(textController: phoneController, hintText: "Phone", icon: Icons.phone_rounded, backgroundColor: Colors.white, iconColor: AppColors.darkBlue),
              SizedBox(height:Dimensions.height25*1.5),
              GestureDetector(
                onTap: (){
                  registration(authController);
                },
                child:Container(
                  width: Dimensions.screenWidth/1.5,
                  height: Dimensions.screenHeight/15, 
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    color: AppColors.mainColor
                  ),
                  child: Center(child:BoldTitle(
                    text: "Sign Up",
                    size: Dimensions.font16*1.2,
                    color: Colors.white
                  ))
                )
              ),
              
              SizedBox(height: Dimensions.height25),
            
              RichText(
                text: TextSpan(
                text: "Have an account already?",
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: Dimensions.font16
                  ),
                  children: [
                    TextSpan(
                      text: " Sign In",
                      recognizer: TapGestureRecognizer()..onTap=(){Get.back();},
                      style: TextStyle(
                        color: AppColors.mainColor,
                        fontSize: Dimensions.font16,
                        fontWeight: FontWeight.bold
                        )
                    )
                  ]
                )
              ),
              SizedBox(height: Dimensions.height25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Expanded(child:Divider(indent: Dimensions.width20*3,endIndent: Dimensions.width20*1.2, color: Colors.grey.withOpacity(0.5))),
                    RichText(
                    text: TextSpan(
                    recognizer: TapGestureRecognizer()..onTap=()=>Get.back(),
                    text: "or",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: Dimensions.font16
                      )
                    )
                  ),
                  Expanded(child:Divider(indent: Dimensions.width20*1.2,endIndent: Dimensions.width20*3, color: Colors.grey.withOpacity(0.5))),
                ],
              ),
              SizedBox(height: Dimensions.height25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  CircleAvatar(
                    radius: Dimensions.radius20*0.93,
                    backgroundImage: const AssetImage("assets/image/a.jpeg"),
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(width: Dimensions.width15),
                  CircleAvatar(
                    radius: Dimensions.radius20,
                    backgroundImage: const AssetImage("assets/image/g.png"),
                    backgroundColor: Colors.transparent,
                  )
                ]
              )
              // Wrap(
              //   children: List.generate(2, (index)=> CircleAvatar(
              //     radius: Dimensions.radius20, 
              //     backgroundImage: AssetImage("assets/image/${signupImages[index]}"),
              //     backgroundColor: Colors.transparent,
              //   ))
              // )
            ],
          )
        ): Center(child:CircularProgressIndicator(
            color: AppColors.mainColor,
            strokeWidth: Dimensions.height10/3,
        ));
      })
    );
  }
}
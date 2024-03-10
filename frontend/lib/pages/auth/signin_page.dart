import 'package:ecommerce/controllers/auth_controller.dart';
import 'package:ecommerce/models/signin_model.dart';
import 'package:ecommerce/routes/route_helper.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:ecommerce/utils/dimensions.dart';
import 'package:ecommerce/widgets/bold_title.dart';
import 'package:ecommerce/widgets/custom_snackbar.dart';
import 'package:ecommerce/widgets/small_text.dart';
import 'package:ecommerce/widgets/text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
  
    Future<void> login(AuthController authController) async {
      String email = emailController.text.trim();
      String password = passwordController.text;

      if(email.isEmpty){
        showCustomSnackBar("Email field is empty!", title: "Missing Field");
      }else if(!GetUtils.isEmail(email)){
        showCustomSnackBar("Email format incorrect! (e.g. example@email.com)", title: "Invalid Field");
      }else if(password.isEmpty){
        showCustomSnackBar("Password field is empty!", title: "Missing Field");
      }else{
        SignInBody signInBody= SignInBody(
                                  email: email, 
                                  password: password, 
                                  );
        await authController.login(signInBody).then((status){
          if(status.isSuccess){
            emailController.clear();
            passwordController.clear();
            Get.toNamed(RouteHelper.getHomePage());
            showCustomSnackBar(status.message, isError: false, title: "Success");
          }else{
            showCustomSnackBar(status.message);
          }
        });

      }

    }

    Future<void> loginWithGoogle(AuthController authController) async {
        await authController.loginWithGoogle().then((status){
          if(status!=null && status.isSuccess){
            Get.toNamed(RouteHelper.getHomePage());
            showCustomSnackBar(status.message, isError: false, title: "Success");
          }else if(status!=null){
            showCustomSnackBar(status.message);
          }
        });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AuthController>(builder: (authController){
        return !authController.isLoginLoading? SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // ignore: avoid_unnecessary_containers
              Container(
                margin: EdgeInsets.only(left: Dimensions.width30, top: Dimensions.height45*3),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    BoldTitle(text: "Welcome Back", size: Dimensions.font15*2, color: AppColors.darkBlue),
                    SizedBox(height: Dimensions.height10),
                    SmallText(text: "Log into your account", size: Dimensions.font15)
                  ]
                )
              ),
              SizedBox(height:Dimensions.height35),
              AppTextField(textController: emailController, hintText: "Email", icon: Icons.email_rounded, backgroundColor: Colors.white, iconColor: AppColors.darkBlue),
              SizedBox(height:Dimensions.height20),
              AppTextField(textController: passwordController, hintText: "Password", icon: Icons.password_rounded, backgroundColor: Colors.white, iconColor: AppColors.darkBlue),
              SizedBox(height:Dimensions.height20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                    recognizer: TapGestureRecognizer()..onTap=()=>Get.back(),
                    text: "Forgot Password?",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: Dimensions.font16,
                      )
                    )
                  ),
                  SizedBox(width: Dimensions.width30)
                ],
              ),
              SizedBox(height:Dimensions.height25*1.5),
              GestureDetector(
                  onTap: (){
                    login(authController);
                  },
                  child: Container(
                    width: Dimensions.screenWidth/1.5,
                    height: Dimensions.screenHeight/15, 
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius15),
                      color: AppColors.mainColor
                    ),
                    child: Center(child:BoldTitle(
                      text: "Sign In",
                      size: Dimensions.font16*1.2,
                      color: Colors.white
                    ))
                  ),
              ),
              SizedBox(height: Dimensions.height30),
              RichText(
                text: TextSpan(
                  text: "Don't have an account?",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: Dimensions.font16
                    ),
                  children:[
                    TextSpan(
                      recognizer: TapGestureRecognizer()..onTap=(){Get.toNamed(RouteHelper.getSignUp());},
                      text: " Sign Up",
                      style: TextStyle(
                        color: AppColors.mainColor,
                        fontSize: Dimensions.font16,
                        fontWeight: FontWeight.bold
                        )
                    )
                  ]
                )
              ), 
              SizedBox(height: Dimensions.height30),
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
                  GestureDetector(
                    onTap: (){
                      loginWithGoogle(authController);
                    },
                    child: CircleAvatar(
                      radius: Dimensions.radius20,
                      backgroundImage: const AssetImage("assets/image/g.png"),
                      backgroundColor: Colors.transparent,
                    )
                  )
                ]
              )
            ],
          )
        ):Center(child:CircularProgressIndicator(
            color: AppColors.mainColor,
            strokeWidth: Dimensions.height10/3,
          ));
        },
      )
    );
  }
}
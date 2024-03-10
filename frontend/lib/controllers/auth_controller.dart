import 'package:ecommerce/data/repository/auth_repo.dart';
import 'package:ecommerce/models/response_model.dart';
import 'package:ecommerce/models/signin_model.dart';
import 'package:ecommerce/models/signup_model.dart';
import 'package:ecommerce/models/thirdPartyAuth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController implements GetxService{
    final AuthRepo authRepo; 
    AuthController({required this.authRepo});

    bool _isLoading=false; 
    bool get isLoading => _isLoading;
    bool _isLoginLoading=false;
    bool get isLoginLoading=>_isLoginLoading;
    bool _isLogged = false; 
    bool get isLogged=>_isLogged;

    Future<void> init() async {
      _isLogged = await userLoggedIn(); 
      update();
    }

    Future<ResponseModel> registration(SignUpBody signUpBody) async {
      _isLoading=true; 
      update();
      Response res = await authRepo.registration(signUpBody);
      late ResponseModel responseModel; 

      if(res.statusCode==200){
        responseModel=ResponseModel(true, res.body);
      }else{
        responseModel=ResponseModel(false, res.body!);
      }
      _isLoading=false; 
      update();
      return responseModel;
    }

    Future<ResponseModel> login(SignInBody signInBody) async {
      _isLoginLoading=true; 
      update();
      Response res = await authRepo.login(signInBody);
      late ResponseModel responseModel; 

      if(res.statusCode==200){
        responseModel=ResponseModel(true, "Welcome back!");
        authRepo.saveUserToken(res.body["token"]);
        _isLogged=true;
      }else{
        responseModel=ResponseModel(false, res.body['message']!);
      }
      _isLoginLoading=false; 
      update();
      return responseModel;
    }

    Future<ResponseModel?> loginWithGoogle() async{

      late ResponseModel responseModel; 
      try{
        final GoogleSignInAccount? googleUser = await GoogleSignIn(
          scopes: ['email', 'profile', 'https://www.googleapis.com/auth/user.phonenumbers.read']
        ).signIn();

        final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

        if(googleAuth==null){
          return null; 
        }
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        if(credential.accessToken != null && credential.idToken!=null && googleUser!=null){
          //also sign in to firebase auth
          await FirebaseAuth.instance.signInWithCredential(credential);
          ThirdPartyAuthBody signInData = ThirdPartyAuthBody(email: googleUser.email, name: googleUser.displayName!, accessToken: credential.accessToken!, idToken: credential.idToken!);
          Response res =await authRepo.loginWithGoogle(signInData);
          if(res.statusCode==200){
            responseModel=ResponseModel(true, "Welcome back!");
            authRepo.saveUserToken(res.body["token"]);
          }else{
            responseModel=ResponseModel(false, res.body['message']!);
          }
          _isLoginLoading=false; 
          _isLogged=true;
          update();
          return responseModel;
        }else{
          responseModel=ResponseModel(false, "Something went wrong.");
        }
        return responseModel;
      }catch (e) {
        return responseModel=ResponseModel(false, "Something went wrong.");
      }
    }

    Future<void> saveUserEmailAndPassword(String email, String password) async {
       await authRepo.saveUserEmailAndPassword(email, password);
    }

    Future<bool> userLoggedIn() async {
      return await authRepo.userLoggedIn();
    }

    Future<void> logout() async {
      try{
        await FirebaseAuth.instance.signOut();
        authRepo.clearSharedData();
        _isLogged=false;
        update();
      }catch(e){
        authRepo.clearSharedData();
        _isLogged=false;
        update();
      }

    }
}
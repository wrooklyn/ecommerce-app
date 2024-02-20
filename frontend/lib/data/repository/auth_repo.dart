import 'dart:async';
import 'dart:io';

import 'package:ecommerce/data/api/api.dart';
import 'package:ecommerce/models/signin_model.dart';
import 'package:ecommerce/models/signup_model.dart';
import 'package:ecommerce/models/thirdPartyAuth.dart';
import 'package:ecommerce/utils/app_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import '../../helper/auth_constants.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo{
  final ApiClient apiClient; 
  final FlutterSecureStorage secureStorage;
 
  AuthRepo({required this.apiClient, required this.secureStorage});
  
  Future<Response> registration(SignUpBody signUpBody) async {
    return await apiClient.postData(AppConstants.REGISTRATION_URI, signUpBody.toJson());
  }

  Future<String> getUserToken() async{
    return await secureStorage.read(key:AppConstants.TOKEN)??"None";
  }

  Future<bool> userLoggedIn() async {
       return await secureStorage.containsKey(key:AppConstants.TOKEN);
  }

  Future<Response> login(SignInBody signInBody) async {
    return await apiClient.postData(AppConstants.LOGIN_URI, signInBody.toJson());
  }

  Future<Response> loginWithGoogle(ThirdPartyAuthBody thirdPartyAuthBody) async {
    return await apiClient.postData(AppConstants.GOOGLE_LOGIN_URI, thirdPartyAuthBody.toJson());
  }

  // Future<Response> loginWithGoogle() async {
  //   return await apiClient.postData(AppConstants.LOGIN_URI, signInBody.toJson());
  // }

  Future<bool> saveUserToken(String token) async {
    apiClient.token=token;
    apiClient.updateHeader(token);
    await secureStorage.write(key:AppConstants.TOKEN, value:token);
    return true;
  }

  Future<void> saveUserEmailAndPassword(String email, String password) async {
    try{
      if(Platform.isAndroid){
        AndroidOptions secureOption()=>const AndroidOptions(
          encryptedSharedPreferences: true
        );
        await secureStorage.write(key:AppConstants.USER_EMAIL, value:email, aOptions: secureOption());
        await secureStorage.write(key:AppConstants.USER_PASS, value:password, aOptions: secureOption());
      }else{
        await secureStorage.write(key:AppConstants.USER_EMAIL, value:email);
        await secureStorage.write(key:AppConstants.USER_PASS, value:password);
      }
    }catch(e){
      rethrow; 
    }
  }

  void clearSharedData()async{
    await apiClient.getData(AppConstants.LOGOUT_URI);
    await secureStorage.delete(key:AppConstants.TOKEN);
    await secureStorage.delete(key:AppConstants.USER_PASS);
    await secureStorage.delete(key:AppConstants.USER_EMAIL);
    await secureStorage.delete(key:AppConstants.REFRESH_TOKEN_KEY);
    apiClient.token='';
    apiClient.updateHeader('');
    apiClient.updateHeader('');
  }

}
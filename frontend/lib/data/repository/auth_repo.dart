import 'dart:async';

import 'package:ecommerce/data/api/api.dart';
import 'package:ecommerce/models/signin_model.dart';
import 'package:ecommerce/models/signup_model.dart';
import 'package:ecommerce/utils/app_constants.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo{
  final ApiClient apiClient; 
  final SharedPreferences sharedPreferences;
 
  AuthRepo({required this.apiClient, required this.sharedPreferences});
  
  Future<Response> registration(SignUpBody signUpBody) async {
    return await apiClient.postData(AppConstants.REGISTRATION_URI, signUpBody.toJson());
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.TOKEN)??"None";
  }

  Future<bool> userLoggedIn() async {
    Response<dynamic> res = await apiClient.getData(AppConstants.LOGGED_IN_URI);
    if(res.body['message']=="Authorized"){
       return sharedPreferences.containsKey(AppConstants.TOKEN);
    }else{
      return false;
    }
  }

  Future<Response> login(SignInBody signInBody) async {
    return await apiClient.postData(AppConstants.LOGIN_URI, signInBody.toJson());
  }

  Future<bool> saveUserToken(String token) async {
    apiClient.token=token;
    apiClient.updateHeader(token);
    return sharedPreferences.setString(AppConstants.TOKEN, token);
  }

  Future<void> saveUserEmailAndPassword(String email, String password) async {
    try{
      await sharedPreferences.setString(AppConstants.USER_EMAIL, email);
      await sharedPreferences.setString(AppConstants.USER_PASS, password);
    }catch(e){
      rethrow; 
    }
  }

  void clearSharedData(){
    sharedPreferences.remove(AppConstants.TOKEN);
    sharedPreferences.remove(AppConstants.USER_PASS);
    sharedPreferences.remove(AppConstants.USER_EMAIL);
    apiClient.token='';
    apiClient.updateHeader('');
    apiClient.updateHeader('');
  }

}
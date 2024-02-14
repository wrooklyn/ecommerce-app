import 'package:ecommerce/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient extends GetConnect implements GetxService{
  late String token; //when we talk to a server, we should have a token
  final String appBaseUrl; //server url
  late Map<String, String> _mainHeaders; //storing data locally
  Map<String, String> get mainHeaders => _mainHeaders; 
  final SharedPreferences sharedPreferences;

  //constructor
  ApiClient({required this.sharedPreferences, required this.appBaseUrl}){
    baseUrl=appBaseUrl; //these variables come from Getx package management system
    timeout = const Duration(seconds:30);
    token=sharedPreferences.getString(AppConstants.TOKEN)??"None";
    _mainHeaders={
      'Content-type':'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  updateHeader(String token){
    _mainHeaders={
      'Content-type':'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }
  //the response will be from the Getx package, instead of an http client, we'll have a Getx client
  Future<Response> getData(String uri,) async { //specify the endpoint - uri
    try{
      Response res = await get(uri, headers: _mainHeaders);
      return res; 
    }catch(e){
      return Response(statusCode:1, statusText: e.toString());
    }
  }

  Future<Response> postData(String uri, dynamic body) async {
    try{
      Response res = await post(uri, body, headers: _mainHeaders);
      return res; 
    }catch(e){
      return Response(statusCode: 1, statusText: e.toString());
    }
  }


}
import 'package:ecommerce/utils/app_constants.dart';
import 'package:get/get.dart';

class ApiClient extends GetConnect implements GetxService{
  late String token; //when we talk to a server, we should have a token
  final String appBaseUrl; //server url
  late Map<String, String> _mainHeaders; //storing data locally

  //constructor
  ApiClient({required this.appBaseUrl}){
    baseUrl=appBaseUrl; //these variables come from Getx package management system
    timeout = const Duration(seconds:30);
    token=AppConstants.TOKEN;
    _mainHeaders={
      'Content-type':'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  //the response will be from the Getx package, instead of an http client, we'll have a Getx client
  Future<Response> getData(String uri,) async { //specify the endpoint - uri
    try{
      Response res = await get(uri);
      return res; 
    }catch(e){
      return Response(statusCode:1, statusText: e.toString());
    }
  }
}
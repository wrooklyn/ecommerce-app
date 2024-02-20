import 'dart:convert';

import 'package:ecommerce/models/cart_model.dart';
import 'package:ecommerce/utils/app_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CartRepo{
  final FlutterSecureStorage secureStorage;
  CartRepo({required this.secureStorage});

  List<String> _cart = [];
  List<String> _cartHistory=[];

  Future<void> addToCartList(List<CartModel> cartList) async {
    //sharedPreferences.remove(AppConstants.CART_LIST);
    //sharedPreferences.remove(AppConstants.CART_HISTORY_LIST);
    var time = DateTime.now().toString();
    _cart.clear();
    for (var element in cartList) {
      element.time=time;
      _cart.add(jsonEncode(element));
    }
    await secureStorage.write(key:AppConstants.CART_LIST,value: jsonEncode(_cart));
  }

  Future<List<CartModel>> getCartList() async {
    List<CartModel> cartList=[];
    List<String> stringList=[];

    if(await secureStorage.containsKey(key:AppConstants.CART_LIST)){
      String? stringOfItems= await secureStorage.read(key:AppConstants.CART_LIST);
      stringList=jsonDecode(stringOfItems!);
    }

    for(var element in stringList){
      cartList.add(
        CartModel.fromJson(jsonDecode(element))
      );
    }
    return cartList;
  }

  void addToCartHistory()async{
    if(await secureStorage.containsKey(key: AppConstants.CART_HISTORY_LIST)){
      String? listOfItems=await secureStorage.read(key:AppConstants.CART_HISTORY_LIST);
      _cartHistory=jsonDecode(listOfItems!);
    }
    for(int i=0; i<_cart.length; i++){
      _cartHistory.add(_cart[i]);
    }
    //removeCart();
    await secureStorage.write(key:AppConstants.CART_HISTORY_LIST, value:jsonEncode(_cartHistory));
  }
  
  Future<List<CartModel>> getCartHistoryList()async{
    if(await secureStorage.containsKey(key:AppConstants.CART_HISTORY_LIST)){
      _cartHistory=[];
      String? listOfItems=await secureStorage.read(key:AppConstants.CART_HISTORY_LIST);
      _cartHistory=jsonDecode(listOfItems!);
    }
  
    List<CartModel> cartListhistory=[];
    for (var element in _cartHistory) {
      cartListhistory.add(CartModel.fromJson(jsonDecode(element)));
    }
    return cartListhistory;
  }

  void removeCart() async{
    _cart.clear();
    await secureStorage.delete(key: AppConstants.CART_LIST);
  }

  void clearCartHistory()async{
    removeCart();
    _cartHistory=[];
    await secureStorage.delete(key:AppConstants.CART_HISTORY_LIST);
  }
}
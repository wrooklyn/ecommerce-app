import 'dart:convert';

import 'package:ecommerce/models/cart_model.dart';
import 'package:ecommerce/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepo{
  final SharedPreferences sharedPreferences;
  CartRepo({required this.sharedPreferences});

  List<String> _cart = [];
  List<String> _cartHistory=[];

  void addToCartList(List<CartModel> cartList){
    //sharedPreferences.remove(AppConstants.CART_LIST);
    //sharedPreferences.remove(AppConstants.CART_HISTORY_LIST);
    var time = DateTime.now().toString();
    _cart.clear();
    for (var element in cartList) {
      element.time=time;
      _cart.add(jsonEncode(element));
    }
    sharedPreferences.setStringList(AppConstants.CART_LIST, _cart);
  }

  List<CartModel> getCartList(){
    List<CartModel> cartList=[];
    List<String> stringList=[];

    if(sharedPreferences.containsKey(AppConstants.CART_LIST)){
      stringList= sharedPreferences.getStringList(AppConstants.CART_LIST)!;
    }

    for(var element in stringList){
      cartList.add(
        CartModel.fromJson(jsonDecode(element))
      );
    }
    return cartList;
  }

  void addToCartHistory(){
    if(sharedPreferences.containsKey(AppConstants.CART_HISTORY_LIST)){
      _cartHistory=sharedPreferences.getStringList(AppConstants.CART_HISTORY_LIST)!;
    }
    for(int i=0; i<_cart.length; i++){
      _cartHistory.add(_cart[i]);
    }
    //removeCart();
    sharedPreferences.setStringList(AppConstants.CART_HISTORY_LIST, _cartHistory);
  }
  List<CartModel> getCartHistoryList(){
    if(sharedPreferences.containsKey(AppConstants.CART_HISTORY_LIST)){
      _cartHistory=[];
      _cartHistory=sharedPreferences.getStringList(AppConstants.CART_HISTORY_LIST)!;
    }
  
    List<CartModel> cartListhistory=[];
    for (var element in _cartHistory) {
      cartListhistory.add(CartModel.fromJson(jsonDecode(element)));
    }
    return cartListhistory;
  }

  void removeCart(){
    _cart.clear();
    sharedPreferences.remove(AppConstants.CART_LIST);
  }

}
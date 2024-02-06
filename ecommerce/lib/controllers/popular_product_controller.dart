import 'package:ecommerce/controllers/cart_controller.dart';
import 'package:ecommerce/data/repository/popular_product_repo.dart';
import 'package:ecommerce/models/cart_model.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopularProductController extends GetxController{
  final PopularProductRepo popularProductRepo; 

  PopularProductController({required this.popularProductRepo});
  late CartController _cart; 

  List<ProductModel> _popularProductList=[]; //private variable
  List<ProductModel> get popularProductList => _popularProductList; 

  bool _isLoaded = false ;
  bool get isLoaded=>_isLoaded;
  int _quantity = 0; 
  int get quantity => _quantity;
  int _inCartItems=0;
  int get inCartItems=>_inCartItems+_quantity;

  Future<void> getPopularProductList() async {
    Response res = await popularProductRepo.getPopularProductList();
    if(res.statusCode == 200){
      _popularProductList=[];
      _popularProductList.addAll(Product.fromJson(res.body).products); 
      _isLoaded=true;
      update(); //like setState, to update the UI
    }else{

    }

  }

  void setQuantity(bool isIncrement){
    if(isIncrement){
      _quantity=checkQuantity(_quantity+1);
    }else{
      _quantity=checkQuantity(_quantity-1);
    }
    update();
  }

  int checkQuantity(int quantity){
    if((_inCartItems+_quantity)<0){
      Get.snackbar("Item count", "No items to remove!", backgroundColor: AppColors.darkBlue, colorText: Colors.white);
      if(_inCartItems>0){
        _quantity = -_inCartItems;
        return _quantity;
      }
      return 0;
    }else if ((_inCartItems+_quantity)>20){
      Get.snackbar("Item count", "Maximum number of items reached!", backgroundColor: AppColors.darkBlue, colorText: Colors.white);
      return 20;
    }else{
      return quantity;
    }
  }

  void initProduct(ProductModel product, CartController cartController){
    _quantity=0;
    _cart=cartController;
    var exist=false; 
    exist=_cart.existInCart(product);
    if(exist){
      _inCartItems=_cart.getProductQuantity(product);
    }else{
      _inCartItems=_quantity;
    }
    

  }

  void addItem(ProductModel p){
      _cart.addItem(p, _quantity);
      _quantity=0;
      _inCartItems=_cart.getProductQuantity(p);
      update();    
  }

  int get totalItems{
    return _cart.totalItems;
  }

}
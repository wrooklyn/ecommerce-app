import 'package:ecommerce/data/repository/cart_repo.dart';
import 'package:ecommerce/models/cart_model.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController{
  final CartRepo cartRepo; 

  CartController({required this.cartRepo});
  Map<String, CartModel> _items ={};
  Map<String, CartModel> get items=>_items;
  List<CartModel> _storageItems=[];

  void addItem(ProductModel product, int quantity){
    var totalQuantity=0; 

    if(_items.containsKey(product.id)){
      _items.update(product.id!, (p){
        totalQuantity=p.quantity!+quantity;
        return CartModel(
          id: p.id, 
          name:p.name, 
          price: p.price, 
          img:p.img, 
          quantity:p.quantity!+quantity, 
          exist:true, 
          time:DateTime.now().toString(),
          description: p.description,
          product: product
        );
        });
        if(totalQuantity<=0){
          _items.remove(product.id);
        }
    }else{
      if(quantity>0){
         _items.putIfAbsent(product.id!, (){
        return CartModel(
          id: product.id, 
          name:product.name, 
          price: product.price, 
          img:product.img, 
          quantity:quantity, 
          exist:true, 
          time:DateTime.now().toString(),
          description: product.description,
          product: product
        );
        }); 
      }else{
      Get.snackbar("No Items", "No items to add cart!", backgroundColor: AppColors.darkBlue, colorText: Colors.white);
    }
    }
    cartRepo.addToCartList(getCart);
    update();
  }

  bool existInCart(ProductModel p){
    if(_items.containsKey(p.id)){
      return true;
    }else{
      return false; 
    }
  }

  int getProductQuantity(ProductModel p){
    int qty=0;
    if(_items.containsKey(p.id)){
      _items.forEach((key, value) {
        if(key==p.id){
          qty=value.quantity!;
        }
      });
    }
    return qty;
  }
  
  int get totalItems{
    var totalQuantity=0;
    _items.forEach((key, value) {
      totalQuantity+=value.quantity!;
    });
    return totalQuantity;
  }

  List<CartModel> get getCart{
    return _items.entries.map((e){
      return e.value;
    }).toList();
  }

  int get totalAmount{
    var total=0;
    items.forEach((_, product) {
      total +=(product.price!*product.quantity!);
    });
    return total;
  }

  List<CartModel> getCartData(){
    setCart = cartRepo.getCartList();
    return _storageItems;
  }

  set setCart(List<CartModel> items){
    _storageItems=items; 
    for(int i=0; i<_storageItems.length; i++){
      _items.putIfAbsent(_storageItems[i].product!.id!, () => _storageItems[i]);
    }
  }

  void addToHistory(){
    cartRepo.addToCartHistory();
    //clear();
  }
  void clear(){
    _items={};
    update();
  }
}
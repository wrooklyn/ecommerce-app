

import 'package:ecommerce/models/product_model.dart';

class CartModel {
  String? id;
  String? name;
  int? price;
  String? img;
  int? quantity; 
  bool? exist; 
  String? time; 
  String? description; 
  ProductModel? product; 
  
  CartModel(
      {this.id,
      this.name,
      this.price,
      this.img,
      this.quantity,
      this.exist,
      this.time,
      this.description,
      this.product,
    });

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    price = json['price'];
    img = json['img'];
    quantity=json['quantity'];
    exist=json['exist'];
    time=json['time'];
    description=json['description'];
    product=ProductModel.fromJson(json['product']);
  }

  Map<String, dynamic> toJson(){
    return {
      "_id": id,
      "name": name,
      "price": price,
      "img": img,
      "quantity": quantity,
      "exist": exist, 
      "time": time,
      "description": product!.description,
      "product": product!.toJson()
    };
  }
}

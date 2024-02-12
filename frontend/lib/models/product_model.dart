class Product {
  int? _totalSize;
  String? _typeId;
  int? _offset;
  late List<ProductModel> _products;
  List<ProductModel> get products => _products; 

  Product({required totalSize, required typeId, required offset, required products}){
    this._totalSize=totalSize;
    this._typeId=typeId;
    this._offset=offset;
  }

  Product.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _typeId = json['type_id'];
    _offset = json['offset'];
    if (json['products'] != null) {
      _products = <ProductModel>[];
      json['products'].forEach((p) {
        _products.add(ProductModel.fromJson(p));
      });
    }
  }

}

class ProductModel {
  String? id;
  String? name;
  String? description;
  int? price;
  int? stars;
  String? img;
  String? location;
  String? createdAt;
  String? updatedAt;
  String? category;

  ProductModel(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.stars,
      this.img,
      this.location,
      this.createdAt,
      this.updatedAt,
      this.category});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    stars = json['stars'];
    img = json['img'];
    location = json['location'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    category = json['category'];
  }

  Map<String, dynamic> toJson(){
    return{
      "_id": id,
      "name": name,
      "description": description,
      "price": price,
      "stars": stars,
      "img": img,
      "location": location,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "category": category
    };
  }

  @override
  bool operator ==(Object p) {
    if (identical(this, p)) {
      return true;
    }
    if (p.runtimeType != runtimeType) {
      return false;
    }
    return p is ProductModel
        && p.id == id;
  }
    
}

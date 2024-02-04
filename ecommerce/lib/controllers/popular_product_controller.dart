import 'package:ecommerce/data/repository/popular_product_repo.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:get/get.dart';

class PopularProductController extends GetxController{
  final PopularProductRepo popularProductRepo; 

  PopularProductController({required this.popularProductRepo});

  List<ProductModel> _popularProductList=[]; //private variable
  List<ProductModel> get popularProductList => _popularProductList; 

  bool _isLoaded = false ;
  bool get isLoaded=>_isLoaded;

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
}
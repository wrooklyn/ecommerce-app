import 'package:ecommerce/data/repository/recommended_product_repo.dart';
import 'package:ecommerce/models/product_model.dart';
import 'package:get/get.dart';

class RecommendedProductController extends GetxController{
  final RecommendedProductRepo recommendedProductRepo; 

  RecommendedProductController({required this.recommendedProductRepo});

  List<ProductModel> _recommendedProductList=[]; //private variable
  List<ProductModel> get recommendedProductList => _recommendedProductList; 

  bool _isLoaded = false ;
  bool get isLoaded=>_isLoaded;

  Future<void> getRecommendedProductList() async {
    Response res = await recommendedProductRepo.getRecommendedProductList();
    if(res.statusCode == 200){
      _recommendedProductList=[];
      _recommendedProductList.addAll(Product.fromJson(res.body).products); 
      _isLoaded=true;
      update(); //like setState, to update the UI
    }else{

    }

  }
}
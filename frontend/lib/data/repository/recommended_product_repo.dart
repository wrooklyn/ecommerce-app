import 'package:ecommerce/data/api/api.dart';
import 'package:ecommerce/utils/app_constants.dart';
import 'package:get/get.dart';

//when we load data from the internet, we should extend GetxService
class RecommendedProductRepo extends GetxService{
  final ApiClient apiClient; //to access api client, this is why we're creating an instance
  
  RecommendedProductRepo({required this.apiClient});

  Future<Response> getRecommendedProductList() async{
    return await apiClient.getData(AppConstants.RECOMMENDED_PRODUCT_URI);
  }

}
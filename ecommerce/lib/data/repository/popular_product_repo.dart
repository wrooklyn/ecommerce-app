import 'package:ecommerce/data/api/api.dart';
import 'package:ecommerce/utils/app_constants.dart';
import 'package:get/get.dart';

//when we load data from the internet, we should extend GetxService
class PopularProductRepo extends GetxService{
  final ApiClient apiClient; //to access api client, this is why we're creating an instance
  
  PopularProductRepo({required this.apiClient});

  Future<Response> getPopularProductList() async{
    return await apiClient.getData(AppConstants.POPULAR_PRODUCT_URI);
  }

}
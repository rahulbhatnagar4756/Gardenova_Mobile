import 'package:get/get.dart';
import 'package:kasagardem/dashboard/plant_recommendations/plants_catalog/plants_list_response_model.dart';

class PlantDetailViewModel extends GetxController {
  Rx<Plants> plantDetail = Plants().obs;

  @override
  void onInit() {
    super.onInit();
    var response = Get.arguments;
    if (response != null) {
      plantDetail.value = response;
    }
  }
}

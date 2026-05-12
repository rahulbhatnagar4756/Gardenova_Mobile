import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/plants/myPlants/myPlantDetails/model/my_plant_detail_model.dart';
import '../../plant_repository.dart';

class MyPlantDetailsController extends GetxController {
  RxString plantId = "".obs;
  PlantsRepository plantsRepository = PlantsRepository();
  Rx<MyPlantDetailModel> plantDetailData = MyPlantDetailModel().obs;

  RxBool isLoading = false.obs;
  RxString errorMessage = "".obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      plantId.value = Get.arguments.toString();
    }
    callGetMyPlantDetailsApi();
    super.onInit();
  }

  Future callGetMyPlantDetailsApi() async {
    isLoading.value = true;
    errorMessage.value = "";
    try {
      var response = await plantsRepository.fetchMyPlantDetail(
        plantId: plantId.value,
      );
      if (response != null) {
        plantDetailData.value = MyPlantDetailModel.fromJson(response);
      } else {
        errorMessage.value = "No plant data found";
      }
    } catch (e) {
      errorMessage.value = "An error occurred: $e";
      debugPrint("MyPlantDetailsController callGetMyPlantDetailsApi: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

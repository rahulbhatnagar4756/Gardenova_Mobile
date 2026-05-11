import 'package:get/get.dart';
import '../../model/plant_details_model.dart';
import '../../plant_repository.dart';

class MyPlantDetailsController extends GetxController {
  RxString plantId = "".obs;
  PlantsRepository plantsRepository = PlantsRepository();
  Rx<PlantDetailsResponseModel> plantDetailData =
      PlantDetailsResponseModel().obs;

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
        plantDetailData.value = PlantDetailsResponseModel.fromJson(response);
      } else {
        errorMessage.value = "No plant data found";
      }
    } catch (e) {
      errorMessage.value = "An error occurred: $e";
    } finally {
      isLoading.value = false;
    }
  }
}

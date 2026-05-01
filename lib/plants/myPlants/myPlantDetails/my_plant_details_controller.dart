import 'package:get/get.dart';
import '../../model/plant_details_model.dart';
import '../../plant_repository.dart';

class MyPlantDetailsController extends GetxController {
  RxString plantId = "".obs;
  PlantsRepository plantsRepository = PlantsRepository();
  Rx<PlantDetailsResponseModel> plantDetailData =
      PlantDetailsResponseModel().obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      plantId.value = Get.arguments.toString();
    }
    callGetMyPlantDetailsApi();
    super.onInit();
  }

  Future callGetMyPlantDetailsApi() async {
    var response = await plantsRepository.fetchMyPlantDetail(
      plantId: plantId.value,
    );
    if (response != null) {
      plantDetailData.value = PlantDetailsResponseModel.fromJson(response);
    }
  }
}

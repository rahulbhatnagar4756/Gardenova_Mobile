import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'landscape_design_repository.dart';
import 'model/landscape_design_model.dart';

class LandscapeDesignViewModel extends GetxController {
  final LandscapeDesignRepository _repository = LandscapeDesignRepository();

  Rx<File>? imageFile = File('').obs;
  Rx<LandscapeDesignResponseModel> landscapeResponse =
      LandscapeDesignResponseModel().obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = "".obs;
  RxString selectedStyle = "modern".obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['image_path'] != null) {
      imageFile!.value = File(Get.arguments['image_path']);
      generateLandscapeDesign();
    }
  }

  Future<void> generateLandscapeDesign() async {
    if (imageFile!.value.path.isEmpty) {
      errorMessage.value = "No image selected";
      return;
    }

    isLoading.value = true;
    errorMessage.value = "";

    try {
      List<int> imageBytes = await imageFile!.value.readAsBytes();
      String base64String = base64Encode(imageBytes);

      LandscapeDesignRequestModel request = LandscapeDesignRequestModel(
        imageBase64: base64String,
        prefs: Prefs(style: selectedStyle.value),
      );
      // await Future.delayed(const Duration(seconds: 2));
      // throw Exception("An error testing");
      var response = await _repository.generateLandscapeDesign(
        request: request,
      );

      if (response != null) {
        landscapeResponse.value = LandscapeDesignResponseModel.fromJson(
          response,
        );
        if (landscapeResponse.value.success != true) {
          errorMessage.value =
              landscapeResponse.value.message ?? "Generation failed";
        }
      } else {
        errorMessage.value = "Unable to generate landscape design";
      }
    } catch (e) {
      errorMessage.value = "An error occurred: $e";
    } finally {
      isLoading.value = false;
    }
  }
}

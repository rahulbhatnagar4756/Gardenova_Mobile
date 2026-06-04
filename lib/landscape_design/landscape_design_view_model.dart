import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/network_services/app_exceptions.dart';
import 'package:path_provider/path_provider.dart';
import 'landscape_design_repository.dart';
import 'model/landscape_design_model.dart';

class LandscapeDesignViewModel extends GetxController {
  final LandscapeDesignRepository _repository = LandscapeDesignRepository();

  Rx<File>? imageFile = File('').obs;
  Rx<LandscapeDesignResponseModel> landscapeResponse =
      LandscapeDesignResponseModel().obs;
  RxBool isLoading = false.obs;
  RxBool isApiComplete = false.obs;
  RxBool isRegenerating = false.obs;
  RxBool isDownloading = false.obs;
  RxString errorMessage = "".obs;
  RxString selectedStyle = "modern".obs;
  String lastGeneratedStyle = "";
  final gardenStyles = [
    "modern",
    "luxury",
    "luxury_modern",
    "tropical",
    "modern_tropical",
    "japanese",
    "minimalist",
    "mediterranean",
    "cottage",
    "contemporary",
    "eco_friendly",
    "desert",
  ];
  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments['selected_style'] != null) {
        selectedStyle.value = Get.arguments['selected_style'].toString();
      }
      if (Get.arguments['image_path'] != null) {
        imageFile!.value = File(Get.arguments['image_path']);
        generateLandscapeDesign();
      }
    }
  }

  Future<void> generateLandscapeDesign() async {
    if (selectedStyle.value == lastGeneratedStyle &&
        landscapeResponse.value.data != null) {
      Get.snackbar(
        "Notice",
        "This style is already applied",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.greenColor,
        colorText: AppColors.whiteColor,
      );
      return;
    }

    if (imageFile!.value.path.isEmpty) {
      errorMessage.value = "No image selected";
      return;
    }

    if (landscapeResponse.value.data == null) {
      isLoading.value = true;
    } else {
      isRegenerating.value = true;
    }
    errorMessage.value = "";

    try {
      List<int> imageBytes = await imageFile!.value.readAsBytes();
      String base64String = base64Encode(imageBytes);

      LandscapeDesignRequestModel request = LandscapeDesignRequestModel(
        imageBase64: base64String,
        prefs: Prefs(style: selectedStyle.value),
      );

      var response = await _repository.generateLandscapeDesign(
        request: request,
      );

      if (response != null) {
        landscapeResponse.value = LandscapeDesignResponseModel.fromJson(
          response,
        );
        if (landscapeResponse.value.success == true) {
          lastGeneratedStyle = selectedStyle.value;
        }
        if (landscapeResponse.value.success != true) {
          errorMessage.value = _cleanErrorMessage(
            landscapeResponse.value.message ?? "Generation failed",
          );
        }
      } else {
        errorMessage.value = "Unable to generate landscape design";
      }
    } catch (e) {
      if (e is BadRequestException) {
        errorMessage.value = _cleanErrorMessage(e.message);
      } else if (e is FetchDataException) {
        errorMessage.value = _cleanErrorMessage(e.message);
      } else if (e is UnauthorisedException) {
        errorMessage.value = _cleanErrorMessage(e.message);
      } else if (e is NotFoundException) {
        errorMessage.value = _cleanErrorMessage(e.message);
      } else if (e is ConflictException) {
        errorMessage.value = _cleanErrorMessage(e.message);
      } else {
        errorMessage.value = _cleanErrorMessage("An error occurred: $e");
      }
    } finally {
      if (isLoading.value) {
        if (errorMessage.value.isNotEmpty) {
          isLoading.value = false;
        } else {
          isApiComplete.value = true;
        }
      } else if (isRegenerating.value) {
        if (errorMessage.value.isNotEmpty) {
          isRegenerating.value = false;
        } else {
          isApiComplete.value = true;
        }
      }
    }
  }

  void onLoadingAnimationComplete() {
    isLoading.value = false;
    isRegenerating.value = false;
    isApiComplete.value = false;
  }

  void updateStyle(String style) {
    selectedStyle.value = style;
  }

  Future<void> updateStyleAndRegenerate(String style) async {
    selectedStyle.value = style;
    await generateLandscapeDesign();
  }

  // Future<void> downloadAndShareImage(String url) async {
  //   if (url.isEmpty) return;

  //   try {
  //     isDownloading.value = true;
  //     final response = await http.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       final tempDir = await getTemporaryDirectory();
  //       String fileName = url.split('/').last.split('?').first;

  //       // Ensure we have a valid extension
  //       if (!fileName.contains('.')) {
  //         final contentType = response.headers['content-type'];
  //         if (contentType != null) {
  //           if (contentType.contains('image/png')) {
  //             fileName += '.png';
  //           } else if (contentType.contains('image/jpeg')) {
  //             fileName += '.jpg';
  //           } else if (contentType.contains('image/gif')) {
  //             fileName += '.gif';
  //           } else if (contentType.contains('image/webp')) {
  //             fileName += '.webp';
  //           } else {
  //             fileName += '.jpg'; // Fallback
  //           }
  //         } else {
  //           fileName += '.jpg'; // Fallback
  //         }
  //       }

  //       final file = File('${tempDir.path}/$fileName');
  //       await file.writeAsBytes(response.bodyBytes);

  //       await Share.shareXFiles([
  //         XFile(file.path),
  //       ], text: 'Check out my garden design!');
  //     } else {
  //       errorMessage.value = "Failed to download image";
  //     }
  //   } catch (e) {
  //     errorMessage.value = "Error sharing image: $e";
  //   } finally {
  //     isDownloading.value = false;
  //   }
  // }

  Future<void> downloadAndSaveToGallery(String url) async {
    if (url.isEmpty) return;
    debugPrint('on Click downloadAndSaveToGallery $url');
    try {
      isDownloading.value = true;
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        String fileName = url.split('/').last.split('?').first;

        // Ensure we have a valid extension
        if (!fileName.contains('.')) {
          final contentType = response.headers['content-type'];
          if (contentType != null) {
            if (contentType.contains('image/png')) {
              fileName += '.png';
            } else if (contentType.contains('image/jpeg')) {
              fileName += '.jpg';
            } else if (contentType.contains('image/gif')) {
              fileName += '.gif';
            } else if (contentType.contains('image/webp')) {
              fileName += '.webp';
            } else {
              fileName += '.jpg'; // Fallback
            }
          } else {
            fileName += '.jpg'; // Fallback
          }
        }

        final file = File('${tempDir.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);

        await Gal.putImage(file.path);
        Get.snackbar(
          "Success",
          "Image saved to gallery",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.greenColor,
          colorText: AppColors.whiteColor,
        );
      } else {
        errorMessage.value = "Failed to download image";
      }
    } catch (e) {
      debugPrint('Error saving image: $e');
      errorMessage.value = "Error saving image: $e";
    } finally {
      isDownloading.value = false;
    }
  }

  String _cleanErrorMessage(String errorMsg) {
    if (errorMsg.contains('{') && errorMsg.contains('}')) {
      try {
        final startIndex = errorMsg.indexOf('{');
        final endIndex = errorMsg.lastIndexOf('}');
        if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
          final jsonPart = errorMsg.substring(startIndex, endIndex + 1);
          final decoded = jsonDecode(jsonPart);
          if (decoded is Map) {
            if (decoded.containsKey('message')) {
              return decoded['message'].toString();
            } else if (decoded.containsKey('error')) {
              return decoded['error'].toString();
            }
          }
        }
      } catch (_) {}
    }

    final messageMatch = RegExp(
      r'"message"\s*:\s*"([^"]+)"',
    ).firstMatch(errorMsg);
    if (messageMatch != null && messageMatch.groupCount >= 1) {
      return messageMatch.group(1)!;
    }

    final errorMatch = RegExp(r'"error"\s*:\s*"([^"]+)"').firstMatch(errorMsg);
    if (errorMatch != null && errorMatch.groupCount >= 1) {
      return errorMatch.group(1)!;
    }

    return errorMsg;
  }
}

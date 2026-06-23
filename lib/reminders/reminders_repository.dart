import 'package:kasagardem/reminders/model/category_model.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';
import 'package:kasagardem/utils/network_services/api_repository.dart';

class RemindersRepository {
  List<CategoryModel> fetchStatuses() {
    return [
      CategoryModel(title: AppStrings.all, code: "all", counter: "10"),
      CategoryModel(title: AppStrings.upcoming, code: "upcoming", counter: "3"),
      CategoryModel(title: AppStrings.missed, code: "missed", counter: "2"),
      CategoryModel(title: AppStrings.completed, code: "completed", counter: "5"),
    ];
  }

  List<CategoryModel> fetchTypes() {
    return [
      CategoryModel(title: AppStrings.allTypes, code: "all"),
      CategoryModel(title: AppStrings.water, code: "water"),
      CategoryModel(title: AppStrings.prune, code: "prune"),
      CategoryModel(title: AppStrings.fertilize, code: "fertilize"),
    ];
  }

  final String deletePlantUrl = 'api/v1/allplants/user/notification';
  final String _deviceTokenUrl = 'api/v1/allplants/user/notification/device-token';

  Future<dynamic> registerDeviceToken({
    required String fcmToken,
    required String deviceType,
    bool enabled = true,
  }) async {
    return ApiRepository.instance.post(
      _deviceTokenUrl,
      body: {
        'fcm_token': fcmToken,
        'device_type': deviceType,
        'enabled': enabled,
      },
      showDefaultLoader: false,
      showRunTimeError: false,
    );
  }

  Future<dynamic> fetchAllPlants({
    String? pageNumber,
    String? pageSize,
    //   String? searchName,
    String? eventType,
    String? activityType,
    bool showDefaultLoader = true,
  }) async {
    var endUrl = "$deletePlantUrl/$activityType/$eventType?page=$pageNumber&limit=$pageSize";
    // if (searchName != null && searchName.isNotEmpty) {
    //   endUrl = "$endUrl&search=$searchName";
    // }
    var plantsResponse = await ApiRepository.instance.get(
      endUrl,
      showDefaultLoader: showDefaultLoader,
    );
    print(plantsResponse);
    return plantsResponse;
  }
}

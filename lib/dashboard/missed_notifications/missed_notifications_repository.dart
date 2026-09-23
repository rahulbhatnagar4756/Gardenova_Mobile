import 'dart:developer';

import 'package:kasagardem/utils/network_services/api_repository.dart';

class MissedNotificationsRepository {
  static const String _endpoint = 'api/v1/missed-notifications';

  Future<dynamic> fetchMissedNotifications({required int page, int limit = 20}) {
    return ApiRepository.instance.get(
      '$_endpoint?page=$page&limit=$limit',
      showDefaultLoader: false,
    );
  }

  Future<dynamic> completeMissedNotification(String id) {
    log('Complete missed notification id: $_endpoint/$id/complete');
    return ApiRepository.instance.patch(
      '$_endpoint/$id/complete',
      {'is_completed': true},
      showDefaultLoader: true,
    );
  }
}

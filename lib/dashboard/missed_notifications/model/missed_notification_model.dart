class MissedNotificationsResponseModel {
  final bool success;
  final String? message;
  final MissedNotificationsData? data;

  const MissedNotificationsResponseModel({
    this.success = false,
    this.message,
    this.data,
  });

  factory MissedNotificationsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MissedNotificationsResponseModel(
      success: json['success'] == true,
      message: json['message'] as String?,
      data: json['data'] is Map
          ? MissedNotificationsData.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            )
          : null,
    );
  }
}

class MissedNotificationsData {
  final List<MissedNotificationItem> items;
  final MissedNotificationPagination? pagination;

  const MissedNotificationsData({
    this.items = const [],
    this.pagination,
  });

  factory MissedNotificationsData.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'];
    return MissedNotificationsData(
      items: itemsJson is List
          ? itemsJson
                .whereType<Map>()
                .map(
                  (item) => MissedNotificationItem.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : const [],
      pagination: json['pagination'] is Map
          ? MissedNotificationPagination.fromJson(
              Map<String, dynamic>.from(json['pagination'] as Map),
            )
          : null,
    );
  }
}

class MissedNotificationPagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  const MissedNotificationPagination({
    this.page = 1,
    this.limit = 20,
    this.total = 0,
    this.totalPages = 1,
    this.hasNext = false,
    this.hasPrev = false,
  });

  factory MissedNotificationPagination.fromJson(Map<String, dynamic> json) {
    return MissedNotificationPagination(
      page: _asInt(json['page'], fallback: 1),
      limit: _asInt(json['limit'], fallback: 20),
      total: _asInt(json['total']),
      totalPages: _asInt(json['total_pages'], fallback: 1),
      hasNext: json['has_next'] == true,
      hasPrev: json['has_prev'] == true,
    );
  }
}

class MissedNotificationItem {
  final String id;
  final String userId;
  final String plantId;
  final String notificationFeature;
  final int missedCount;
  final String commonName;
  final String scientificName;

  const MissedNotificationItem({
    this.id = '',
    this.userId = '',
    this.plantId = '',
    this.notificationFeature = '',
    this.missedCount = 0,
    this.commonName = '',
    this.scientificName = '',
  });

  factory MissedNotificationItem.fromJson(Map<String, dynamic> json) {
    return MissedNotificationItem(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      plantId: json['plant_id']?.toString() ?? '',
      notificationFeature: json['notification_feature']?.toString() ?? '',
      missedCount: _asInt(json['missed_count']),
      commonName: json['common_name']?.toString() ?? '',
      scientificName: json['scientific_name']?.toString() ?? '',
    );
  }
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

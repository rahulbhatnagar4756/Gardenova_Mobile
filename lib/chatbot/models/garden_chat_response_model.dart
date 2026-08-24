class GardenChatResponseModel {
  bool? success;
  String? message;
  GardenChatData? data;

  GardenChatResponseModel({this.success, this.message, this.data});

  GardenChatResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] is Map) {
      data = GardenChatData.fromJson(
        Map<String, dynamic>.from(json['data'] as Map),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['success'] = success;
    json['message'] = message;
    if (data != null) {
      json['data'] = data!.toJson();
    }
    return json;
  }
}

class GardenChatData {
  String? conversationId;
  bool? isGardeningRelated;
  String? reply;
  List<GardenChatHistoryItem>? history;
  GardenChatPagination? pagination;
  List<String>? suggestionsQuestion;

  GardenChatData({
    this.conversationId,
    this.isGardeningRelated,
    this.reply,
    this.history,
    this.pagination,
    this.suggestionsQuestion,
  });

  GardenChatData.fromJson(Map<String, dynamic> json) {
    conversationId = json['conversationId']?.toString();
    isGardeningRelated = json['isGardeningRelated'];
    reply = json['reply']?.toString();
    if (json['history'] is List) {
      history = <GardenChatHistoryItem>[];
      json['history'].forEach((item) {
        if (item is Map) {
          history!.add(
            GardenChatHistoryItem.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      });
    }
    pagination = json['pagination'] != null
        ? GardenChatPagination.fromJson(json['pagination'])
        : null;
    suggestionsQuestion = _parseSuggestionQuestions(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['conversationId'] = conversationId;
    json['isGardeningRelated'] = isGardeningRelated;
    json['reply'] = reply;
    if (history != null) {
      json['history'] = history!.map((item) => item.toJson()).toList();
    }
    if (pagination != null) {
      json['pagination'] = pagination!.toJson();
    }
    if (suggestionsQuestion != null) {
      json['suggestionsQustion'] = suggestionsQuestion;
    }
    return json;
  }
}

List<String>? _parseSuggestionQuestions(Map<String, dynamic> json) {
  final raw = json['suggestionsQustion'] ?? json['suggestionsQuestion'];
  if (raw is! List) return null;
  final parsed = raw
      .map((item) => item.toString().trim())
      .where((item) => item.isNotEmpty)
      .toList();
  return parsed.isEmpty ? null : parsed;
}

class GardenChatPagination {
  int? currentPage;
  int? totalPages;
  int? totalCount;
  int? limit;

  GardenChatPagination({
    this.currentPage,
    this.totalPages,
    this.totalCount,
    this.limit,
  });

  GardenChatPagination.fromJson(Map<String, dynamic> json) {
    currentPage = int.tryParse(json['currentPage']?.toString() ?? '');
    totalPages = int.tryParse(json['totalPages']?.toString() ?? '');
    totalCount = int.tryParse(json['totalCount']?.toString() ?? '');
    limit = int.tryParse(json['limit']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalCount': totalCount,
      'limit': limit,
    };
  }
}

class GardenChatHistoryItem {
  GardenChatTurn? question;
  GardenChatTurn? answer;

  GardenChatHistoryItem({this.question, this.answer});

  GardenChatHistoryItem.fromJson(Map<String, dynamic> json) {
    question = json['question'] != null
        ? GardenChatTurn.fromJson(json['question'])
        : null;
    answer = json['answer'] != null
        ? GardenChatTurn.fromJson(json['answer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    if (question != null) {
      json['question'] = question!.toJson();
    }
    if (answer != null) {
      json['answer'] = answer!.toJson();
    }
    return json;
  }
}

class GardenChatTurn {
  String? role;
  String? content;
  String? imageUrl;
  DateTime? createdAt;

  GardenChatTurn({this.role, this.content, this.imageUrl, this.createdAt});

  GardenChatTurn.fromJson(Map<String, dynamic> json) {
    role = json['role']?.toString();
    content = json['content']?.toString();
    final image = json['imageUrl'];
    if (image != null && image.toString().isNotEmpty && image.toString() != 'null') {
      imageUrl = image.toString();
    }
    createdAt = json['createdAt'] != null
        ? _parseApiDateTime(json['createdAt'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['role'] = role;
    json['content'] = content;
    json['imageUrl'] = imageUrl;
    json['createdAt'] = createdAt?.toIso8601String();
    return json;
  }
}

DateTime? _parseApiDateTime(dynamic value) {
  final raw = value.toString().trim();
  if (raw.isEmpty || raw == 'null') return null;
  final withoutZone = raw
      .replaceFirst(RegExp(r'[Zz]$'), '')
      .replaceFirst(RegExp(r'[+-]\d{2}:?\d{2}$'), '');
  return DateTime.tryParse(withoutZone) ?? DateTime.tryParse(raw);
}

import 'package:kasagardem/chatbot/models/garden_chat_request_model.dart';
import 'package:kasagardem/utils/network_services/api_repository.dart';

class ChatbotRepository {
  final String _gardenChatEndPoint = 'api/v1/garden-chat';
  final String _gardenChatHistoryEndPoint = 'api/v1/garden-chat/history';

  Future<dynamic> sendMessage({required GardenChatRequestModel request}) async {
    return ApiRepository.instance.post(
      _gardenChatEndPoint,
      body: request.toJson(),
      showDefaultLoader: false,
      showRunTimeError: false,
      rethrowExceptions: true,
    );
  }

  Future<dynamic> fetchHistory({required int page, required int limit}) async {
    return ApiRepository.instance.get(
      '$_gardenChatHistoryEndPoint?page=$page&limit=$limit',
      showDefaultLoader: false,
      showRunTimeError: false,
      rethrowExceptions: true,
    );
  }
}

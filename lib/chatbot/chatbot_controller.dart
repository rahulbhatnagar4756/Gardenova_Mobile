import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasagardem/base/open_image_pciker_bottom_sheet.dart';
import 'package:kasagardem/base/widgets/circular_bottom_app_bar.dart';
import 'package:kasagardem/chatbot/chatbot_repository.dart';
import 'package:kasagardem/chatbot/models/chat_message.dart';
import 'package:kasagardem/chatbot/models/garden_chat_request_model.dart';
import 'package:kasagardem/chatbot/models/garden_chat_response_model.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';
import 'package:kasagardem/utils/network_services/app_exceptions.dart';
import 'package:kasagardem/utils/permission_manager.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';

class ChatbotController extends GetxController {
  final ChatbotRepository _repository = ChatbotRepository();
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxList<String> suggestions = <String>[].obs;
  final Rxn<File> selectedImage = Rxn<File>();
  final RxBool hasText = false.obs;
  final RxBool isTyping = false.obs;
  final RxBool isLoadingHistory = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreHistory = false.obs;
  final RxnString upgradeRequiredMessage = RxnString();
  final RxnString speakingMessageId = RxnString();
  final RxDouble speakingProgress = 0.0.obs;

  final FlutterTts _tts = FlutterTts();
  Future<void>? _ttsInit;
  int _speechToken = 0;
  int _playingToken = 0;
  int _speakingTextLength = 0;

  String? conversationId;
  int _currentPage = 1;
  int _totalPages = 1;
  final int _pageSize = 10;
  bool _canPaginate = false;

  bool get isUpgradeRequired =>
      upgradeRequiredMessage.value != null &&
      upgradeRequiredMessage.value!.trim().isNotEmpty;

  bool get canSend {
    if (isUpgradeRequired || isTyping.value) return false;
    return hasText.value || selectedImage.value != null;
  }

  String get userFirstName {
    final fullName = SharedPrefsService.instance.getString(AppKeys.name) ?? '';
    if (fullName.trim().isEmpty) return '';
    return fullName.trim().split(RegExp(r'\s+')).first;
  }

  String get greeting {
    return getGreeting();
  }

  String get greetingTitle {
    final name = userFirstName;
    if (name.isEmpty) return greeting;
    return '$greeting,\n$name';
  }

  void onTextChanged(String value) {
    hasText.value = value.trim().isNotEmpty;
  }

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    _ensureTtsReady();
    fetchHistory(reset: true);
  }

  Future<void> _ensureTtsReady() {
    return _ttsInit ??= _initTts();
  }

  Future<void> _initTts() async {
    try {
      if (Platform.isIOS) {
        await _tts.setSharedInstance(true);
        await _tts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playback,
          [
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
            IosTextToSpeechAudioCategoryOptions.mixWithOthers,
          ],
          IosTextToSpeechAudioMode.voicePrompt,
        );
      }

      await _tts.setVolume(1.0);
      await _tts.setSpeechRate(0.5);
      await _tts.setPitch(1.0);
      if (Platform.isAndroid) {
        await _tts.setQueueMode(0);
      }

      _tts.setStartHandler(() {
        if (_speechToken != _playingToken) return;
        speakingProgress.value = 0.02;
      });
      _tts.setProgressHandler((text, startOffset, endOffset, word) {
        if (_speechToken != _playingToken) return;
        final length = _speakingTextLength > 0 ? _speakingTextLength : text.length;
        if (length <= 0) return;
        speakingProgress.value = (endOffset / length).clamp(0.02, 1.0);
      });
      _tts.setCompletionHandler(() {
        if (_speechToken != _playingToken) return;
        speakingProgress.value = 1;
        _resetSpeechUi();
      });
      _tts.setCancelHandler(() {
        if (_speechToken != _playingToken) return;
        _resetSpeechUi();
      });
      _tts.setErrorHandler((_) {
        if (_speechToken != _playingToken) return;
        _resetSpeechUi();
      });
    } catch (e) {
      _ttsInit = null;
      debugPrint('Chatbot TTS init error: $e');
    }
  }

  Future<void> toggleSpeech({
    required String messageId,
    required String text,
  }) async {
    try {
      if (speakingMessageId.value == messageId) {
        await stopSpeech();
        return;
      }

      await stopSpeech();
      await _ensureTtsReady();
      await _setTtsLanguage();

      final token = ++_speechToken;
      _playingToken = token;
      _speakingTextLength = text.length;
      speakingProgress.value = 0.02;
      speakingMessageId.value = messageId;
      final result = await _tts.speak(text);
      if (token != _speechToken) return;
      if (result != 1 && result != true) {
        _resetSpeechUi();
      }
    } catch (e) {
      _resetSpeechUi();
      debugPrint('Chatbot TTS error: $e');
    }
  }

  Future<void> stopSpeech() async {
    _speechToken++;
    _resetSpeechUi();
    await _tts.stop();
  }

  void _resetSpeechUi() {
    speakingMessageId.value = null;
    speakingProgress.value = 0;
    _speakingTextLength = 0;
  }

  Future<void> _setTtsLanguage() async {
    final localeCode = Get.locale?.languageCode ?? 'en';
    final language = localeCode == 'pt' ? 'pt-BR' : 'en-US';
    try {
      final available = await _tts.isLanguageAvailable(language);
      if (available == true) {
        await _tts.setLanguage(language);
      } else {
        await _tts.setLanguage('en-US');
      }
    } catch (_) {
      await _tts.setLanguage('en-US');
    }
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    if (!_canPaginate) return;
    if (isLoadingHistory.value || isLoadingMore.value || isTyping.value) return;
    if (!hasMoreHistory.value) return;
    final position = scrollController.position;
    if (position.maxScrollExtent <= 0) return;
    if (position.pixels >= position.maxScrollExtent - 72) {
      loadMoreHistory();
    }
  }

  Future<void> fetchHistory({bool reset = false}) async {
    if (reset) {
      _currentPage = 1;
      isLoadingHistory.value = true;
    }

    try {
      final response = await _repository.fetchHistory(
        page: _currentPage,
        limit: _pageSize,
      );
      if (response == null) return;

      final responseMap = Map<String, dynamic>.from(response);
      final model = GardenChatResponseModel.fromJson(responseMap);
      final suggestionList = _readSuggestions(model.data, responseMap);

      if (reset) {
        upgradeRequiredMessage.value = null;
      }

      if (model.data == null) {
        if (reset) {
          messages.clear();
          _canPaginate = false;
          hasMoreHistory.value = false;
          suggestions.assignAll(suggestionList);
        }
        return;
      }

      if (model.success != true) return;

      conversationId = model.data!.conversationId ?? conversationId;
      final pagination = model.data!.pagination;
      _currentPage = pagination?.currentPage ?? _currentPage;
      _totalPages = pagination?.totalPages ?? _currentPage;
      hasMoreHistory.value = _currentPage < _totalPages;

      final mapped = _mapHistory(model.data!.history ?? []);
      if (reset) {
        messages.assignAll(mapped);
        _canPaginate = mapped.isNotEmpty;
        if (mapped.isEmpty) {
          suggestions.assignAll(suggestionList);
        } else {
          suggestions.clear();
        }
      } else {
        if (mapped.isEmpty) {
          hasMoreHistory.value = false;
        } else {
          _prependHistory(mapped);
        }
      }
    } catch (e) {
      if (reset && e is UnauthorisedException) {
        upgradeRequiredMessage.value = e.message.trim().isNotEmpty
            ? e.message
            : 'Garden chat is available for paid users only. Please upgrade your plan to continue.';
        messages.clear();
        suggestions.clear();
        hasMoreHistory.value = false;
        _canPaginate = false;
        return;
      }
      if (reset) {
        BaseSnackBar.show(title: _errorTitle(), message: _errorMessage(e));
      } else {
        _currentPage = (_currentPage - 1).clamp(1, _totalPages);
      }
    } finally {
      isLoadingHistory.value = false;
      isLoadingMore.value = false;
    }
  }

  void loadMoreHistory() {
    if (isUpgradeRequired) return;
    if (!hasMoreHistory.value || isLoadingMore.value || isLoadingHistory.value) {
      return;
    }
    isLoadingMore.value = true;
    _currentPage += 1;
    fetchHistory();
  }

  List<String> _readSuggestions(
    GardenChatData? data,
    Map<String, dynamic> response,
  ) {
    final fromData = data?.suggestionsQuestion;
    if (fromData != null && fromData.isNotEmpty) return fromData;

    dynamic raw = response['suggestionsQustion'] ?? response['suggestionsQuestion'];
    if (raw == null && response['data'] is Map) {
      final dataMap = Map<String, dynamic>.from(response['data'] as Map);
      raw = dataMap['suggestionsQustion'] ?? dataMap['suggestionsQuestion'];
    }
    if (raw is! List) return const [];
    return raw
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  List<ChatMessage> _mapHistory(List<GardenChatHistoryItem> history) {
    final mapped = <ChatMessage>[];
    for (final item in history) {
      if (item.question != null) {
        mapped.add(ChatMessage.fromTurn(item.question!));
      }
      if (item.answer != null && item.answer!.content?.trim().isNotEmpty == true) {
        mapped.add(ChatMessage.fromTurn(item.answer!));
      } else if (item.question != null) {
        mapped.add(
          _somethingWentWrongMessage(
            createdAt: item.answer?.createdAt ?? item.question?.createdAt,
          ),
        );
      }
    }
    mapped.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return mapped;
  }

  ChatMessage _somethingWentWrongMessage({
    DateTime? createdAt,
    bool animateIn = false,
  }) {
    return ChatMessage(
      id: 'assistant_error_${createdAt?.microsecondsSinceEpoch ?? DateTime.now().microsecondsSinceEpoch}',
      role: 'assistant',
      text: AppStrings.somethingWentWrong,
      createdAt: createdAt,
      animateIn: animateIn,
    );
  }

  void _prependHistory(List<ChatMessage> olderMessages) {
    if (olderMessages.isEmpty) return;

    final existingIds = messages.map((message) => message.id).toSet();
    final uniqueOlder = olderMessages
        .where((message) => !existingIds.contains(message.id))
        .toList();
    if (uniqueOlder.isEmpty) {
      hasMoreHistory.value = false;
      return;
    }

    messages.insertAll(0, uniqueOlder);
  }

  void applySuggestion(String text) {
    if (isUpgradeRequired || isTyping.value) return;
    messageController.text = text;
    messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: messageController.text.length),
    );
    hasText.value = text.trim().isNotEmpty;
    sendMessage();
  }

  Future<void> sendMessage() async {
    if (isUpgradeRequired || isTyping.value) return;

    final text = messageController.text.trim();
    final image = selectedImage.value;
    if (text.isEmpty && image == null) return;

    messages.add(
      ChatMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        role: 'user',
        text: text,
        imagePath: image?.path,
      ),
    );

    messageController.clear();
    hasText.value = false;
    selectedImage.value = null;
    isTyping.value = true;
    _scrollToBottom();

    var didGetReply = false;
    try {
      String? imageBase64;
      if (image != null) {
        imageBase64 = base64Encode(await image.readAsBytes());
      }

      final request = GardenChatRequestModel(
        message: text.isEmpty ? null : text,
        imageBase64: imageBase64,
      );

      final response = await _repository.sendMessage(request: request);
      if (response != null) {
        final model = GardenChatResponseModel.fromJson(
          Map<String, dynamic>.from(response),
        );
        if (model.success == true && model.data != null) {
          conversationId = model.data!.conversationId;
          isTyping.value = false;
          _applyResponse(model.data!);
          didGetReply = true;
        } else {
          messages.add(_somethingWentWrongMessage(animateIn: true));
        }
      } else {
        messages.add(_somethingWentWrongMessage(animateIn: true));
      }
    } catch (e) {
      messages.add(_somethingWentWrongMessage(animateIn: true));
    } finally {
      isTyping.value = false;
      _scrollToBottom(slow: didGetReply);
    }
  }

  void _applyResponse(GardenChatData data) {
    ChatMessage? assistant;
    if (data.reply != null && data.reply!.trim().isNotEmpty) {
      assistant = ChatMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        role: 'assistant',
        text: data.reply!.trim(),
        animateIn: true,
      );
    } else if (data.history != null && data.history!.isNotEmpty) {
      final lastAnswer = data.history!.last.answer;
      if (lastAnswer != null && lastAnswer.content?.trim().isNotEmpty == true) {
        assistant = ChatMessage.fromTurn(lastAnswer).copyWith(animateIn: true);
      }
    }

    assistant ??= _somethingWentWrongMessage(animateIn: true);

    final alreadyAdded = messages.any((message) => message.id == assistant!.id);
    if (!alreadyAdded) {
      messages.add(assistant);
    }
  }

  String _errorTitle() {
    return AppLocalizations.of(Get.context!)?.error ?? 'Error';
  }

  String _errorMessage(Object error) {
    if (error is BadRequestException) return error.message;
    if (error is FetchDataException) return error.message;
    if (error is UnauthorisedException) return error.message;
    if (error is NotFoundException) return error.message;
    if (error is ConflictException) return error.message;
    return AppStrings.somethingWentWrong;
  }

  void showImageSourceSheet() {
    if (isUpgradeRequired || isTyping.value) return;
    OpenImagePickerBottomSheet(
      onPickImage: (isCamera) async {
        await Future.delayed(const Duration(milliseconds: 200));
        await pickImage(isCamera: isCamera);
      },
      onThenCall: () {},
    ).show();
  }

  Future<void> pickImage({required bool isCamera}) async {
    if (isUpgradeRequired) return;
    try {
      if (isCamera) {
        final hasPermission = await PermissionManager.handleCameraPermission();
        if (!hasPermission) return;
      }

      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery,
        requestFullMetadata: true,
        imageQuality: 70,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (pickedFile != null && pickedFile.path.isNotEmpty) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      debugPrint('Chatbot pickImage error: $e');
    }
  }

  void removeSelectedImage() {
    selectedImage.value = null;
  }

  void clearChat() {
    stopSpeech();
    messages.clear();
    messageController.clear();
    hasText.value = false;
    selectedImage.value = null;
    isTyping.value = false;
    isLoadingMore.value = false;
    hasMoreHistory.value = false;
    conversationId = null;
    _currentPage = 1;
    _totalPages = 1;
    _canPaginate = false;
  }

  void _scrollToBottom({bool slow = false}) {
    void animate() {
      if (!scrollController.hasClients) return;
      final position = scrollController.position;
      // reverse: true list keeps the latest messages at offset 0.
      const target = 0.0;
      final distance = (target - position.pixels).abs();
      if (distance < 6) return;

      final minMs = slow ? 900 : 600;
      final maxMs = slow ? 1500 : 1000;
      final durationMs = (minMs + distance * 0.45).clamp(minMs, maxMs).round();

      scrollController.animateTo(
        target,
        duration: Duration(milliseconds: durationMs),
        curve: Curves.easeInOutCubic,
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: slow ? 200 : 80), animate);
    });
  }

  @override
  void onClose() {
    stopSpeech();
    scrollController.removeListener(_onScroll);
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}

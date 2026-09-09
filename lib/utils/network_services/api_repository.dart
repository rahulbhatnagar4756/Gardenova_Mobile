import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/app_config.dart';
import 'package:kasagardem/utils/constants/api_keys.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';
import 'package:kasagardem/utils/network_services/app_exceptions.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';

import '../../base/dialogs/base_dialog.dart';
import '../../services/reminder_push_notification_service.dart';

class ApiRepository {
  ApiRepository._privateConstructor();

  static final ApiRepository instance = ApiRepository._privateConstructor();

  factory ApiRepository() => instance;
  Timer? _loaderTimer;
  bool _isLoaderVisible = false;
  Future<bool>? _refreshInFlight;
  bool _isUnauthorizedDialogVisible = false;
  bool _isLoggingOut = false;
  static const String _refreshTokenUrl = 'api/v1/auth/refresh';

  Map<String, String> _buildDefaultHeaders({bool includeAuth = true}) {
    final token = SharedPrefsService.instance.getToken();
    final String accecptLanguage =
        Get.locale?.languageCode ??
        SharedPrefsService.instance.getString(AppKeys.selectedLang) ??
        'en';
    debugPrint("Header-Token::::$token, accecptLanguage $accecptLanguage");
    return {
      'Content-Type': 'application/json',
      'Accept-Language': accecptLanguage,
      'accept-language': accecptLanguage,
      if (includeAuth && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static final String baseUrl = AppConfig.shared.baseUrl;
  // static final String baseUrl = "http://69.62.81.167:8080/";
  ApiRepository? apiRepository;

  Future<dynamic> request(
    String method,
    String endPoint, {
    dynamic body,
    Map<String, String>? headers,
    RxBool? isLoaderVisible,
    Map<String, String>? fields,
    Map<String, String>? base64Images,
    bool showDefaultLoader = true,
    bool directUrl = false,
    bool showRunTimeError = true,
    bool rethrowExceptions = false,
    bool returnFailureResponse = false,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult[0] == ConnectivityResult.none) {
      BaseSnackBar.show(
        title: AppLocalizations.of(Get.context!)!.error,
        message: AppLocalizations.of(Get.context!)!.noInternetConnection,
      );
      return null;
    }

    final uri = directUrl ? Uri.parse(endPoint) : Uri.parse(baseUrl + endPoint);

    debugPrint("API Request: $uri");
    debugPrint("API Request: $body");

    final defaultHeaders = _buildDefaultHeaders(
      includeAuth: !_isRefreshTokenEndpoint(endPoint),
    );

    if (headers != null) {
      defaultHeaders.addAll(headers);
    }

    log('---------------------------------');
    log('Api data-> method: ${method.toUpperCase()}');
    log('Api data-> uri: $uri');
    log('Api data-> body: $body');
    log('Api data-> fields: $fields');
    log('Api data-> headers: $defaultHeaders');
    log('Api data-> hasAuthorization: ${defaultHeaders.containsKey('Authorization')}');
    log('---------------------------------');
    http.Response response;
    try {
      if (showDefaultLoader) {
        showLoader();
      }
      response = await _dispatchHttp(
        method: method,
        uri: uri,
        headers: defaultHeaders,
        body: body,
        fields: fields,
        base64Images: base64Images,
      );
      log("API Response::: ${response.body}");

      if (response.statusCode == 401 &&
          !_isLoggingOut &&
          !_isRefreshTokenEndpoint(endPoint) &&
          _storedRefreshToken().isNotEmpty) {
        final refreshed = await _refreshSession();
        if (refreshed) {
          defaultHeaders
            ..clear()
            ..addAll(_buildDefaultHeaders());
          if (headers != null) {
            defaultHeaders.addAll(headers);
          }
          response = await _dispatchHttp(
            method: method,
            uri: uri,
            headers: defaultHeaders,
            body: body,
            fields: fields,
            base64Images: base64Images,
          );
          log("API Response::: ${response.body}");
        } else {
          return null;
        }
      }

      final responseData = _returnResponse(response);
      log("API Response::: ${jsonEncode(responseData)}");
      if (responseData == null) {
        return null;
      }
      if (directUrl || responseData[ApiKeys.success] == true) {
        log('---------------------------------response');
        return responseData;
      } else if (returnFailureResponse) {
        return responseData;
      } else {
        log('---------------------------------responseElse');
        log('Api response->  ${responseData[ApiKeys.message]} ');
        log('---------------------------------responseElse');
        BaseSnackBar.show(
          title: AppStrings.exception,
          message: responseData[ApiKeys.message] ?? AppStrings.somethingWentWrong,
        );
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("API Request Error: $e");
        log('---------------------------------catch');
        log('Api response->  $e');
        log('---------------------------------catch');
      }
      if (rethrowExceptions) {
        rethrow;
      }
      if (showRunTimeError) {
        print("Value of e is $e");
        String message = AppStrings.somethingWentWrong;
        if (e is FetchDataException) {
          message = e.message;
        } else if (e is BadRequestException) {
          message = e.message;
        } else if (e is UnauthorisedException) {
          message = e.message;
        } else if (e is NotFoundException) {
          message = e.message;
        } else if (e is ConflictException) {
          message = e.message;
        }
        print("Value of message is $message");
        BaseSnackBar.show(title: AppStrings.exception, message: message);
      }
      //  return null;
    } finally {
      log('---------------------------------finally');

      if (showDefaultLoader) {
        hideLoader();
      }
    }
  }

  Future<dynamic> get(
    String endPoint, {
    Map<String, String>? headers,
    bool showDefaultLoader = true,
    bool directUrl = false,
    bool showRunTimeError = true,
    bool rethrowExceptions = false,
  }) async => request(
    ApiKeys.get,
    endPoint,
    headers: headers,
    showDefaultLoader: showDefaultLoader,
    directUrl: directUrl,
    showRunTimeError: showRunTimeError,
    rethrowExceptions: rethrowExceptions,
  );

  Future<dynamic> post(
    String endPoint, {
    dynamic body,
    Map<String, String>? headers,
    bool showDefaultLoader = true,
    bool directUrl = false,
    bool showRunTimeError = true,
    bool rethrowExceptions = false,
    bool returnFailureResponse = false,
  }) async => request(
    ApiKeys.post,
    endPoint,
    body: body,
    headers: headers,
    showDefaultLoader: showDefaultLoader,
    directUrl: directUrl,
    showRunTimeError: showRunTimeError,
    rethrowExceptions: rethrowExceptions,
    returnFailureResponse: returnFailureResponse,
  );

  Future<dynamic> patch(
    String endPoint,
    dynamic body, {
    Map<String, String>? headers,
    bool returnFailureResponse = false,
    bool showDefaultLoader = true,
  }) async => request(
    ApiKeys.patch,
    endPoint,
    body: body,
    headers: headers,
    returnFailureResponse: returnFailureResponse,
    showDefaultLoader: showDefaultLoader,
  );

  Future<dynamic> put(
    String endPoint, {
    dynamic body,
    Map<String, String>? headers,
    bool showDefaultLoader = true,
  }) async => request(
    ApiKeys.put,
    endPoint,
    body: body,
    headers: headers,
    showDefaultLoader: showDefaultLoader,
  );

  Future<dynamic> delete(String endPoint, {Map<String, String>? headers}) async =>
      request(ApiKeys.delete, endPoint, headers: headers);

  bool _isRefreshTokenEndpoint(String endPoint) {
    return endPoint.contains(_refreshTokenUrl);
  }

  String _storedRefreshToken() {
    return SharedPrefsService.instance.getString(ApiKeys.refreshToken) ?? '';
  }

  Future<http.Response> _dispatchHttp({
    required String method,
    required Uri uri,
    required Map<String, String> headers,
    dynamic body,
    Map<String, String>? fields,
    Map<String, String>? base64Images,
  }) async {
    switch (method.toUpperCase()) {
      case ApiKeys.get:
        return http.get(uri, headers: headers);
      case ApiKeys.post:
        debugPrint("body::::${jsonEncode(body)}");
        return http.post(
          uri,
          body: body == null ? body : jsonEncode(body),
          headers: headers,
        );
      case ApiKeys.put:
        return http.put(uri, body: jsonEncode(body), headers: headers);
      case ApiKeys.delete:
        return http.delete(uri, headers: headers);
      case ApiKeys.patch:
        return http.patch(uri, body: jsonEncode(body), headers: headers);
      case ApiKeys.multipartPut:
        final request = http.MultipartRequest(ApiKeys.put, uri);
        request.headers.addAll(headers);
        request.fields.addAll(fields!);

        if (base64Images != null) {
          base64Images.forEach((key, value) {
            fields[key] = value;
          });
        }

        final streamedResponse = await request.send();
        await http.Response.fromStream(streamedResponse);
        return http.put(uri, body: jsonEncode(body), headers: headers);
      default:
        throw ArgumentError('${AppStrings.invalidHttpMethod}: $method');
    }
  }

  Future<bool> _refreshSession() async {
    final refreshToken = _storedRefreshToken();
    if (refreshToken.isEmpty) return false;

    final inFlight = _refreshInFlight;
    if (inFlight != null) return inFlight;

    final future = _performTokenRefresh(refreshToken);
    _refreshInFlight = future;
    try {
      return await future;
    } finally {
      if (identical(_refreshInFlight, future)) {
        _refreshInFlight = null;
      }
    }
  }

  Future<bool> _performTokenRefresh(String refreshToken) async {
    try {
      final refreshResponse = await http.post(
        Uri.parse(baseUrl + _refreshTokenUrl),
        headers: _buildDefaultHeaders(includeAuth: false),
        body: jsonEncode({ApiKeys.refreshToken: refreshToken}),
      );
      log('Refresh token status::: ${refreshResponse.statusCode}');
      log('Refresh token body::: ${refreshResponse.body}');

      if (_isInvalidRefreshTokenResponse(refreshResponse)) {
        await _logoutDueToInvalidRefreshToken();
        return false;
      }

      if (refreshResponse.statusCode != 200 && refreshResponse.statusCode != 201) {
        return false;
      }

      final result = jsonDecode(refreshResponse.body);
      if (result is! Map || result[ApiKeys.success] != true) {
        if (_isInvalidRefreshTokenMessage(result)) {
          await _logoutDueToInvalidRefreshToken();
        }
        return false;
      }
      final data = result[ApiKeys.data];
      if (data == null) return false;

      final token = data[ApiKeys.token]?.toString() ?? '';
      final newRefreshToken = data[ApiKeys.refreshToken]?.toString() ?? '';
      if (token.isEmpty) return false;

      await SharedPrefsService.instance.setString(AppKeys.idToken, token);
      if (newRefreshToken.isNotEmpty) {
        await SharedPrefsService.instance.setString(ApiKeys.refreshToken, newRefreshToken);
      }
      return true;
    } catch (e) {
      log('Refresh token failed: $e');
      return false;
    }
  }

  bool _isInvalidRefreshTokenResponse(http.Response response) {
    if (response.statusCode == 401) return true;
    try {
      return _isInvalidRefreshTokenMessage(jsonDecode(response.body));
    } catch (_) {
      return false;
    }
  }

  bool _isInvalidRefreshTokenMessage(dynamic result) {
    if (result is! Map) return false;
    if (result[ApiKeys.success] == true) return false;
    final message = (result[ApiKeys.message] ?? '').toString().toLowerCase();
    return message.contains('invalid or expired refresh token') ||
        message.contains('expired refresh token');
  }

  Future<void> _logoutDueToInvalidRefreshToken() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;
    log('Invalid or expired refresh token — logging out');
    try {
      await ReminderPushNotificationService.instance.onUserLogout();
      SharedPrefsService.instance.setBool(AppKeys.isLoggedIn, false);
      SharedPrefsService.instance.clear();
      SharedPrefsService.instance.setString(AppKeys.role, AppKeys.user);
      if (Get.currentRoute != Routes.login) {
        Get.offAllNamed(Routes.login);
      }
    } catch (e) {
      log('Forced logout failed: $e');
      if (Get.currentRoute != Routes.login) {
        Get.offAllNamed(Routes.login);
      }
    } finally {
      _isLoggingOut = false;
      _isUnauthorizedDialogVisible = false;
    }
  }

  void _showUnauthorizedLogout() {
    if (_isLoggingOut) return;
    if (_isUnauthorizedDialogVisible) return;
    _isUnauthorizedDialogVisible = true;
    Future.delayed(Duration.zero, () {
      final context = Get.context;
      if (context == null) {
        _isUnauthorizedDialogVisible = false;
        return;
      }
      BaseDialog.showUnauthorizedDialog(
        context: context,
        message: 'Your session has expired. Please login again to continue.',
        onLoginPressed: () async {
          _isUnauthorizedDialogVisible = false;
          Get.back();
          showLoader();
          await Future<void>.delayed(Duration.zero);
          try {
            await ReminderPushNotificationService.instance.onUserLogout();
            SharedPrefsService.instance.clear();
          } finally {
            hideLoader();
          }
          Get.offAllNamed(Routes.login);
        },
      );
    });
  }

  dynamic _returnResponse(http.Response response) {
    debugPrint("response.statusCode:::${response.statusCode}");

    String? message;
    try {
      final body = jsonDecode(response.body);
      debugPrint("response:::$body");
      message = body['message']?.toString();
    } catch (_) {}

    switch (response.statusCode) {
      case 200:
      case 201:
        final responseJson = jsonDecode(response.body);
        if (responseJson is Map) {
          responseJson['statusCode'] = response.statusCode;
        }
        return responseJson;
      case 400:
        throw BadRequestException(message ?? response.body.toString());

      case 401:
        if (_isLoggingOut) return null;
        _showUnauthorizedLogout();
        return null;
      case 403:
        throw UnauthorisedException(message ?? response.body.toString());
      case 404:
        throw NotFoundException(message ?? response.body.toString());
      case 409:
        throw ConflictException(message ?? response.body.toString());
      case 500:
      default:
        throw FetchDataException(message ?? '${AppStrings.serverException} ${response.statusCode}');
    }
  }

  void showLoader() {
    Future.delayed(Duration.zero, () {
      if (_isLoaderVisible) return;

      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }

      // Reset any previous auto-close timer before showing a new loader.
      _loaderTimer?.cancel();
      _loaderTimer = null;

      final context = Get.context;
      if (context == null) return;

      _isLoaderVisible = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: true,
        builder: (BuildContext context) {
          return const Center(child: SpinKitSpinningLines(color: AppColors.greenColor));
        },
      ).whenComplete(() {
        _isLoaderVisible = false;
        _loaderTimer?.cancel();
        _loaderTimer = null;
      });

      // Auto-close spinner after 20 seconds if the API never finishes.
      _loaderTimer = Timer(const Duration(seconds: 20), () {
        hideLoader();
      });
    });
  }

  void hideLoader() {
    _loaderTimer?.cancel();
    _loaderTimer = null;
    if (!_isLoaderVisible) return;

    final context = Get.context;
    if (context == null) {
      _isLoaderVisible = false;
      return;
    }

    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
    }
    _isLoaderVisible = false;
  }
}

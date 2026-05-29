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
import 'package:kasagardem/utils/constants/api_keys.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';
import 'package:kasagardem/utils/network_services/app_exceptions.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';

import '../../base/dialogs/base_dialog.dart';

class ApiRepository {
  ApiRepository._privateConstructor();

  static final ApiRepository instance = ApiRepository._privateConstructor();

  factory ApiRepository() => instance;
  Timer? _loaderTimer;

  Map<String, String> _buildDefaultHeaders() {
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
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // static final String baseUrl = AppConfig.shared.baseUrl;
  static final String baseUrl = "http://69.62.81.167:8080/";
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

    log('---------------------------------');
    log('Api data-> uri: $uri ');
    log('Api data-> body: $uri ');
    log('Api data-> fields: $fields ');
    log('Api data-> headers: $headers ');
    log('---------------------------------');

    final defaultHeaders = _buildDefaultHeaders();

    if (headers != null) {
      defaultHeaders.addAll(headers);
    }
    http.Response response;
    try {
      if (showDefaultLoader) {
        showLoader();
      }
      switch (method.toUpperCase()) {
        case ApiKeys.get:
          response = await http.get(uri, headers: defaultHeaders);
          break;
        case ApiKeys.post:
          debugPrint("body::::${jsonEncode(body)}");
          response = await http.post(
            uri,
            body: body == null ? body : jsonEncode(body),
            headers: defaultHeaders,
          );
          break;
        case ApiKeys.put:
          response = await http.put(
            uri,
            body: jsonEncode(body),
            headers: defaultHeaders,
          );
          break;
        case ApiKeys.delete:
          response = await http.delete(uri, headers: defaultHeaders);
          break;
        case ApiKeys.patch:
          response = await http.patch(
            uri,
            body: jsonEncode(body),
            headers: defaultHeaders,
          );

        case ApiKeys.multipartPut:
          final request = http.MultipartRequest(ApiKeys.put, uri);
          request.headers.addAll(defaultHeaders);
          request.fields.addAll(fields!);

          if (base64Images != null) {
            base64Images.forEach((key, value) {
              fields[key] = value;
            });
          }

          final streamedResponse = await request.send();
          response = await http.Response.fromStream(streamedResponse);
          response = await http.put(
            uri,
            body: jsonEncode(body),
            headers: defaultHeaders,
          );
          break;
        default:
          throw ArgumentError('${AppStrings.invalidHttpMethod}: $method');
      }

      final responseData = _returnResponse(response);
      // log("API Response::: ${jsonEncode(responseData)}");
      // if (showDefaultLoader) {
      //   hideLoader();
      // }
      if (directUrl || responseData[ApiKeys.success] == true) {
        log('---------------------------------response');
        log('Api response->  $responseData');
        log('---------------------------------response');
        return responseData;
      } else {
        log('---------------------------------responseElse');
        log('Api response->  ${responseData[ApiKeys.message]} ');
        log('---------------------------------responseElse');
        BaseSnackBar.show(
          title: AppStrings.exception,
          message:
              responseData[ApiKeys.message] ?? AppStrings.somethingWentWrong,
        );
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("API Request Error: $e");
        log('---------------------------------catch');
        log('Api response->  $e');
        log('---------------------------------catch');
      }
      if (rethrowExceptions) {
        rethrow;
      }
      if (showRunTimeError) {
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
        BaseSnackBar.show(title: AppStrings.exception, message: message);
      }
      return null;
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
  }) async => request(
    ApiKeys.post,
    endPoint,
    body: body,
    headers: headers,
    showDefaultLoader: showDefaultLoader,
    directUrl: directUrl,
    showRunTimeError: showRunTimeError,
    rethrowExceptions: rethrowExceptions,
  );

  Future<dynamic> patch(
    String endPoint,
    dynamic body, {
    Map<String, String>? headers,
  }) async => request(ApiKeys.patch, endPoint, body: body, headers: headers);

  Future<dynamic> put(
    String endPoint, {
    dynamic body,
    Map<String, String>? headers,
  }) async => request(ApiKeys.put, endPoint, body: body, headers: headers);

  Future<dynamic> delete(
    String endPoint, {
    Map<String, String>? headers,
  }) async => request(ApiKeys.delete, endPoint, headers: headers);

  dynamic _returnResponse(http.Response response) {
    debugPrint("response.statusCode:::${response.statusCode}");

    String? message;
    try {
      final body = jsonDecode(response.body);
      message = body['message'];
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
        Future.delayed(Duration.zero, () {
          BaseDialog.showUnauthorizedDialog(
            context: Get.context!,
            message:
                'Your session has expired. Please login again to continue.',
            onLoginPressed: () {
              SharedPrefsService.instance.clear();
              Get.back();
              // then navigate
              Get.offAllNamed(Routes.login);
            },
          );
        });
        return null;
      case 403:
        throw UnauthorisedException(message ?? response.body.toString());
      case 404:
        throw NotFoundException(message ?? response.body.toString());
      case 409:
        throw ConflictException(message ?? response.body.toString());
      case 500:
      default:
        throw FetchDataException(
          message ?? '${AppStrings.serverException} ${response.statusCode}',
        );
    }
  }

  void showLoader() {
    Future.delayed(Duration.zero, () {
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }

      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: SpinKitSpinningLines(color: AppColors.greenColor),
          );
        },
      );

      _loaderTimer = Timer(const Duration(seconds: 20), () {
        if (_loaderTimer != null) {
          _loaderTimer!.cancel();
        }
      });
    });
  }

  void hideLoader() {
    _loaderTimer?.cancel();
    _loaderTimer = null;
    if (Navigator.of(Get.context!).canPop()) {
      Navigator.of(Get.context!).pop();
    }
  }
}

import 'dart:async';
import 'dart:convert';
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
import '../app_config.dart';

class ApiRepository {
  ApiRepository._privateConstructor();
  static final ApiRepository instance = ApiRepository._privateConstructor();
  factory ApiRepository() => instance;
  Timer? _loaderTimer;

  Map<String, String> _buildDefaultHeaders() {
    final token = SharedPrefsService.instance.getToken();
    debugPrint("Header-Token::::$token");
    return {
      'Content-Type': 'application/json',
      'Accept-Language':
          Get.locale?.languageCode ??
          SharedPrefsService.instance.getString(AppKeys.selectedLang) ??
          'pt',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static final String baseUrl = AppConfig.shared.baseUrl;
  //static final String baseUrl = "http://69.62.81.167:8080/";
  ApiRepository? apiRepository;

  Future<dynamic> request(
    String method,
    String endPoint, {
    dynamic body,
    Map<String, String>? headers,
    RxBool? isLoaderVisible,
    Map<String, String>? fields,
    Map<String, String>? base64Images,
  }) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult[0] == ConnectivityResult.none) {
      BaseSnackBar.show(
        title: AppLocalizations.of(Get.context!)!.error,
        message: AppLocalizations.of(Get.context!)!.noInternetConnection,
      );
      return null;
    }

    final uri = Uri.parse(baseUrl + endPoint);

    debugPrint("API Request: $uri");

    final defaultHeaders = _buildDefaultHeaders();

    if (headers != null) {
      defaultHeaders.addAll(headers);
    }
    http.Response response;
    try {
      showLoader();
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
      hideLoader();
      if (responseData[ApiKeys.success] == true) {
        return responseData;
      } else {
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
        hideLoader();
      }
      BaseSnackBar.show(
        title: AppStrings.exception,
        message: AppStrings.somethingWentWrong,
      );
      return null;
    }
  }

  Future<dynamic> get(String endPoint, {Map<String, String>? headers}) async =>
      request(ApiKeys.get, endPoint, headers: headers);

  Future<dynamic> post(
    String endPoint, {
    dynamic body,
    Map<String, String>? headers,
  }) async => request(ApiKeys.post, endPoint, body: body, headers: headers);

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

    switch (response.statusCode) {
      case 200:
      case 201:
        final responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());

      case 401:
        SharedPrefsService.instance.clear();
        Get.offAllNamed(Routes.login);
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 404:
        throw NotFoundException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
          '${AppStrings.serverException} ${response.statusCode}',
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
            child: SpinKitSpinningLines(color: AppColors.burntGold),
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

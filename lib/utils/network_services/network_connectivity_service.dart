import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkConnectivityService extends GetxService
    with WidgetsBindingObserver {
  final RxBool _isConnected = false.obs;

  bool get isConnected => _isConnected.value;
  bool _wasDisconnected = false;

  Stream<bool> get connectionStream => _isConnected.stream;

  StreamSubscription<InternetStatus>? _subscription;
  final InternetConnection _connectionChecker;
  bool _isAppInForeground = true;

  NetworkConnectivityService({InternetConnection? connectionChecker})
    : _connectionChecker =
          connectionChecker ??
          InternetConnection.createInstance(
            checkInterval: const Duration(seconds: 5),
          );

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _initializeConnectivityListener();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _isAppInForeground = state == AppLifecycleState.resumed;

    if (_isAppInForeground) {
      _ensureListenerActive();
    } else {}
  }

  void _initializeConnectivityListener() {
    _connectionChecker.hasInternetAccess.then((bool hasConnection) {
      _isConnected.value = hasConnection;
    });

    _subscription = _connectionChecker.onStatusChange.listen(
      (InternetStatus status) {
        final bool currentlyConnected = status == InternetStatus.connected;

        if (currentlyConnected) {
          if (_wasDisconnected) {
            /*   Get.rawSnackbar(
              message: "Internet Connected",
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            );*/
            _wasDisconnected = false;
          }
        } else {
          if (!_wasDisconnected) {
            /* Get.rawSnackbar(
              message: "Internet Disconnected",
              backgroundColor: Colors.red,
              isDismissible: false,
            );*/
            _wasDisconnected = true;
          }
        }
        _isConnected.value = currentlyConnected;
      },
      onError: (e) {
        _isConnected.value = false;
      },
    );
  }

  void _ensureListenerActive() {
    if (_subscription == null || _subscription!.isPaused) {
      _subscription?.cancel();
      _initializeConnectivityListener();
    }
  }

  Future<bool> checkConnection() async {
    bool hasConnection = await _connectionChecker.hasInternetAccess;
    _isConnected.value = hasConnection;
    return hasConnection;
  }
}

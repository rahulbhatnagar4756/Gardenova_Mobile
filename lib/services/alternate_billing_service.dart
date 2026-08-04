import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';

/// Bridges to [GardenovaAlternateBillingPlugin] on Android for Google Play
/// alternate billing compliance when using Razorpay subscriptions.
class AlternateBillingService {
  AlternateBillingService._();

  static const MethodChannel _channel = MethodChannel(
    'com.gardenova.digisoft/alternate_billing',
  );

  static bool _isPrepared = false;

  static Future<bool> prepareIfAvailable() async {
    if (!Platform.isAndroid || _isPrepared) return true;

    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'prepareAlternateBilling',
      );
      final prepared = result?['prepared'] == true;
      final unavailable = result?['available'] == false;
      _isPrepared = prepared || unavailable;
      return prepared || unavailable;
    } catch (e) {
      log('Alternate billing prepare failed: $e');
      return true;
    }
  }

  static Future<String?> getExternalTransactionToken() async {
    if (!Platform.isAndroid) return null;

    try {
      final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'getExternalTransactionToken',
      );
      final token = result?['token']?.toString();
      if (token != null && token.isNotEmpty) return token;
    } catch (e) {
      log('Alternate billing token fetch failed: $e');
    }
    return null;
  }
}

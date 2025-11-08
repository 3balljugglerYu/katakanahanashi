import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:katakanahanashi/config/app_config.dart';
import 'package:katakanahanashi/data/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubscriptionVerificationResult {
  final bool isValid;
  final bool isActive;
  final DateTime? expiryDate;
  final String? message;
  final Map<String, dynamic>? raw;

  const SubscriptionVerificationResult({
    required this.isValid,
    required this.isActive,
    this.expiryDate,
    this.message,
    this.raw,
  });

  static const SubscriptionVerificationResult valid =
      SubscriptionVerificationResult(isValid: true, isActive: true);
}

class SubscriptionVerificationService {
  SubscriptionVerificationService({SupabaseClient? client})
      : _client = client ?? SupabaseService.instance.client;

  final SupabaseClient _client;

  Future<SubscriptionVerificationResult> verifyPurchase(
    PurchaseDetails purchaseDetails,
  ) async {
    // モック課金中は検証不要
    if (AppConfig.isMockBillingEnabled && Platform.isAndroid) {
      return SubscriptionVerificationResult.valid;
    }

    final payload = <String, dynamic>{
      'platform': Platform.isIOS ? 'ios' : 'android',
      'productId': purchaseDetails.productID,
      'verificationData':
          purchaseDetails.verificationData.serverVerificationData,
      'transactionId': purchaseDetails.purchaseID,
      'transactionDate': purchaseDetails.transactionDate,
      'packageName': Platform.isAndroid ? AppConfig.androidPackageName : null,
    }..removeWhere((_, value) => value == null);

    final response = await _client.functions.invoke(
      'verify-subscription',
      body: payload,
    );

    final Map<String, dynamic> data =
        (response.data as Map<String, dynamic>?) ?? {};

    final bool isValid = data['isValid'] == true;
    final bool isActive = data.containsKey('isActive')
        ? data['isActive'] == true
        : isValid;

    final DateTime? expiryDate = _parseExpiry(data['expiryTimeMillis']);
    final String? message =
        data['message'] is String ? data['message'] as String : null;

    return SubscriptionVerificationResult(
      isValid: isValid,
      isActive: isActive,
      expiryDate: expiryDate,
      message: message,
      raw: data,
    );
  }

  DateTime? _parseExpiry(dynamic value) {
    if (value == null) {
      return null;
    }

    int? millis;
    if (value is num) {
      millis = value.toInt();
    } else if (value is String) {
      millis = int.tryParse(value);
    }

    if (millis == null) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(millis);
  }
}

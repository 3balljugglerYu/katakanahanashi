import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionService {
  static const String monthlyProductId =
      'com.kotoba.kakurenbo.playease.monthly';
  static const String _subscriptionKey = 'subscription_status';

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  Stream<List<PurchaseDetails>> get purchaseStream =>
      _inAppPurchase.purchaseStream;

  Future<void> initialize() async {
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      throw Exception('In-app purchase is not available');
    }
  }

  Future<List<ProductDetails>> getProducts() async {
    const Set<String> productIds = {monthlyProductId};
    print('[💰DEBUG] Querying product ID: $monthlyProductId');
    final ProductDetailsResponse response = await _inAppPurchase
        .queryProductDetails(productIds);

    if (response.error != null) {
      throw Exception('Failed to load products: ${response.error!.message}');
    }

    if (response.productDetails.isEmpty) {
      throw Exception('No products found');
    }

    for (final product in response.productDetails) {
      print(
        '[💰DEBUG] Product loaded: id=${product.id}, title=${product.title}, price=${product.price}',
      );
    }

    return response.productDetails;
  }

  Future<bool> purchaseSubscription(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);

    try {
      final bool success = await _inAppPurchase.buyNonConsumable(
        purchaseParam: purchaseParam,
      );
      return success;
    } on PlatformException catch (e) {
      if (e.code == 'purchase_cancelled') {
        return false;
      }
      throw Exception('Purchase failed: ${e.message}');
    } catch (e) {
      throw Exception('Purchase failed: $e');
    }
  }

  Future<void> restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      throw Exception('Restore failed: $e');
    }
  }

  Future<bool> isSubscribed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_subscriptionKey) ?? false;
  }

  Future<void> setSubscriptionStatus(bool isSubscribed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_subscriptionKey, isSubscribed);
  }

  Future<bool> handlePurchaseUpdate(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.status == PurchaseStatus.purchased) {
      // サブスクリプション購入完了
      await setSubscriptionStatus(true);

      // iOS では購入完了を通知する必要がある
      if (Platform.isIOS) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }

      return true;
    } else if (purchaseDetails.status == PurchaseStatus.error) {
      if (purchaseDetails.error?.code == 'purchase_cancelled') {
        return false;
      }
      // 購入エラー
      throw Exception('Purchase error: ${purchaseDetails.error?.message}');
    } else if (purchaseDetails.status == PurchaseStatus.canceled) {
      // 購入キャンセル
      return false;
    } else if (purchaseDetails.status == PurchaseStatus.restored) {
      // 購入復元
      await setSubscriptionStatus(true);
      return true;
    }

    return false;
  }

  void listenToPurchaseUpdated(
    Function(List<PurchaseDetails>) onPurchaseUpdate,
  ) {
    _subscription = _inAppPurchase.purchaseStream.listen(onPurchaseUpdate);
  }

  void dispose() {
    _subscription.cancel();
  }
}

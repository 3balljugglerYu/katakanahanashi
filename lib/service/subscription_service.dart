import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:katakanahanashi/config/app_config.dart';
import 'package:katakanahanashi/data/services/subscription_verification_service.dart';
import 'package:katakanahanashi/service/billing_client_service.dart';

class SubscriptionService {
  StreamController<List<PurchaseDetails>>? _mockPurchaseController;
  static const String _mockProductTitle = 'Premium (Mock)';
  static const String _mockProductDescription = '広告なし体験（開発用モック）';
  static const double _mockProductPrice = 200;

  static const String _subscriptionKey = 'subscription_status';

  SubscriptionService({
    BillingClientService? billingClientService,
    SubscriptionVerificationService? verificationService,
  })  : _billingClientService =
            billingClientService ?? BillingClientService(),
        _verificationService =
            verificationService ?? SubscriptionVerificationService();

  final BillingClientService _billingClientService;
  final SubscriptionVerificationService _verificationService;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  Stream<List<PurchaseDetails>> get purchaseStream {
    if (_useMockBilling) {
      _mockPurchaseController ??=
          StreamController<List<PurchaseDetails>>.broadcast();
      return _mockPurchaseController!.stream;
    }
    return _billingClientService.purchaseStream;
  }

  static String get _monthlyProductId {
    if (Platform.isIOS) {
      return AppConfig.iosSubscriptionProductId;
    }
    return AppConfig.androidSubscriptionProductId;
  }

  static bool get _useMockBilling {
    return Platform.isAndroid && AppConfig.isMockBillingEnabled;
  }

  Future<void> initialize() async {
    if (_useMockBilling) {
      return;
    }
    final bool available = await _billingClientService.isAvailable();
    if (!available) {
      throw Exception('In-app purchase is not available');
    }
  }

  Future<List<ProductDetails>> getProducts() async {
    if (_useMockBilling) {
      return [_buildMockProductDetails()];
    }
    final Set<String> productIds = {_monthlyProductId};
    print('[💰DEBUG] Querying product ID: $_monthlyProductId');
    final ProductDetailsResponse response =
        await _billingClientService.queryProductDetails(productIds);

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
    if (_useMockBilling) {
      await setSubscriptionStatus(true);
      _emitMockPurchaseSuccess();
      return true;
    }
    try {
      return await _billingClientService.purchase(product);
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
    if (_useMockBilling) {
      await setSubscriptionStatus(true);
      _emitMockPurchaseSuccess();
      return;
    }
    try {
      await _billingClientService.restorePurchases();
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
    if (_useMockBilling) {
      await setSubscriptionStatus(true);
      return true;
    }
    if (purchaseDetails.status == PurchaseStatus.purchased) {
      await _verifyAndPersist(purchaseDetails);

      // iOS では購入完了を通知する必要がある
      if (Platform.isIOS) {
        await _billingClientService.completePurchase(purchaseDetails);
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
      await _verifyAndPersist(purchaseDetails);
      return true;
    }

    return false;
  }

  void listenToPurchaseUpdated(
    Function(List<PurchaseDetails>) onPurchaseUpdate,
  ) {
    if (_useMockBilling) {
      _mockPurchaseController ??=
          StreamController<List<PurchaseDetails>>.broadcast();
      _subscription = _mockPurchaseController!.stream.listen(onPurchaseUpdate);
      return;
    }
    _subscription = _billingClientService.purchaseStream.listen(onPurchaseUpdate);
  }

  void dispose() {
    _subscription?.cancel();
    _mockPurchaseController?.close();
  }

  ProductDetails _buildMockProductDetails() {
    return ProductDetails(
      id: _monthlyProductId,
      title: _mockProductTitle,
      description: _mockProductDescription,
      price: '¥${_mockProductPrice.toStringAsFixed(0)}',
      rawPrice: _mockProductPrice,
      currencyCode: 'JPY',
      currencySymbol: '¥',
    );
  }

  void _emitMockPurchaseSuccess() {
    if (!_useMockBilling) {
      return;
    }
    final controller = _mockPurchaseController ??
        (_mockPurchaseController =
            StreamController<List<PurchaseDetails>>.broadcast());
    final purchaseDetails = PurchaseDetails(
      purchaseID: 'mock-${DateTime.now().millisecondsSinceEpoch}',
      productID: _monthlyProductId,
      transactionDate: DateTime.now().millisecondsSinceEpoch.toString(),
      status: PurchaseStatus.purchased,
      verificationData: PurchaseVerificationData(
        localVerificationData: 'mock-verification-data',
        serverVerificationData: 'mock-verification-data',
        source: 'mock-android',
      ),
    );
    controller.add([purchaseDetails]);
  }

  Future<void> _verifyAndPersist(PurchaseDetails purchaseDetails) async {
    final result =
        await _verificationService.verifyPurchase(purchaseDetails);

    if (!result.isValid) {
      throw Exception(result.message ?? 'Purchase verification failed');
    }

    await setSubscriptionStatus(result.isActive);
  }
}

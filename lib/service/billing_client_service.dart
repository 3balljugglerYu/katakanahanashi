import 'package:in_app_purchase/in_app_purchase.dart';

/// Thin wrapper around [InAppPurchase] to isolate billing operations.
class BillingClientService {
  BillingClientService({InAppPurchase? inAppPurchase})
      : _inAppPurchase = inAppPurchase ?? InAppPurchase.instance;

  final InAppPurchase _inAppPurchase;

  Future<bool> isAvailable() {
    return _inAppPurchase.isAvailable();
  }

  Future<ProductDetailsResponse> queryProductDetails(
    Set<String> productIds,
  ) {
    return _inAppPurchase.queryProductDetails(productIds);
  }

  Future<bool> purchase(ProductDetails product) {
    final purchaseParam = PurchaseParam(productDetails: product);
    return _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() {
    return _inAppPurchase.restorePurchases();
  }

  Stream<List<PurchaseDetails>> get purchaseStream {
    return _inAppPurchase.purchaseStream;
  }

  Future<void> completePurchase(PurchaseDetails purchaseDetails) {
    return _inAppPurchase.completePurchase(purchaseDetails);
  }
}

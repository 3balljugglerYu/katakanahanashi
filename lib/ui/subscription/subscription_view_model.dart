import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../service/subscription_service.dart';
import 'subscription_state.dart';

final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  return SubscriptionService();
});

final subscriptionViewModelProvider =
    StateNotifierProvider<SubscriptionViewModel, SubscriptionState>((ref) {
      final service = ref.read(subscriptionServiceProvider);
      return SubscriptionViewModel(service);
    });

class SubscriptionViewModel extends StateNotifier<SubscriptionState> {
  final SubscriptionService _subscriptionService;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  SubscriptionViewModel(this._subscriptionService)
    : super(const SubscriptionState()) {
    _initializeService();
  }

  Future<void> _initializeService() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _subscriptionService.initialize();

      // 購入ストリームの監視を開始
      _purchaseSubscription = _subscriptionService.listenToPurchaseUpdated(
        (purchases) {
          unawaited(_handlePurchaseUpdate(purchases));
        },
        onError: (error, stackTrace) {
          state = state.copyWith(
            isLoading: false,
            error: 'Purchase stream error: $error',
          );
        },
      );

      // 商品情報を取得
      await loadProducts();

      // サブスクリプション状態を確認
      await checkSubscriptionStatus();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Initialization failed: $e',
      );
    }
  }

  Future<void> loadProducts() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final products = await _subscriptionService.getProducts();

      state = state.copyWith(
        isLoading: false,
        products: products,
        selectedProduct: products.isNotEmpty ? products.first : null,
      );
    } catch (e) {
      final errorMessage = e.toString();
      state = state.copyWith(
        isLoading: false,
        error: _mapProductLoadError(errorMessage),
      );
    }
  }

  Future<void> purchaseSubscription() async {
    if (state.selectedProduct == null) {
      state = state.copyWith(error: 'No product selected');
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      final success = await _subscriptionService.purchaseSubscription(
        state.selectedProduct!,
      );

      if (!success) {
        state = state.copyWith(isLoading: false);
        return;
      }

      // 購入結果は _handlePurchaseUpdate で処理される（成功時）
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Purchase failed: $e',
      );
    }
  }

  Future<void> restorePurchases() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      await _subscriptionService.restorePurchases();

      // 復元結果は _handlePurchaseUpdate で処理される
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Restore failed: $e');
    }
  }

  Future<void> checkSubscriptionStatus() async {
    try {
      final isSubscribed = await _subscriptionService.isSubscribed();
      state = state.copyWith(isSubscribed: isSubscribed);
    } catch (e) {
      state = state.copyWith(error: 'Failed to check subscription status: $e');
    }
  }

  Future<void> _handlePurchaseUpdate(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (final purchaseDetails in purchaseDetailsList) {
      await _processPurchase(purchaseDetails);
    }
  }

  Future<void> _processPurchase(PurchaseDetails purchaseDetails) async {
    try {
      final success = await _subscriptionService.handlePurchaseUpdate(
        purchaseDetails,
      );

      if (!success) {
        state = state.copyWith(isLoading: false);
        return;
      }

      state = state.copyWith(
        isLoading: false,
        isSubscribed: success,
        error: null,
        purchases: [...state.purchases, purchaseDetails],
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Purchase processing failed: $e',
      );
    }
  }

  static const String _fallbackPrice = '¥200';
  static const String _billingPeriodLabel = '1か月';
  static const String _autoRenewLabel = '1か月ごとの自動更新';

  String get formattedPrice => state.selectedProduct?.price ?? _fallbackPrice;

  String get priceText => '$formattedPrice / $_billingPeriodLabel（自動更新）';

  String get marketingPriceCopy => '毎月$formattedPriceで広告を完全オフ';

  String get subscriptionPeriodLabel => _autoRenewLabel;

  String get autoRenewSummary => '更新日の24時間前までにキャンセルしない限り、自動的に更新されます。';

  String get cancellationPolicy => 'いつでも解約できます。解約しても請求期間の最後まで広告なしで利用できます。';

  bool get canPurchase {
    return !state.isLoading &&
        state.selectedProduct != null &&
        !state.isSubscribed;
  }

  bool get canRestore {
    return !state.isLoading && !state.isSubscribed;
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  String _mapProductLoadError(String rawError) {
    if (rawError.contains('No products found')) {
      return 'Play Console で SKU がまだ公開されていないため、商品情報を取得できませんでした。';
    }
    if (rawError.contains('Item unavailable')) {
      return '対象のサブスクリプションが利用できません。SKU とテスター設定を確認してください。';
    }
    return 'Failed to load products: $rawError';
  }

  @override
  void dispose() {
    _purchaseSubscription?.cancel();
    _subscriptionService.dispose();
    super.dispose();
  }
}

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../service/subscription_service.dart';
import 'subscription_state.dart';

final subscriptionServiceProvider = Provider<SubscriptionService>((ref) {
  return SubscriptionService();
});

final subscriptionViewModelProvider = StateNotifierProvider<SubscriptionViewModel, SubscriptionState>((ref) {
  final service = ref.read(subscriptionServiceProvider);
  return SubscriptionViewModel(service);
});

class SubscriptionViewModel extends StateNotifier<SubscriptionState> {
  final SubscriptionService _subscriptionService;
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  SubscriptionViewModel(this._subscriptionService) : super(const SubscriptionState()) {
    _initializeService();
  }

  Future<void> _initializeService() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      await _subscriptionService.initialize();
      
      // 購入ストリームの監視を開始
      _purchaseSubscription = _subscriptionService.purchaseStream.listen(
        _handlePurchaseUpdate,
        onError: (error) {
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
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load products: $e',
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
      
      await _subscriptionService.purchaseSubscription(state.selectedProduct!);
      
      // 購入結果は _handlePurchaseUpdate で処理される
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
      state = state.copyWith(
        isLoading: false,
        error: 'Restore failed: $e',
      );
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

  void _handlePurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchaseDetails in purchaseDetailsList) {
      _processPurchase(purchaseDetails);
    }
  }

  Future<void> _processPurchase(PurchaseDetails purchaseDetails) async {
    try {
      final success = await _subscriptionService.handlePurchaseUpdate(purchaseDetails);
      
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

  String get priceText {
    if (state.selectedProduct != null) {
      try {
        // StoreKitの価格情報を使用
        final price = state.selectedProduct!.price;
        return '月額 $price';
      } catch (e) {
        // .storekitファイルの価格情報が取得できない場合のフォールバック
        return '月額 ¥200 (error)';
      }
    }
    return '月額 ¥200 dev'; // Development環境用フォールバック
  }

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

  @override
  void dispose() {
    _purchaseSubscription?.cancel();
    _subscriptionService.dispose();
    super.dispose();
  }
}
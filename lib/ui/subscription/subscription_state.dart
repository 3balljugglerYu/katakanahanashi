import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

part 'subscription_state.freezed.dart';

@freezed
class SubscriptionState with _$SubscriptionState {
  const factory SubscriptionState({
    @Default(false) bool isLoading,
    @Default(false) bool isSubscribed,
    @Default([]) List<ProductDetails> products,
    @Default([]) List<PurchaseDetails> purchases,
    String? error,
    ProductDetails? selectedProduct,
  }) = _SubscriptionState;
}
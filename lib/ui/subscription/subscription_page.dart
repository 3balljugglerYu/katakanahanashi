import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:katakanahanashi/ui/widgets/policy_links.dart';

import 'subscription_state.dart';
import 'subscription_view_model.dart';

class SubscriptionPage extends ConsumerWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final state = ref.watch(subscriptionViewModelProvider);
    final viewModel = ref.read(subscriptionViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comfort Play メンバーシップ'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroSection(colorScheme, viewModel),
              const SizedBox(height: 24),
              _buildBenefitSection(colorScheme),
              const SizedBox(height: 24),
              _buildPriceCard(context, viewModel),
              const SizedBox(height: 24),
              if (state.error != null) ...[
                _buildErrorCard(state.error!, viewModel),
                const SizedBox(height: 16),
              ],
              if (state.isSubscribed) ...[
                _buildSubscribedCard(colorScheme),
                const SizedBox(height: 16),
              ],
              _buildActionButtons(context, state, viewModel),
              const SizedBox(height: 16),
              PolicyLinks(
                alignment: WrapAlignment.start,
                padding: const EdgeInsets.only(bottom: 12),
                textStyle: TextStyle(
                  fontSize:
                      Theme.of(context).textTheme.bodySmall?.fontSize ?? 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: colorScheme.primary,
                ),
              ),
              _buildNote(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(
    ColorScheme colorScheme,
    SubscriptionViewModel viewModel,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade400, Colors.orange.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Comfort Play',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '広告なしでゆったり遊ぼう',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewModel.marketingPriceCopy,
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  viewModel.subscriptionPeriodLabel,
                  style: TextStyle(
                    color: colorScheme.primary.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitSection(ColorScheme colorScheme) {
    final benefits = [
      (
        icon: Icons.block,
        title: '広告表示なし',
        description: 'ゲームの切り替え時に表示される広告を完全にスキップできます。',
      ),
      (
        icon: Icons.rocket_launch,
        title: 'テンポよくプレイ',
        description: '集中力を切らさず、スムーズに次のお題へ進めます。',
      ),
      (
        icon: Icons.favorite,
        title: '開発継続を応援',
        description: 'いただいたサブスク費用は新機能の開発に役立てます。',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '特典',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        ...benefits.map(
          (benefit) => Card(
            elevation: 0,
            color: colorScheme.surface,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.orange.shade100),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange.shade100,
                child: Icon(benefit.icon, color: Colors.orange.shade700),
              ),
              title: Text(
                benefit.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(benefit.description),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceCard(
    BuildContext context,
    SubscriptionViewModel viewModel,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'プラン',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            viewModel.formattedPrice,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '期間: ${viewModel.subscriptionPeriodLabel}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            viewModel.autoRenewSummary,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            viewModel.cancellationPolicy,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(
            '税込価格のため追加費用は発生しません。',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    SubscriptionState state,
    SubscriptionViewModel viewModel,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: viewModel.canPurchase
              ? () async {
                  try {
                    await viewModel.purchaseSubscription();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('購入処理を開始しました'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('購入に失敗しました: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: state.isSubscribed ? Colors.grey : Colors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: state.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  state.isSubscribed ? '購読済み' : '購読して広告をオフにする',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: viewModel.canRestore
              ? () async {
                  try {
                    await viewModel.restorePurchases();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('購入情報の復元を開始しました'),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('復元に失敗しました: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              : null,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.orange.shade800,
            side: BorderSide(color: Colors.orange.shade300, width: 1.5),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            '購入情報を復元する',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorCard(String error, SubscriptionViewModel viewModel) {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.error, color: Colors.red.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Text(error, style: TextStyle(color: Colors.red.shade700)),
            ),
            IconButton(
              onPressed: viewModel.clearError,
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscribedCard(ColorScheme colorScheme) {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'サブスクリプションが有効です\n広告なしでお楽しみください',
                style: TextStyle(color: Colors.green.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNote() {
    return const Text(
      '※ Comfort Play メンバーシップは1か月ごとの自動更新サブスクリプションです。\n'
      '※ 購入確認後、料金は iTunes アカウントに請求されます。\n'
      '※ 更新日の24時間前までにキャンセルしない限り、自動的に更新され、期間終了前の24時間以内に更新料金が請求されます。\n'
      '※ 解約は iOS 設定アプリの「サブスクリプション」からいつでも行えます。\n'
      '※ 購読期間内のキャンセルによる日割り返金は行われません。',
      style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.5),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:katakanahanashi/config/app_config.dart';

class PolicyLinks extends StatelessWidget {
  const PolicyLinks({
    super.key,
    this.alignment = WrapAlignment.center,
    this.padding = EdgeInsets.zero,
    this.textStyle,
    this.spacing = 16,
    this.useInAppWebView = false,
  });

  final WrapAlignment alignment;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;
  final double spacing;
  final bool useInAppWebView;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle =
        (textStyle ??
            Theme.of(context).textTheme.bodySmall?.copyWith(
              decoration: TextDecoration.underline,
            )) ??
        const TextStyle(fontSize: 12, decoration: TextDecoration.underline);

    return Padding(
      padding: padding,
      child: Wrap(
        alignment: alignment,
        spacing: spacing,
        runSpacing: 8,
        children: [
          _buildLinkButton(
            context,
            label: '利用規約',
            url: AppConfig.termsOfUseUrl,
            style: effectiveStyle,
          ),
          _buildLinkButton(
            context,
            label: 'プライバシーポリシー',
            url: AppConfig.privacyPolicyUrl,
            style: effectiveStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildLinkButton(
    BuildContext context, {
    required String label,
    required String url,
    required TextStyle style,
  }) {
    return TextButton(
      onPressed: () => _openUrl(context, url),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      child: Text(label, style: style),
    );
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final launched = await launchUrl(
      uri,
      mode: useInAppWebView
          ? LaunchMode.inAppWebView
          : LaunchMode.externalApplication,
    );
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('リンクを開けませんでした')));
    }
  }
}

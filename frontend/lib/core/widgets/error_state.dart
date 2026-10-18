// core/widgets/error_state.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({Key? key, required this.message, this.onRetry}) : super(key: key);

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: AppTheme.accentOrange, size: 48),
          const SizedBox(height: 12),
          Text(message, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ]
        ],
      ),
    );
  }
}

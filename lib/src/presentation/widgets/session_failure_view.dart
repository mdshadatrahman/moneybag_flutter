import 'package:flutter/material.dart';

import '../../../moneybag.dart';
import 'moneybag_footer.dart';

class SessionFailureView extends StatelessWidget {
  const SessionFailureView({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final config = MoneybagInheritedWidget.maybeOf(context, listen: false)?.theme ?? const MoneybagTheme();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 64),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: config.buttonColor,
              foregroundColor: config.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Go Back"),
          ),
          const SizedBox(height: 48),
          const MoneybagFooter()
        ],
      ),
    );
  }
}

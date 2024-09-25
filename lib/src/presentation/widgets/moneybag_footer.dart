import 'package:flutter/material.dart';

class MoneybagFooter extends StatelessWidget {
  const MoneybagFooter({super.key});

  @override
  Widget build(BuildContext context) {
    const url = "https://moneybag.com.bd/wp-content/uploads/2024/08/Moneybag-Logo-Transparent.webp";
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Powered by",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Image.network(
            url,
            height: 32,
            fit: BoxFit.fitHeight,
          ),
        ],
      ),
    );
  }
}

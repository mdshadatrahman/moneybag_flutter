import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:moneybag_flutter/src/domain/moneybag_help_mixin.dart';

import '../../../moneybag.dart';

///  show MoneyBag's terms and conditions with checkbox
class MoneyBardTermTile extends StatefulWidget {
  const MoneyBardTermTile({
    super.key,
    required this.onCheckChanged,
  });

  final ValueChanged<bool> onCheckChanged;

  @override
  State<MoneyBardTermTile> createState() => _MoneyBardTermTileState();
}

class _MoneyBardTermTileState extends State<MoneyBardTermTile> with MoneyBagUtils {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final config = MoneybagInheritedWidget.of(context, listen: false);

    final linkTextStyle = textTheme.bodyMedium!.copyWith(
      color: Colors.blue.shade700,
      decoration: TextDecoration.underline,
    );

    final termText = RichText(
      text: TextSpan(
        children: [
          const TextSpan(text: "I agree to the "),
          TextSpan(
            text: "Terms and Conditions",
            style: linkTextStyle,
            recognizer: TapGestureRecognizer()..onTap = termsCondition,
          ),
          const TextSpan(text: ", "),
          TextSpan(
            text: "Privacy Policy",
            style: linkTextStyle,
            recognizer: TapGestureRecognizer()..onTap = privacyPolicy,
          ),
          const TextSpan(text: " and "),
          TextSpan(
            text: "Refund Policy",
            style: linkTextStyle,
            recognizer: TapGestureRecognizer()..onTap = refundPolicy,
          ),
          const TextSpan(text: "."),
        ],
        style: const TextStyle(color: Colors.black),
      ),
    );

    return CheckboxListTile.adaptive(
      value: isChecked,
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      activeColor: config.theme.primaryColor,
      onChanged: (value) {
        setState(() => isChecked = value ?? false);
        widget.onCheckChanged(isChecked);
      },
      title: termText,
    );
  }
}

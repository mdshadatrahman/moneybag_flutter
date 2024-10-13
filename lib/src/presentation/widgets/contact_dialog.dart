import 'package:flutter/material.dart';
import 'package:moneybag_flutter/src/domain/moneybag_help_mixin.dart';

import '../../../moneybag.dart';

/// show Helpline card in bottom sheet with mobile and email address
///
class ContactView extends StatelessWidget with MoneyBagUtils {
  const ContactView({
    super.key,
    required this.theme,
  });
  final MoneybagTheme theme;

  static show(BuildContext context) {
    final currentConfig = MoneybagInheritedWidget.maybeOf(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return ContactView(
          theme: currentConfig?.theme ?? const MoneybagTheme(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            shape: CircleBorder(
              side: BorderSide(color: theme.primaryColor),
            ),
            color: Colors.white,
            child: const CloseButton(),
          ),
          const SizedBox(height: 16),
          _HelplineCard(
            title: "Call Us",
            subtitle: "+880 1958-109225",
            icon: Icons.call_outlined,
            onTap: callUse,
          ),
          const SizedBox(height: 12),
          _HelplineCard(
            key: const ValueKey("email_to_moneybag"),
            title: "Email Us",
            subtitle: "info@moneybag.com.bd",
            icon: Icons.email_outlined,
            onTap: emailUs,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _HelplineCard extends StatelessWidget {
  const _HelplineCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final configTheme = context.findAncestorWidgetOfExactType<ContactView>()!.theme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          onTap: onTap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: configTheme.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Material(
            clipBehavior: Clip.antiAlias,
            color: configTheme.disabledColor.withOpacity(.7),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  icon,
                  color: configTheme.primaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

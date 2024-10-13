import 'package:flutter/material.dart';

import '../../../moneybag.dart';
import '../../domain/session_info.dart';

/// callback for [AccountTypeSelectionView]
typedef OnAccountTypeChanged = void Function(MoneybagServiceInfo? paymentMethod);

/// [AccountTypeSelectionView] is a [StatefulWidget] that allows user to select payment method
/// for MoneyBag
class AccountTypeSelectionView extends StatefulWidget {
  const AccountTypeSelectionView({super.key, required this.onAccountTypeChanged});
  final OnAccountTypeChanged onAccountTypeChanged;

  @override
  State<AccountTypeSelectionView> createState() => _AccountTypeSelectionViewState();
}

class _AccountTypeSelectionViewState extends State<AccountTypeSelectionView> {
  ///
  bool isCardTab = true;

  MoneybagServiceInfo? selectedMethod;

  void onAccountTypeChanged(MoneybagServiceInfo? paymentMethod) {
    setState(() {
      selectedMethod = paymentMethod;
    });
    widget.onAccountTypeChanged(paymentMethod);
  }

  @override
  Widget build(BuildContext context) {
    final config = MoneybagInheritedWidget.of(context, listen: false);

    final unSelectedBorderColor = Colors.grey.shade400;

    Widget buildTab(bool isCardTile, bool isSelected) {
      return Expanded(
        key: ValueKey(isCardTile),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(),
            side: BorderSide(color: unSelectedBorderColor),
            fixedSize: const Size.fromHeight(48),
            backgroundColor: isSelected ? config.theme.primaryColor : const Color(0xFFF5F5F5),
            elevation: 0,
          ),
          onPressed: () {
            if (isCardTile == isCardTab) return;
            isCardTab = isCardTile;
            selectedMethod = null;
            onAccountTypeChanged(null);
            setState(() {});
          },
          child: Text(
            isCardTile ? 'Accepted Card' : 'Mobile Banking',
            style: isSelected //
                ? const TextStyle(color: Colors.white)
                : const TextStyle(color: Colors.black),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildTab(true, isCardTab),
            buildTab(false, !isCardTab),
          ],
        ),
        const SizedBox(height: 24),
        ...isCardTab
            ? config.sessionInfo.banks
                .map(
                  (e) => PaymentMethodTile(
                    key: ValueKey(e),
                    selectedMethod: selectedMethod,
                    method: e,
                    onTap: () => onAccountTypeChanged(e),
                  ),
                )
                .toList()
            : config.sessionInfo.mfs
                .map(
                  (e) => PaymentMethodTile(
                    key: ValueKey(e),
                    selectedMethod: selectedMethod,
                    method: e,
                    onTap: () => onAccountTypeChanged(e),
                  ),
                )
                .toList(),
      ],
    );
  }
}

/// create view for [PaymentMethod]
///
class PaymentMethodTile extends StatelessWidget {
  const PaymentMethodTile({
    super.key,
    required this.method,
    required this.onTap,
    required this.selectedMethod,
  });

  final MoneybagServiceInfo method;
  final VoidCallback onTap;

  final MoneybagServiceInfo? selectedMethod;

  @override
  Widget build(BuildContext context) {
    final config = MoneybagInheritedWidget.of(context, listen: false);
    final bool isSelected = selectedMethod == method;
    final side = BorderSide(
      color: isSelected ? config.theme.primaryColor : Colors.grey.shade300,
      width: 1.5,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: Image.network(
          method.logo,
          width: 48,
          fit: BoxFit.fitWidth,
          errorBuilder: (context, error, stackTrace) => const Placeholder(),
        ),
        title: Text(method.serviceName),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: config.theme.primaryColor,
              )
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          side: side,
        ),
      ),
    );
  }
}

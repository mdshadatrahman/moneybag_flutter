import 'package:flutter/material.dart';

import '../../../moneybag.dart';
import '../../domain/seassion_info.dart';

import '../../domain/service_charge_response.dart';
import 'moneybag_footer.dart';
import 'moneybag_terms_view.dart';

class MoneybagPaymentDetails extends StatefulWidget {
  const MoneybagPaymentDetails({
    super.key,
    required this.description,
    required this.orderAmount,
    required this.serviceCharge,
    required this.selectedMethod,
    required this.onConfirm,
  });

  // top details idk what is that
  final String description;

  final double orderAmount;
  final ServiceChargeResponse? serviceCharge;

  final MoneybagServiceInfo? selectedMethod;
  final VoidCallback? onConfirm;

  @override
  State<MoneybagPaymentDetails> createState() => _MoneybagPaymentDetailsState();
}

class _MoneybagPaymentDetailsState extends State<MoneybagPaymentDetails> {
  bool isTermChecked = false;

  void onTermCheckChanged(bool value) {
    setState(() {
      isTermChecked = value;
    });
  }

  bool get enableButton => widget.selectedMethod != null && isTermChecked;

  @override
  Widget build(BuildContext context) {
    final config = MoneybagInheritedWidget.of(context, listen: false);
    final textTheme = Theme.of(context).textTheme;
    final currency = config.sessionInfo.currency;

    const minTileConstraints = BoxConstraints(minHeight: 48);

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            constraints: minTileConstraints,
            color: Colors.grey.shade300,
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: Text(
                "Payment Details",
                style: textTheme.titleLarge,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 40),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(widget.description),
              ),
            ),
          ),
          const Divider(),
          _ConstrainedTile(
            label: "Order Amount: ",
            value: widget.orderAmount,
            currency: currency,
          ),
          const Divider(),
          _ConstrainedTile(
            label: "Service Charge: ",
            value: widget.serviceCharge?.chargeAmount,
            currency: currency,
          ),
          const Divider(),
          _ConstrainedTile(
            label: "Total Payable: ",
            value: widget.serviceCharge?.chargeAmount != null
                ? (widget.serviceCharge!.chargeAmount + widget.orderAmount)
                : null,
            currency: currency,
          ),
          const Divider(),
          MoneyBardTermTile(onCheckChanged: onTermCheckChanged),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
                backgroundColor: config.theme.primaryColor,
                disabledBackgroundColor: config.theme.primaryColor.withAlpha(100),
              ),
              onPressed: enableButton ? widget.onConfirm : null,
              child: Text(
                "Pay Now",
                style: textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 48),
          const MoneybagFooter(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

///  represent the tile of the payment details
class _ConstrainedTile extends StatelessWidget {
  const _ConstrainedTile({
    required this.label,
    this.value,
    required this.currency,
  });

  final String label;
  final double? value;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: label.toLowerCase().contains("total") ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (value != null) Text("$currency ${value!.toStringAsFixed(2)}") else const Text("..."),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';

/// payload to get the provider_url for payment
class ProviderPayload {
  const ProviderPayload({
    required this.merchantNo,
    required this.amount,
    required this.chargeAmount,
    required this.orderId,
    required this.description,
    required this.paymode,
    required this.pgwCharge,
    required this.fintechCharge,
  });

  final String merchantNo;
  final double amount;
  final double chargeAmount;
  final String orderId;
  final String description;
  final int paymode;
  final double pgwCharge;
  final double fintechCharge;

  Map<String, dynamic> toMap() {
    return {
      "merchant_no": merchantNo,
      "order_amount": amount,
      "charge_amount": chargeAmount,
      "order_id": orderId,
      "description": description,
      "paymode": paymode,
      "pgw_charge": pgwCharge,
      "fintech_charge": fintechCharge,
    };
  }

  String toJson() => json.encode(toMap());
}

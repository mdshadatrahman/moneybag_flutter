import 'dart:convert';

/// service charge response
class ServiceChargeResponse {
  const ServiceChargeResponse({
    required this.message,
    required this.fintechNo,
    required this.payAmount,
    required this.pgwCharge,
    required this.serviceNo,
    required this.merchantId,
    required this.merchantNo,
    required this.serviceName,
    required this.serviceType,
    required this.chargeAmount,
    required this.fintechCharge,
    required this.merchantShortName,
    this.isMfs,
  });

  final String? message;
  final int fintechNo;
  final double payAmount;
  final double pgwCharge;
  final int serviceNo;
  final String merchantId;
  final int merchantNo;
  final String serviceName;
  final String serviceType;
  final double chargeAmount;
  final double fintechCharge;
  final String merchantShortName;
  final bool? isMfs;

  factory ServiceChargeResponse.fromMap(Map<String, dynamic> map) {
    return ServiceChargeResponse(
      message: map['message'],
      fintechNo: map['fintech_no']?.toInt() ?? 0,
      payAmount: map['pay_amount']?.toDouble() ?? 0.0,
      pgwCharge: map['pgw_charge']?.toDouble() ?? 0.0,
      serviceNo: map['service_no']?.toInt() ?? 0,
      merchantId: map['merchant_id'] ?? '',
      merchantNo: map['merchant_no']?.toInt() ?? 0,
      serviceName: map['service_name'] ?? '',
      serviceType: map['service_type'] ?? '',
      chargeAmount: map['charge_amount']?.toDouble() ?? 0.0,
      fintechCharge: map['fintech_charge']?.toDouble() ?? 0.0,
      merchantShortName: map['merchant_short_name'] ?? '',
      isMfs: map['is_mfs_bleeding_by_merchant'] ?? false,
    );
  }

  factory ServiceChargeResponse.fromJson(String source) => ServiceChargeResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ServiceChargeResponse(message: $message, fintechNo: $fintechNo, payAmount: $payAmount, pgwCharge: $pgwCharge, serviceNo: $serviceNo, merchantId: $merchantId, merchantNo: $merchantNo, serviceName: $serviceName, serviceType: $serviceType, chargeAmount: $chargeAmount, fintechCharge: $fintechCharge, merchantShortName: $merchantShortName, isMfs: $isMfs)';
  }
}

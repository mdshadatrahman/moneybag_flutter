/// To get the session information
class SessionInfo {
  const SessionInfo({
    required this.currency,
    required this.orderId,
    required this.returnUrl,
    required this.description,
    required this.merchantId,
    required this.merchantNo,
    required this.orderAmount,
    required this.merchantLogo,
    required this.sessionStartTime,
    required this.sessionEndTime,
    required this.banks,
    required this.mfs,
  });
  
  final String currency;
  final String orderId;
  final String returnUrl;
  final String description;
  final String merchantId;
  final String merchantNo;
  final double orderAmount;
  final String merchantLogo;
  final DateTime sessionStartTime;
  final DateTime sessionEndTime;
  final List<MoneybagServiceInfo> banks;
  final List<MoneybagServiceInfo> mfs;

  factory SessionInfo.fromMap(Map<String, dynamic> map) {
    return SessionInfo(
      currency: map['currency'],
      orderId: map['order_id'],
      returnUrl: map['return_url'],
      description: map['description'],
      merchantId: map['merchant_id'],
      merchantNo: map['merchant_no'],
      orderAmount: map['order_amount'],
      merchantLogo: map['merchant_logo'],
      sessionStartTime: DateTime.parse(map['session_start_time']),
      sessionEndTime: DateTime.parse(map['session_end_time']),
      banks: List<MoneybagServiceInfo>.from(map['services']['banks'].map((x) => MoneybagServiceInfo.fromMap(x))),
      mfs: List<MoneybagServiceInfo>.from(map['services']['mfs'].map((x) => MoneybagServiceInfo.fromMap(x))),
    );
  }

  @override
  String toString() {
    return 'SessionInfo(currency: $currency, orderId: $orderId, returnUrl: $returnUrl, description: $description, merchantId: $merchantId, merchantNo: $merchantNo, orderAmount: $orderAmount, merchantLogo: $merchantLogo, sessionStartTime: $sessionStartTime, sessionEndTime: $sessionEndTime, banks: $banks, mfs: $mfs)';
  }
}

class MoneybagServiceInfo {
  const MoneybagServiceInfo({
    required this.serviceName,
    required this.serviceNo,
    required this.logo,
  });

  final String serviceName;
  final int serviceNo;
  final String logo;

  factory MoneybagServiceInfo.fromMap(Map<String, dynamic> map) {
    return MoneybagServiceInfo(
      serviceName: map['service_name'],
      serviceNo: map['service_no'],
      logo: map['logo'],
    );
  }

  @override
  String toString() => 'MoneybagServiceInfo(serviceName: $serviceName, serviceNo: $serviceNo, logo: $logo)';
}

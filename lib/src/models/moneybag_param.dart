import 'dart:convert';

/// Create a [MoneybagInfo] for payment
/// *Either email or phone_no must be provided. At least one of these fields.
///
/// ```dart
/// const moneyBag = MoneyBag(
///   merchantID: "YOUR_MERCHANT_ID",
///   authKey: "YOUR_AUTH_KEY",
///   orderId: "YOUR_ORDER_ID",
///   currency: "BDT",
///   orderAmount: "100",
///   description: "Order Description",
///   returnURL: "YOUR_RETURN_URL",
///   email: "YOUR_EMAIL_ADDRESS",
///   phoneNo: "YOUR_PHONE_NUMBER",
/// );
/// ```
///
class MoneybagInfo {
  /// constructor for [MoneybagInfo] for payment
  const MoneybagInfo({
    required this.merchantID,
    required this.authKey,
    required this.orderId,
    required this.currencyCode,
    required this.orderAmount,
    required this.description,
    required this.returnURL,
    this.email,
    this.phoneNo,
  });

  /// unique identifier for the merchant
  final String merchantID;

  /// Authentication key for the merchant
  final String authKey;

  /// unique identifier for the order
  final String orderId;

  /// currency code
  final String currencyCode;

  /// Amount of the order
  final double orderAmount;

  ///Description of the transaction
  final String description;

  /// URL to which the user will be redirected after payment
  final String returnURL;

  /// Email address of the customer (optional if phone_no is provided)
  final String? email;

  /// Phone number of the customer (optional if email is provided)
  final String? phoneNo;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'merchant_id': merchantID});
    result.addAll({'auth_key': authKey});
    result.addAll({'order_id': orderId});
    result.addAll({'currency': currencyCode});
    result.addAll({'order_amount': orderAmount.toString()});
    result.addAll({'description': description});
    result.addAll({'return_url': returnURL});
    if (email != null) {
      result.addAll({'email': email});
    }
    if (phoneNo != null) {
      result.addAll({'phone_no': phoneNo});
    }

    return result;
  }

  String toJson() => json.encode(toMap());

  MoneybagInfo copyWith({
    String? merchantID,
    String? authKey,
    String? orderId,
    String? currencyCode,
    double? orderAmount,
    String? description,
    String? returnURL,
    String? email,
    String? phoneNo,
  }) {
    return MoneybagInfo(
      merchantID: merchantID ?? this.merchantID,
      authKey: authKey ?? this.authKey,
      orderId: orderId ?? this.orderId,
      currencyCode: currencyCode ?? this.currencyCode,
      orderAmount: orderAmount ?? this.orderAmount,
      description: description ?? this.description,
      returnURL: returnURL ?? this.returnURL,
      email: email ?? this.email,
      phoneNo: phoneNo ?? this.phoneNo,
    );
  }
}

extension MoneybagInfoExtension on MoneybagInfo {
  String? get isValid {
    final List<String> errors = [];
    if (merchantID.trim().isEmpty) {
      errors.add("Merchant ID");
    }

    if (authKey.trim().isEmpty) {
      errors.add("Auth Key");
    }

    if (orderId.trim().isEmpty) {
      errors.add("Order ID");
    }

    if (currencyCode.trim().isEmpty) {
      errors.add("Currency Code");
    }

    if (orderAmount <= 0) {
      errors.add("Order Amount");
    }

    if (description.trim().isEmpty) {
      errors.add("Description");
    }

    if (returnURL.trim().isEmpty) {
      errors.add("Return URL");
    }

    //email or phone at least one
    if ((email?.isEmpty ?? true) && (phoneNo?.isEmpty ?? true)) {
      errors.add("Email or Phone No");
    }

    return errors.isEmpty ? null : "${errors.join(", ")} must be provided";
  }
}

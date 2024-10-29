import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:moneybag_flutter/moneybag.dart';

void main() {
  const merchantId = String.fromEnvironment(
    "merchant_id",
  );
  const authKey = String.fromEnvironment("auth_key");

  const info = MoneybagInfo(
    isDev: true,
    email: "test@gmail.com",
    phoneNo: "01715469898",
    orderId: "MER20240424141813", //
    merchantID: merchantId, // "YOUR_MERCHANT_ID",
    authKey: authKey, // "YOUR_AUTH_KEY",
    currencyCode: "050",
    orderAmount: 100.0,
    description: "Order Description",
    returnURL: "https://your_return_url",
  );
  test('moneybag repo ...', () async {
    HttpOverrides.global = _MyHttpOverrides();
    bool isDev = false;
    final res = await MoneybagRepository.createSession(info, isDev: isDev);
    print(res.isSuccess);
    final sInfo = await MoneybagRepository.sessionInfo(res.success!.sessionId, isDev: isDev);
    print(sInfo.toString());
    for (final m in [...sInfo!.banks, ...sInfo.mfs]) {
      final s = await MoneybagRepository.serviceCharge(
          amount: sInfo.orderAmount,
          description: sInfo.description,
          merchantNo: sInfo.merchantNo,
          serviceNo: m.serviceNo.toString(),
          isDev: isDev);
      print(s?.chargeAmount.toString());
    }
  });
}

class _MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

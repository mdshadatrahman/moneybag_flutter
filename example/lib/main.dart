import 'package:flutter/material.dart';

import 'package:moneybag_flutter/moneybag.dart';

import 'input_form_view.dart';

void main() => runApp(const MaterialApp(
      home: MainApp(),
      debugShowCheckedModeBanner: false,
    ));

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () async {
        //
        const merchantId = String.fromEnvironment("merchant_id");
        const authKey = String.fromEnvironment("auth_key");

        const info = MoneybagInfo(
          isDev: true,
          email: "test@gmail.com",
          phoneNo: "01715469898",
          merchantID: merchantId, // "YOUR_MERCHANT_ID",
          authKey: authKey, // "YOUR_AUTH_KEY",
          orderId: "MER20240424141813", //YOUR_ORDER_ID ,
          currencyCode: "050",
          orderAmount: 1.0,
          description: "Order Description",
          returnURL: "https://your_return_url",
        );

        Navigator.of(context).push(MoneybagPage.route(moneybagInfo: info));
//         final res = await MoneybagRepository.createSession(info);
//
//         final result = await MoneybagRepository.sessionInfo(res.success!.sessionId);
//
//         print("${result.toString()} ${res.success!.sessionId}");
      }),
      body: const InputFormView(),
    );
  }
}

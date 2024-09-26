import 'package:flutter/material.dart';

import 'package:moneybag/moneybag.dart';

import 'input_form_view.dart';

void main() => runApp(const MaterialApp(
      home: MainApp(),
      debugShowCheckedModeBanner: false,
    ));

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    var elevatedButton = ElevatedButton(
      onPressed: () {
        const merchantId = String.fromEnvironment("merchant_id");
        const authKey = String.fromEnvironment("auth_key");

        const info = MoneybagInfo(
          email: "test@gmail.com",
          phoneNo: "01715469898",
          orderId: "MER20240424141813", //
          merchantID: merchantId, // "YOUR_MERCHANT_ID",
          authKey: authKey, // "YOUR_AUTH_KEY",
          currencyCode: "050",
          orderAmount: 1.0,
          description: "Order Description",
          returnURL: "https://your_return_url",
        );

        Navigator.of(context).push(MoneybagPage.route(moneybagInfo: info));
      },
      child: const Text("Test"),
    );
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () async {
        //
        const merchantId = String.fromEnvironment("merchant_id");
        const authKey = String.fromEnvironment("auth_key");

        const info = MoneybagInfo(
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

        // print(pg);
      }),
      body: InputFormView(),
    );
  }
}

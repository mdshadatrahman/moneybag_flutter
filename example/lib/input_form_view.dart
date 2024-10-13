import 'package:flutter/material.dart';
import 'package:moneybag_flutter/moneybag.dart';

class InputFormView extends StatefulWidget {
  const InputFormView({super.key});

  @override
  State<InputFormView> createState() => _InputFormViewState();
}

const merchantId = String.fromEnvironment("merchant_id");
const authKey = String.fromEnvironment("auth_key");

class _InputFormViewState extends State<InputFormView> {
  late var info = const MoneybagInfo(
    isDev: true,
    email: "",
    phoneNo: "",
    orderId: "MER20240424141813", //
    merchantID: merchantId, // "YOUR_MERCHANT_ID",
    authKey: authKey, // "YOUR_AUTH_KEY",
    currencyCode: "050",
    orderAmount: 1.0,
    description: "",
    returnURL: "https://your_return_url",
  );

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: "phone"),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value) {
                  info = info.copyWith(phoneNo: value);
                },
                validator: (value) {
                  if ((value ?? "").length < 10) {
                    return "required field";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(hintText: "email"),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value) {
                  info = info.copyWith(email: value);
                },
                validator: (value) {
                  if ((value ?? "").length < 3) {
                    return "required field";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(hintText: "price"),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  final amount = double.tryParse(value);
                  if (amount == null) return;

                  info = info.copyWith(orderAmount: amount);
                },
                validator: (value) {
                  final amount = double.tryParse(value ?? "0") ?? 0;
                  if (amount <= 0) {
                    return "required field";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(hintText: "description"),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value) {
                  info = info.copyWith(description: value);
                },
                validator: (value) {
                  if ((value ?? "").length < 10) {
                    return "description should be over 10 char";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SegmentedButton(
                segments: const [
                  ButtonSegment(value: true, label: Text("Dev")),
                  ButtonSegment(value: false, label: Text("Prod")),
                ],
                selected: {info.isDev},
                onSelectionChanged: (p0) {
                  info = info.copyWith(isDev: p0.first);
                  setState(() {});
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState?.validate() != true) {
                    return;
                  }
                  print(info.toString());
                  Navigator.of(context).push(MoneybagPage.route(moneybagInfo: info));
                },
                child: const Text("Test"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

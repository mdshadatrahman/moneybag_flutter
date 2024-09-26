import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../domain/moneybag_repo.dart';
import '../domain/payment_method_success_pattern_mixin.dart';
import '../domain/provider_payload.dart';
import '../domain/seassion_info.dart';
import '../domain/service_charge_response.dart';

class PaymentWebviewPage extends StatefulWidget {
  const PaymentWebviewPage._({
    required this.sessionInfo,
    required this.serviceCharge,
    required this.selectedMethod,
  });

  static MaterialPageRoute route({
    required SessionInfo sessionInfo,
    required ServiceChargeResponse serviceCharge,
    required MoneybagServiceInfo selectedMethod,
  }) {
    return MaterialPageRoute(
      builder: (context) => PaymentWebviewPage._(
        serviceCharge: serviceCharge,
        sessionInfo: sessionInfo,
        selectedMethod: selectedMethod,
      ),
    );
  }

  final SessionInfo sessionInfo;
  final ServiceChargeResponse serviceCharge;
  final MoneybagServiceInfo selectedMethod;

  @override
  State<PaymentWebviewPage> createState() => _PaymentWebviewPageState();
}

class _PaymentWebviewPageState extends State<PaymentWebviewPage> {
  late final payload = ProviderPayload(
    amount: widget.sessionInfo.orderAmount,
    chargeAmount: widget.serviceCharge.chargeAmount,
    paymode: widget.selectedMethod.serviceNo,
    pgwCharge: widget.serviceCharge.pgwCharge,
    fintechCharge: widget.serviceCharge.fintechCharge,
    description: widget.sessionInfo.description,
    merchantNo: widget.sessionInfo.merchantNo,
    orderId: widget.sessionInfo.orderId,
  );

  late Future<(Uri? url, String? error)> providerFuture = MoneybagRepository.getProvider(payload);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: FutureBuilder<(Uri? uri, String? error)>(
          future: providerFuture,
          builder: (context, snapshot) {
            Widget? view;
            if (snapshot.connectionState == ConnectionState.waiting) {
              view = const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              view = const Center(child: Text("Something went wrong,try again"));
            } else if (snapshot.data == null) {
              view = const Center(child: Text("Session Expired"));
            } else if (snapshot.data != null) {
              final data = snapshot.data!;
              if (data.$1 != null) {
                return _PaymentProviderView(
                  uri: data.$1!,
                  serviceName: widget.selectedMethod.serviceName,
                  returnUrl: widget.sessionInfo.returnUrl,
                );
              }
              view = Text(data.$2 ?? "failed");
            }

            return view ?? const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _PaymentProviderView extends StatefulWidget {
  const _PaymentProviderView({
    super.key,
    required this.serviceName,
    required this.uri,
    required this.returnUrl,
  });

  final String serviceName;
  final Uri uri;
  final String returnUrl;

  @override
  State<_PaymentProviderView> createState() => _PaymentProviderViewState();
}

class _PaymentProviderViewState extends State<_PaymentProviderView> with PaymentMethodUrlPattern {
  @override
  void initState() {
    super.initState();
  }

  late final WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(Colors.transparent)
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {},
        onPageStarted: (String url) {},
        onPageFinished: (String url) {
          debugPrint("webiew onPageFinished ${url}");
          final onComplete = onPaymentComplete(widget.returnUrl, url);
          if (onComplete != null) {
            ///I just want to pass true
            debugPrint("payment success");
            Navigator.of(context).pop(onComplete);
          }
        },
        onHttpError: (HttpResponseError error) {
          debugPrint("webiew HttpResponseError ${error.toString()}");
        },
        onWebResourceError: (WebResourceError error) {
          debugPrint("webiew onWebResourceError ${error.toString()}");
        },
        onNavigationRequest: (NavigationRequest request) async {
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(widget.uri);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: controller,
    );
  }
}

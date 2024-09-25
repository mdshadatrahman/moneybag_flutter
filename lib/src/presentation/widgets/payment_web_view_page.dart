import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../domain/moneybag_repo.dart';
import '../../domain/provider_payload.dart';
import '../../domain/seassion_info.dart';
import '../../domain/service_charge_response.dart';

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
  });

  final String serviceName;
  final Uri uri;

  @override
  State<_PaymentProviderView> createState() => _PaymentProviderViewState();
}

class _PaymentProviderViewState extends State<_PaymentProviderView> {
  @override
  void initState() {
    super.initState();
    print("webiew ${widget.uri}");
  }

  late final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(Colors.transparent)
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          print("webiew ${progress}");
        },
        onPageStarted: (String url) {
          print("webiew onPageStarted ${url}");
        },
        onPageFinished: (String url) {
          print("webiew onPageFinished ${url}");
        },
        onHttpError: (HttpResponseError error) {
          print("webiew HttpResponseError ${error.toString()}");
        },
        onWebResourceError: (WebResourceError error) {
          print("webiew onWebResourceError ${error.toString()}");
        },
        onNavigationRequest: (NavigationRequest request) {
          // if (request.url.startsWith('https://www.youtube.com/')) {
          //   return NavigationDecision.prevent;
          // }
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

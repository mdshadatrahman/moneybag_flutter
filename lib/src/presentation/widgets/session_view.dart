import 'package:flutter/material.dart';

import '../../../moneybag.dart';
import '../../domain/moneybag_response.dart';
import '../../domain/session_info.dart';
import '../../domain/service_charge_response.dart';
import 'account_type_selection_view.dart';
import 'expire_view.dart';
import 'loading_view.dart';
import 'payment_details_view.dart';
import 'session_failure_view.dart';

/// Create a [MoneyBagSessionView] for 15 minutes
///
/// [MoneybagInfo] is required
///
/// [MoneybagTheme] is optional and if not provided [theme] will use the [MoneybagTheme] default color
///
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
class MoneyBagSessionView extends StatefulWidget {
  const MoneyBagSessionView({
    super.key,
    required this.theme,
    required this.moneyBag,
    required this.session,
  });

  /// config the color theme of the view
  /// it will use the [MoneybagTheme]  default color
  final MoneybagTheme theme;

  /// pass down the [MoneybagInfo] to create  session
  final MoneybagInfo moneyBag;

  final MoneybagSuccessResponse session;

  @override
  State<MoneyBagSessionView> createState() => _MoneyBagSessionViewState();
}

class _MoneyBagSessionViewState extends State<MoneyBagSessionView> {
  /// User can unselect the payment method, this will be null if user switch the payment method/category e.g.  ard/banking
  MoneybagServiceInfo? selectedMethod;

  ServiceChargeResponse? serviceCharge;

  void onAccountTypeChanged(MoneybagServiceInfo? paymentMethod, String merchantNo) async {
    selectedMethod = paymentMethod;
    serviceCharge = null;
    setState(() {});
    if (paymentMethod == null) return;

    serviceCharge = await MoneybagRepository.serviceCharge(
      amount: widget.moneyBag.orderAmount,
      description: widget.moneyBag.description,
      merchantNo: merchantNo,
      serviceNo: paymentMethod.serviceNo.toString(),
      isDev: widget.moneyBag.isDev,
    );

    setState(() {});
  }

  void onConfirm(SessionInfo session) async {
    final route = PaymentWebviewPage.route(
      serviceCharge: serviceCharge!,
      sessionInfo: session,
      selectedMethod: selectedMethod!,
      isDev: widget.moneyBag.isDev,
    );
    final onCompleteResult = await Navigator.of(context).push(route);
    print("isSuccess $onCompleteResult");

    if (onCompleteResult?.$1 == "APPROVED") {
      Navigator.maybeOf(context)?.pop();
    } else {
      SnackBar snackBar = SnackBar(content: Text("${onCompleteResult?.$1}: ${onCompleteResult?.$2}"));
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _SessionInfoLoader(
        theme: widget.theme,
        sessionId: widget.session.sessionId,
        isDev: widget.moneyBag.isDev,
        builder: (BuildContext context, SessionInfo sessionInfo) {
          return MoneybagInheritedWidget(
            moneyBag: widget.moneyBag,
            theme: widget.theme,
            sessionInfo: sessionInfo,
            child: ExpireViewCheck(
              expiredAt: sessionInfo.sessionEndTime,
              builder: (context, remainingTime) => Column(
                children: [
                  SeasonHeaderView(
                    key: const ValueKey("Running SeasonHeaderView"),
                    remainingTime: remainingTime,
                    theme: widget.theme,
                  ),
                  Expanded(
                    child: remainingTime.inSeconds > 0
                        ? ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                                child: AccountTypeSelectionView(
                                  onAccountTypeChanged: (v) => onAccountTypeChanged(
                                    v,
                                    sessionInfo.merchantNo,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                                child: MoneybagPaymentDetails(
                                  selectedMethod: selectedMethod,
                                  description: widget.moneyBag.description,
                                  orderAmount: widget.moneyBag.orderAmount,
                                  serviceCharge: serviceCharge,
                                  onConfirm: () => onConfirm(sessionInfo),
                                ),
                              ),
                            ],
                          )
                        : const SessionFailureView(
                            title: "Session Expired",
                            message: "Please go back and try again",
                          ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

class _SessionInfoLoader extends StatefulWidget {
  const _SessionInfoLoader({
    required this.builder,
    required this.sessionId,
    required this.theme,
    required this.isDev,
  });
  final bool isDev;
  final String sessionId;
  final Widget Function(BuildContext context, SessionInfo sessionInfo) builder;

  final MoneybagTheme theme;

  @override
  State<_SessionInfoLoader> createState() => _SessionInfoLoaderState();
}

class _SessionInfoLoaderState extends State<_SessionInfoLoader> {
  late final future = MoneybagRepository.sessionInfo(
    widget.sessionId,
    isDev: widget.isDev,
  );
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SessionInfo?>(
      future: future,
      builder: (context, snapshot) {
        Widget? view;
        if (snapshot.connectionState == ConnectionState.waiting) {
          view = const MoneyBagInitialLoadingView();
        } else if (snapshot.hasError) {
          view = const SessionFailureView(
            title: "Something went wrong",
            message: "Please go back and try again",
          );
        } else if (snapshot.data == null) {
          view = const SessionFailureView(
            title: "Session Expired",
            message: "Please go back and try again",
          );
        } else if (snapshot.data != null) {
          return widget.builder(context, snapshot.data!);
        }

        return Column(
          children: [
            const SeasonHeaderView(
              remainingTime: Duration.zero,
            ),
            Expanded(child: view ?? const SizedBox.shrink()),
          ],
        );
      },
    );
  }
}

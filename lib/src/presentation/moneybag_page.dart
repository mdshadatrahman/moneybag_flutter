import 'package:flutter/material.dart';

import 'package:moneybag/src/presentation/widgets/session_failure_view.dart';
import '../../moneybag.dart';
import '../domain/moneybag_response.dart';
import 'widgets/loading_view.dart';

/// Create a [MoneybagPage]
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
///
/// await Navigator.of(context).push(MoneybagPage.route(moneyBag: moneyBag));
///
/// ```
///
class MoneybagPage extends StatefulWidget {
  const MoneybagPage._({required this.theme, required this.moneybagInfo});

  /// config the color theme of the view
  /// it will use the [MoneybagTheme]  default color
  final MoneybagTheme theme;

  /// pass down the [MoneybagInfo] to create  session
  final MoneybagInfo moneybagInfo;

  static MaterialPageRoute route({required MoneybagInfo moneybagInfo, MoneybagTheme? theme}) {
    return MaterialPageRoute(
      builder: (context) => MoneybagPage._(
        moneybagInfo: moneybagInfo,
        theme: theme ?? const MoneybagTheme(),
      ),
    );
  }

  @override
  State<MoneybagPage> createState() => _MoneybagPageState();
}

class _MoneybagPageState extends State<MoneybagPage> {
  late Future<MoneybagResponse> future = MoneybagRepository.createSession(widget.moneybagInfo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<MoneybagResponse?>(
          future: future,
          builder: (context, snapshot) {
            Widget? view;
            bool isSeasonActivated = false;
            if (snapshot.connectionState == ConnectionState.waiting) {
              view = const MoneyBagInitialLoadingView();
            }

            if (snapshot.hasError) {
              view = Center(child: Text("Something went wrong: ${snapshot.error}"));
            }

            final data = snapshot.data;

            if (data?.isFailure == true) {
              final message = data?.failure?.message ?? "";
              view = SessionFailureView(
                title: message.isNotEmpty ? "Missing Fields" : "Something went wrong",
                message: message,
              );
            }

            if (data?.isSuccess == true) {
              isSeasonActivated = true;
              view = MoneyBagSessionView(
                theme: widget.theme,
                moneyBag: widget.moneybagInfo,
                session: data!.success!,
              );
            }

            // return Text("NA state: ${snapshot.error}");

            view ??= Text("NA state: ${snapshot.error}");

            return Column(
              children: [
                if (isSeasonActivated == false)
                  const SeasonHeaderView(
                    remainingTime: Duration.zero,
                  ),
                Expanded(child: view),
              ],
            );
          },
        ),
      ),
    );
  }
}

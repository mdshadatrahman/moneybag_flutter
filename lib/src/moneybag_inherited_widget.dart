import 'package:flutter/material.dart';

import '../moneybag.dart';
import 'domain/session_info.dart';

@Deprecated("this will be removed on release, use [MoneybagInheritedWidget.of(context)]")
extension MoneybagInheritedWidgetExtension on BuildContext {
  MoneybagInheritedWidget get moneybag => MoneybagInheritedWidget.of(this);

  MoneybagTheme get moneybagTheme => moneybag.theme;

  MoneybagInfo get moneybagInfo => moneybag.moneyBag;

  SessionInfo get sessionInfo => moneybag.sessionInfo;
}

/// Pass down the config for the [MoneyBagSessionView]
class MoneybagInheritedWidget extends InheritedWidget {
  const MoneybagInheritedWidget({
    super.key,
    required super.child,
    required this.theme,
    required this.sessionInfo,
    required this.moneyBag,
  });

  final MoneybagTheme theme;

  final MoneybagInfo moneyBag;

  /// session will be available for 15min, the expiredAt is DateTime.now() + 15min
  final SessionInfo sessionInfo;

  static MoneybagInheritedWidget? maybeOf(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<MoneybagInheritedWidget>();
    } else {
      return context.getInheritedWidgetOfExactType<MoneybagInheritedWidget>();
    }
  }

  static MoneybagInheritedWidget of(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<MoneybagInheritedWidget>()!;
    } else {
      return context.getInheritedWidgetOfExactType<MoneybagInheritedWidget>()!;
    }
  }

  @override
  bool updateShouldNotify(covariant MoneybagInheritedWidget oldWidget) {
    return theme != oldWidget.theme || sessionInfo != oldWidget.sessionInfo || moneyBag != oldWidget.moneyBag;
  }
}

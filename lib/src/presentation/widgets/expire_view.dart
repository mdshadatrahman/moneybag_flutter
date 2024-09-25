import 'dart:async';

import 'package:flutter/material.dart';

///  return countDown and take child when session is expired
///
typedef ExpireViewBuilder = Widget Function(BuildContext context, Duration remainingTime);

class ExpireViewCheck extends StatefulWidget {
  const ExpireViewCheck({
    super.key,
    required this.builder,
    required this.expiredAt,
  });

  final ExpireViewBuilder builder;
  final DateTime expiredAt;

  @override
  State<ExpireViewCheck> createState() => _ExpireViewCheckState();
}

class _ExpireViewCheckState extends State<ExpireViewCheck> {
  late Timer timer;

  Duration get _duration => widget.expiredAt.difference(DateTime.now());

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      widget.builder(context, _duration);
      setState(() {});
      if (_duration.inSeconds == 0) {
        widget.builder(context, _duration);
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _duration);
  }
}

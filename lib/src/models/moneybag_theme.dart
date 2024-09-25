import 'package:flutter/material.dart';

/// config the color
class MoneybagTheme {
  const MoneybagTheme({
    this.primaryColor = const Color(0xFFFA6469),
    this.buttonColor = const Color(0xFFFE5C61),
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.primarySurfaceColor = const Color(0xFFFFFFFF),
    this.disabledColor = const Color(0xFFF5F5F5),
  });

  /// header color
  final Color primaryColor;

  final Color buttonColor;

  ///
  final Color backgroundColor;

  /// disabled button color
  final Color disabledColor;

  final Color primarySurfaceColor;

  MoneybagTheme copyWith({
    Color? primaryColor,
    Color? backgroundColor,
    Color? disabledColor,
  }) {
    return MoneybagTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      disabledColor: disabledColor ?? this.disabledColor,
    );
  }
}

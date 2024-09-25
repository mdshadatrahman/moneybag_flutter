import 'package:url_launcher/url_launcher.dart';

mixin MoneyBagUtils {
  static const _phone = "tel:+880 1958-109225";
  static const _email = "mailto:info@moneybag.com.bd?subject=MoneyBag%20Query";
  static const _privacy = "https://moneybag.com.bd/privacy-policy/";
  static const _terms = "https://moneybag.com.bd/terms-conditions/";
  static const _refundPolicy = "https://moneybag.com.bd/refund-policy/";

  Future<void> _launch(String uri) async {
    try {
      await launchUrl(Uri.parse(uri));
    } catch (_) {}
  }

  Future<void> callUse() async => await _launch(_phone);
  Future<void> emailUs() async => await _launch(_email);
  Future<void> privacyPolicy() async => await _launch(_privacy);
  Future<void> termsCondition() async => await _launch(_terms);
  Future<void> refundPolicy() async => await _launch(_refundPolicy);
}

mixin PaymentMethodUrlPattern {
  (String status, String desc)? onPaymentComplete(String baseReturnUrl, String redirectUrl) {
    final baseUri = Uri.parse(baseReturnUrl);
    final uri = Uri.tryParse(redirectUrl);
    if (baseUri.host != uri?.host || uri == null) return null;

    // webview onPageFinished https://your_return_url/?gw_order_status=APPROVED&gw_description=Transaction_Successful

    return (
      uri.queryParameters["gw_order_status"] ?? "Failed",
      uri.queryParameters["gw_description"] ?? "something went wrong",
    );
  }
}

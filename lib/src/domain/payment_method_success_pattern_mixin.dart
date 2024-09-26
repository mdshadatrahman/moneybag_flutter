mixin PaymentMethodUrlPattern {
  static const String _bkashSuccess =
      "https://dev-api.moneybag.com.bd/api/v1/receive-payment-status/bkash-callback?paymentID=TR0011rOgt09L1727341707083&status=success&signature=cdvRPMSsIk&apiVersion=1.2.0-beta/";
  static const String _rocket = "";

  (String status, String desc)? onPaymentComplete(String baseReturnUrl, String redirectUrl) {
    final baseUri = Uri.parse(baseReturnUrl);
    final uri = Uri.tryParse(redirectUrl);
    if (baseUri.host != uri?.host || uri == null) return null;

    // webiew onPageFinished https://your_return_url/?gw_order_status=APPROVED&gw_description=Transaction_Successful

    return (
      uri.queryParameters["gw_order_status"] ?? "Failed",
      uri.queryParameters["gw_description"] ?? "something went wrong",
    );
  }
}

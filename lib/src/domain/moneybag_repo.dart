import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../moneybag.dart';
import 'moneybag_response.dart';
import 'session_info.dart';
import 'service_charge_response.dart';

class MoneybagRepository {
  ///
  @Deprecated("Refactor the static method to methods")
  static bool _isDevMode = true;

  static final Uri _baseUri = Uri(
    scheme: "https",
    host: "${_isDevMode ? "dev-" : ""}api.moneybag.com.bd",
    path: "/api/v1/",
  );

  static Uri _mergeUriPath(String path) => _baseUri.replace(path: "${_baseUri.path}$path");

  static Future<MoneybagResponse> createSession(MoneybagInfo moneybagInfo) async {
    try {
      final uri = _mergeUriPath("sessions/create-session");
      _isDevMode = moneybagInfo.isDev;

      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(moneybagInfo.toMap()),
      );

      if (response.statusCode == 503 || response.statusCode == 500) {
        debugPrint(response.body.toString());
        return MoneybagResponse.exception("Server Error");
      }

      return MoneybagResponse.fromMap(jsonDecode(response.body));
    } catch (e) {
      debugPrint("Error: $e");
      return MoneybagResponse.exception(e.toString());
    }
  }

  ///  return null if expired or exception
  static Future<SessionInfo?> sessionInfo(String sessionId) async {
    try {
      final uri = _baseUri.replace(
        path: "${_baseUri.path}sessions/whoami",
        query: "sessionId=$sessionId",
      );

      final response = await http.get(uri);
      final data = jsonDecode(response.body);
      if (data['status_code'] == 403) {
        debugPrint(data['details'].toString());
        return null;
      }
      final sInfo = SessionInfo.fromMap(data);
      debugPrint("session info ${sInfo.toString()}");
      return sInfo;
    } catch (e) {
      debugPrint("Error: sessionInfo $e");
      return null;
    }
  }

  static Future<ServiceChargeResponse?> serviceCharge({
    required double amount,
    required String description,
    required String merchantNo,
    required String serviceNo,
  }) async {
    try {
      final uri = _mergeUriPath("/lookups/service-charge/");
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          "amount": amount,
          "description": description,
          "merchant_id": merchantNo,
          "service_no": serviceNo,
        }),
      );

      return ServiceChargeResponse.fromMap(jsonDecode(response.body));
    } catch (e) {
      debugPrint("Error: serviceCharge $e");
      return null;
    }
  }

  /// return provider url,
  /// return null if expired or exception
  static Future<(Uri? uri, String? error)> getProvider(ProviderPayload payload) async {
    try {
      final uri = _mergeUriPath("/gw-provider/get-pg");

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: payload.toJson(),
      );

      final data = jsonDecode(response.body);
      if (data['status'] == false) {
        return (null, data['message']?.toString() ?? "Something went wrong");
      }

      if (data['status'] == "SUCCESS") {
        final getWay = data['data']['gateway'];

        if (getWay == "EBLPAY") {
          return await _getEBLPAYPaymentURL(data['data']['ebl_checkout_payload']);
        }
        if (getWay == 'SEBLPAY') {
          final sessionId = data['data']['sebl_session_id'];
          if (sessionId == null) {
            return (null, "Failed to get bank session");
          }

          final result = await _getSEBLPAYPaymentURL(sessionId);
          return result;
        }

        final redirectURL = data['data']['redirect_url'];
        if (redirectURL != null) {
          return (Uri.tryParse(Uri.encodeFull(redirectURL)), null);
        }

        debugPrint("Error, $response");
        return (null, "Failed to get the provider");
      }

      return (null, "Failed to get provider");
    } catch (e) {
      debugPrint("Error: getProvider $e");
      return (null, e.toString());
    }
  }

  static Future<(Uri? url, String? error)> _getSEBLPAYPaymentURL(String sessionId) async {
    final redirectURL = _isDevMode
        ? "https://test-southeastbank.mtf.gateway.mastercard.com/checkout/pay/$sessionId?checkoutVersion=1.0.0"
        : "https://southeastbank.gateway.mastercard.com/checkout/pay/$sessionId?checkoutVersion=1.0.0";
    return (Uri.tryParse(Uri.encodeFull(redirectURL)), null);
  }

  static Future<(Uri? url, String? error)> _getEBLPAYPaymentURL(List<dynamic> payload) async {
    final gateway = "https://${_isDevMode ? "test-" : ""}secureacceptance.cybersource.com/pay";

    // Initialize map to store query parameters
    final Map<String, String> mapData = {};

    // Populate mapData with payload items
    for (final item in payload) {
      if (item.isEmpty) continue;
      mapData[item.keys.first] = "${item.values.first}";
    }

    try {
      // Correctly construct the Uri with the scheme and host
      final Uri uri = Uri.parse(gateway).replace(queryParameters: mapData);

      return (uri, null); // Return the constructed URI
    } catch (e) {
      // Return error message if URI construction fails
      return (null, 'Failed to construct URI: $e');
    }
  }
}

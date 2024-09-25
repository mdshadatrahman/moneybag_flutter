/// If [MoneyBag] is successful, it will return this [MoneybagSuccessResponse]
///
/// for more checkout
/// ! [documentations](https://moneybag.com.bd/documentations/)
///
final class MoneybagSuccessResponse {
  const MoneybagSuccessResponse({
    required this.status,
    required this.sessionId,
    required this.redirectUrl,
  });

  /// Status of the session creation
  final String status;

  /// Unique identifier for the created session
  final String sessionId;

  /// URL to which the user should be redirected for payment
  final String redirectUrl;

  @override
  String toString() => 'MoneybagSuccessResponse(status: $status, sessionId: $sessionId, redirectUrl: $redirectUrl)';

  factory MoneybagSuccessResponse.fromMap(Map<String, dynamic> map) {
    return MoneybagSuccessResponse(
      status: map['status'] ?? '',
      sessionId: map['session_id'] ?? '',
      redirectUrl: map['redirect_url'] ?? '',
    );
  }
}

/// If [MoneyBag] fails, it will return this [MoneybagFailures]
///
/// [message] is the error message to show to the user
/// or to create custom error to show to the user
///
/// for more checkout
/// ! [documentations](https://moneybag.com.bd/documentations/)
///
///
final class MoneybagFailures {
  const MoneybagFailures({
    this.status,
    required this.message,
    this.statusCode,
    this.data,
  });

  final String? status;
  final String message;
  final int? statusCode;
  final dynamic data;

  factory MoneybagFailures.fromMap(Map<String, dynamic> map) {
    return MoneybagFailures(
      status: map['status'],
      message: map['message'] ?? '',
      statusCode: int.tryParse("${map['status_code']}"),
    );
  }

  @override
  String toString() {
    return 'MoneybagFailures(status: $status, message: $message, statusCode: $statusCode, data: $data)';
  }
}

/// Return the [MoneybagResponse] from [MoneyBag] api call
///
/// - if [MoneyBag] is successful it will return [MoneybagSuccessResponse]
///
/// - if [MoneyBag] fails it will return [MoneybagFailures]
///
/// for more checkout
/// ! [documentations](https://moneybag.com.bd/documentations/)
///
final class MoneybagResponse {
  const MoneybagResponse._({
    this.success,
    this.failure,
  });

  final MoneybagSuccessResponse? success;
  final MoneybagFailures? failure;

  /// if [MoneyBag] is successful it will return [MoneybagSuccessResponse]
  bool get isSuccess => success != null;

  /// if [MoneyBag] fails it will return [MoneybagFailures]
  bool get isFailure => failure != null;

  factory MoneybagResponse.fromMap(Map<String, dynamic> map) {
    return MoneybagResponse._(
      success: map['status'] == "SUCCESS" ? MoneybagSuccessResponse.fromMap(map) : null,
      failure: map['status'] == "FAILED" ? MoneybagFailures.fromMap(map) : null,
    );
  }

  MoneybagResponse.exception(String message) : this._(failure: MoneybagFailures(message: message));
}

/// Standard API response envelope.
///
/// Every endpoint returns data wrapped in this class so callers always have a
/// consistent contract: check [success], read [data] on success, read [message]
/// on failure.
class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.verdict,
    this.statusCode,
    this.meta,
  });

  final bool success;
  final T? data;
  final String? message;

  /// Business outcome reported in the envelope (e.g. `success`, `login_failed`,
  /// `otp_limit_exceeded`). Distinct from [success], which only reflects the
  /// HTTP status. Callers may branch on specific verdicts.
  final String? verdict;
  final int? statusCode;

  /// Pagination or extra metadata returned by the server.
  final Map<String, dynamic>? meta;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      message: json['message'] as String?,
      verdict: json['verdict'] as String?,
      statusCode: json['status_code'] as int?,
      meta: json['meta'] as Map<String, dynamic>?,
    );
  }
}

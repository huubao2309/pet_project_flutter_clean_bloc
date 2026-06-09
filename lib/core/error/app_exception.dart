sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class NetworkException extends AppException {
  const NetworkException([super.message = 'Lỗi kết nối mạng']);
}

final class AuthException extends AppException {
  const AuthException([super.message = 'Phiên đăng nhập hết hạn']);
}

final class ServerException extends AppException {
  const ServerException({this.statusCode, String message = 'Lỗi máy chủ'})
      : super(message);

  final int? statusCode;

  static ServerException withCode(int code, [String message = 'Lỗi máy chủ']) =>
      ServerException(statusCode: code, message: message);
}

final class CacheException extends AppException {
  const CacheException([super.message = 'Lỗi bộ nhớ cục bộ']);
}

final class ValidationException extends AppException {
  const ValidationException(super.message);
}

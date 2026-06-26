import 'api_response.dart';

/// Transport-agnostic HTTP contract (a "port").
///
/// Data sources depend on this abstraction, never on the concrete [DioClient],
/// so the network library stays swappable and — crucially — data sources can be
/// unit-tested against a lightweight fake/mock of this interface without
/// standing up a real `Dio`. [DioClient] is the production implementation.
abstract class HttpClient {
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(Object?)? fromJson,
  });

  Future<ApiResponse<T>> post<T>(
    String path, {
    Object? data,
    T Function(Object?)? fromJson,
  });

  Future<ApiResponse<T>> put<T>(
    String path, {
    Object? data,
    T Function(Object?)? fromJson,
  });

  Future<ApiResponse<T>> delete<T>(String path);
}

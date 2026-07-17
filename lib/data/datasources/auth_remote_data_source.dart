import 'package:pet_project_flutter_clean_bloc/data/models/auth/request/forgot_password_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/request/login_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/request/reset_password_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/request/register_password_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/request/sign_up_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/request/verify_otp_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/response/login_data_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/response/otp_challenge_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/response/register_password_data_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/response/verify_otp_data_dto.dart';

/// Remote data source contract for the auth feature.
///
/// Returns DTOs and throws [AppException]s on failure. The repository depends
/// on this abstraction, so swapping the real API for fake data is a single DI
/// line — see [AuthApiDataSource] (real) and [AuthMockDataSource] (fake).
abstract class AuthRemoteDataSource {
  Future<LoginDataDto> login(LoginRequestDto request);

  /// Registers a new account. Returns the response `data` as an
  /// [OtpChallengeDto]: it carries a `verify_otp` challenge when the backend
  /// requires OTP verification, otherwise its challenge fields are absent.
  Future<OtpChallengeDto> signUp(SignUpRequestDto request);

  /// Sends a reset code and returns the `verify_otp` challenge (session token +
  /// timers) the OTP screen needs.
  Future<OtpChallengeDto> forgotPassword(ForgotPasswordRequestDto request);

  Future<void> resetPassword(ResetPasswordRequestDto request);

  /// Verifies the OTP code against the session token. The response carries the
  /// next step: tokens (`challenge_type: "none"`) in the login flow, or a
  /// `register_password` challenge (with a fresh session token) in the sign-up
  /// flow.
  Future<VerifyOtpDataDto> verifyOtp(VerifyOtpRequestDto request);

  /// Sets the password for a sign-up that has passed OTP verification, using the
  /// session token from the verify-otp response. Returns the auth tokens.
  Future<RegisterPasswordDataDto> registerPassword(
    RegisterPasswordRequestDto request,
  );

  Future<void> logout();
}

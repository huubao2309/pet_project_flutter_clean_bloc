import '../../../../core/use_case/use_case.dart';
import '../entities/verify_otp_result.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpParams {
  const VerifyOtpParams({required this.code, required this.sessionToken});

  /// The 6-digit code the user entered.
  final String code;

  /// Session token issued by the login / sign-up step that opened the OTP
  /// screen — proves this verification belongs to that request.
  final String sessionToken;
}

class VerifyOtpUseCase implements UseCase<VerifyOtpResult, VerifyOtpParams> {
  const VerifyOtpUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<VerifyOtpResult> execute(VerifyOtpParams params) =>
      authRepository.verifyOtp(
        code: params.code,
        sessionToken: params.sessionToken,
      );
}

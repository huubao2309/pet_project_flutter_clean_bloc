import '../../../../core/use_case/use_case.dart';
import '../entities/verify_otp_result.dart';
import '../repositories/auth_repository.dart';

/// Verifies the OTP [code] for the in-progress pre-auth flow. The session token
/// is resolved by the data layer (PreAuthSession), so the caller only supplies
/// the code.
class VerifyOtpUseCase implements UseCase<VerifyOtpResult, String> {
  const VerifyOtpUseCase({required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<VerifyOtpResult> execute(String code) =>
      authRepository.verifyOtp(code: code);
}

import '../../../../core/use_case/use_case.dart';
import '../entities/otp_challenge.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase implements UseCase<OtpChallenge, String> {
  const ForgotPasswordUseCase({required this.authRepository});

  final AuthRepository authRepository;

  /// [params] is the phone number to send the reset code to. Returns the
  /// `verify_otp` challenge for the OTP screen.
  @override
  Future<OtpChallenge> execute(String params) =>
      authRepository.forgotPassword(phone: params);
}

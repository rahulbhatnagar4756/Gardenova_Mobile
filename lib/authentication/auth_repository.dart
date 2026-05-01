import 'package:kasagardem/authentication/register/register_request_model.dart';
import 'package:kasagardem/utils/constants/api_keys.dart';
import 'package:kasagardem/utils/network_services/api_repository.dart';

class AuthRepository {
  final String _registerUrl = 'api/v1/auth/register';
  final String _loginUrl = 'api/v1/auth/login';
  final String _googleLoginUrl = 'api/v1/auth/google';
  final String _facebookLoginUrl = 'api/v1/auth/facebook';
  final String _appleLoginUrl = 'api/v1/auth/apple';
  final String _sendVerificationCode = 'api/v1/auth/sendVerificationToken';
  final String _passwordResetCode = 'api/v1/auth/passwordResetToken';
  final String _verifyCode = 'api/v1/auth/verifyToken';
  final String _resetPassword = 'api/v1/auth/resetPassword';
  final String _profileDetail = 'api/v1/userProfile';
  final String _professionalProfileDetail = 'api/v1/professional/ProfessionalsProfile';
  final String _refreshTokenUrl = 'api/v1/auth/refresh';

  registerUser({RegisterRequestModel? registerReq}) async {
    var registerResponse = await ApiRepository.instance.post(
      _registerUrl,
      body: registerReq,
    );
    return registerResponse;
  }

  loginUser({Map? loginReq}) async {
    var loginResponse = await ApiRepository.instance.post(
      _loginUrl,
      body: loginReq,
    );
    return loginResponse;
  }

  registerGoogleToken({Map? socialLoginReq}) async {
    var socialLoginResponse = await ApiRepository.instance.post(
      _googleLoginUrl,
      body: socialLoginReq,
    );
    return socialLoginResponse;
  }

  registerFacebookToken({Map? socialLoginReq}) async {
    var socialLoginResponse = await ApiRepository.instance.post(
      _facebookLoginUrl,
      body: socialLoginReq,
    );
    return socialLoginResponse;
  }

  registerAppleToken({Map? socialLoginReq}) async {
    var socialLoginResponse = await ApiRepository.instance.post(
      _appleLoginUrl,
      body: socialLoginReq,
    );
    return socialLoginResponse;
  }

  sendOtp({required String? email}) async {
    var loginResponse = await ApiRepository.instance.post(
      _sendVerificationCode,
      body: {ApiKeys.email: email},
    );
    return loginResponse;
  }

  sendPasswordResetCode({
    required String? email,
    bool? isResend = false,
  }) async {
    var loginResponse = await ApiRepository.instance.post(
      _passwordResetCode,
      body: {ApiKeys.email: email, ApiKeys.isResend: isResend},
    );
    return loginResponse;
  }

  verifyOtp({required String? email, required String? otp}) async {
    var verifyOtpResponse = await ApiRepository.instance.post(
      _verifyCode,
      body: {ApiKeys.email: email, ApiKeys.token: otp},
    );
    return verifyOtpResponse;
  }

  resetPassword({
    required String? email,
    required String? otp,
    required String? password,
  }) async {
    var resetPasswordResponse = await ApiRepository.instance.patch(
      _resetPassword,
      {ApiKeys.email: email, ApiKeys.token: otp, ApiKeys.password: password},
    );
    return resetPasswordResponse;
  }

  fetchProfile() async {
    var profileResponse = await ApiRepository.instance.get(_profileDetail);
    return profileResponse;
  }

  fetchProfessionalProfile() async {
    var profileResponse = await ApiRepository.instance.get(
      _professionalProfileDetail,
    );
    return profileResponse;
  }

  refreshToken() async {
    var refreshTokenResponse = await ApiRepository.instance.get(
      _refreshTokenUrl,
    );
    return refreshTokenResponse;
  }
}

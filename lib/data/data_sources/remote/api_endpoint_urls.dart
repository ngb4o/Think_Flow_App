class ApiEndpointUrls {
  ApiEndpointUrls._();

  static const String loginWithEmailAndPassword = "/auth/v1/authenticate";
  static const String signupWithEmailAndPassword = "/auth/v1/register";
  static const String verifyEmail = "/auth/v1/verify-email";
  static const String resendVerifyEmail = "/auth/v1/verify-email/send-otp";
  static const String forgotPassword = "/auth/v1/forgot-password";
  static const String resetPassword = "/auth/v1/reset-password";
  static const String logout = "/auth/v1/logout";
}
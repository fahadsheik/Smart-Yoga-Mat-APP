class ApiConstants {
  static const String baseUrl = 'http://devapiv4.dealsdray.com/api/v2';
  
  // API Endpoints
  static const String deviceInfoEndpoint = '$baseUrl/user/device/add';
  static const String sendOtpEndpoint = '$baseUrl/user/otp';
  static const String verifyOtpEndpoint = '$baseUrl/user/otp/verification';
  static const String registerEndpoint = '$baseUrl/user/email/referral';
  static const String productsEndpoint = '$baseUrl/user/home/withoutPrice';

  // Request/Response Keys
  static const String authToken = 'token';
  static const String userId = 'userId';
  static const String deviceId = 'deviceId';
}

class AppConstants {
  static const String appName = 'DealsDray';
  static const String appVersion = '1.20.5';
  static const String deviceIdKey = 'device_id';
  static const String userIdKey = 'user_id';
  static const String authTokenKey = 'auth_token';
  static const String isFirstLaunchKey = 'is_first_launch';
  static const String isLoggedInKey = 'is_logged_in';
}

class ErrorMessages {
  static const String noInternet = 'No internet connection. Please check your network and try again.';
  static const String serverError = 'Server error occurred. Please try again later.';
  static const String timeoutError = 'Request timed out. Please try again.';
  static const String unknownError = 'An unexpected error occurred. Please try again.';
  static const String invalidOtp = 'Invalid OTP. Please try again.';
  static const String invalidMobile = 'Please enter a valid mobile number.';
  static const String invalidEmail = 'Please enter a valid email address.';
  static const String invalidPassword = 'Password must be at least 8 characters long.';
}
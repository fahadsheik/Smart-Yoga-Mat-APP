import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dealsdray_app/models/user_model.dart';
import 'package:dealsdray_app/utils/api_service.dart';
import 'package:dealsdray_app/utils/constants.dart';
import 'package:dealsdray_app/utils/storage_service.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  otpSent,
  otpVerified,
  error,
}

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  AuthStatus _status = AuthStatus.initial;
  User? _currentUser;
  String? _deviceId;
  String? _errorMessage;
  bool _isResendingOtp = false;
  int _resendOtpCountdown = 60;

  AuthStatus get status => _status;
  User? get currentUser => _currentUser;
  String? get deviceId => _deviceId;
  String? get errorMessage => _errorMessage;
  bool get isResendingOtp => _isResendingOtp;
  int get resendOtpCountdown => _resendOtpCountdown;

  AuthProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await storageService.init();
    final deviceIdFromStorage = await storageService.secureRead(AppConstants.deviceIdKey);
    if (deviceIdFromStorage != null) {
      _deviceId = deviceIdFromStorage;
    }
    
    final userIdFromStorage = await storageService.secureRead(AppConstants.userIdKey);
    final userJson = await storageService.getString('user_data');
    
    if (userIdFromStorage != null && userJson != null) {
      try {
        _currentUser = User.fromJson(json.decode(userJson));
        _status = AuthStatus.authenticated;
      } catch (e) {
        _status = AuthStatus.unauthenticated;
      }
    } else {
      _status = AuthStatus.unauthenticated;
    }
    
    notifyListeners();
  }

  Future<void> registerDeviceInfo(Map<String, dynamic> deviceInfo) async {
    _status = AuthStatus.loading;
    notifyListeners();

    final response = await _apiService.post<Map<String, dynamic>>(
      ApiConstants.deviceInfoEndpoint,
      body: deviceInfo,
      fromJson: (json) => json,
    );

    if (response.success && response.data != null) {
      final data = response.data!;
      _deviceId = data['deviceId'] ?? deviceInfo['deviceId'];
      await storageService.secureWrite(AppConstants.deviceIdKey, _deviceId!);
      _status = AuthStatus.unauthenticated;
    } else {
      _errorMessage = response.error ?? ErrorMessages.unknownError;
      _status = AuthStatus.error;
    }
    notifyListeners();
  }

  Future<bool> sendOtp(String mobileNumber) async {
    if (_deviceId == null) {
      _errorMessage = 'Device not registered. Please restart the app.';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }

    _status = AuthStatus.loading;
    notifyListeners();

    final response = await _apiService.post<Map<String, dynamic>>(
      ApiConstants.sendOtpEndpoint,
      body: {
        'mobileNumber': mobileNumber,
        'deviceId': _deviceId,
      },
      fromJson: (json) => json,
    );

    if (response.success && response.data != null) {
      final data = response.data!;
      if (_currentUser == null) {
        _currentUser = User(
          id: data['userId'] ?? '',
          mobileNumber: mobileNumber,
        );
      } else {
        _currentUser = _currentUser!.copyWith(
          id: data['userId'] ?? _currentUser!.id,
          mobileNumber: mobileNumber,
        );
      }

      _status = AuthStatus.otpSent;
      _startResendOtpCountdown();
      notifyListeners();
      return true;
    } else {
      _errorMessage = response.error ?? ErrorMessages.unknownError;
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyOtp(String otp) async {
    if (_currentUser == null || _deviceId == null) {
      _errorMessage = 'User or device information missing.';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }

    _status = AuthStatus.loading;
    notifyListeners();

    final response = await _apiService.post<Map<String, dynamic>>(
      ApiConstants.verifyOtpEndpoint,
      body: {
        'otp': otp,
        'deviceId': _deviceId,
        'userId': _currentUser!.id,
      },
      fromJson: (json) => json,
    );

    if (response.success && response.data != null) {
      final data = response.data!;
      final token = data['token'] as String?;
      final isRegistered = data['isRegistered'] as bool? ?? false;

      _currentUser = _currentUser!.copyWith(
        token: token,
        isRegistered: isRegistered,
      );
      
      await _saveUserData();
      
      if (isRegistered) {
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.otpVerified;
      }
      
      notifyListeners();
      return true;
    } else {
      _errorMessage = response.error ?? ErrorMessages.invalidOtp;
      _status = AuthStatus.otpSent; // go back to OTP screen
      notifyListeners();
      return false;
    }
  }

  Future<bool> registerUser({
    required String email,
    required String password,
    String? referralCode,
  }) async {
    if (_currentUser == null || _deviceId == null) {
      _errorMessage = 'User or device information missing.';
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }

    _status = AuthStatus.loading;
    notifyListeners();

    final Map<String, dynamic> body = {
      'email': email,
      'password': password,
      'userId': _currentUser!.id,
    };

    if (referralCode != null && referralCode.isNotEmpty) {
      body['referralCode'] = int.tryParse(referralCode) ?? 0;
    }

    final response = await _apiService.post<Map<String, dynamic>>(
      ApiConstants.registerEndpoint,
      body: body,
      fromJson: (json) => json,
    );

    if (response.success && response.data != null) {
      final data = response.data!;
      final token = data['token'] as String?;
      
      _currentUser = _currentUser!.copyWith(
        email: email,
        isRegistered: true,
        token: token ?? _currentUser!.token,
      );
      
      await _saveUserData();
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } else {
      _errorMessage = response.error ?? ErrorMessages.unknownError;
      _status = AuthStatus.otpVerified;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await storageService.secureClear();
    await storageService.clear();
    
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void _startResendOtpCountdown() {
    _resendOtpCountdown = 60;
    _isResendingOtp = true;
    notifyListeners();
    
    Future.delayed(const Duration(seconds: 1), () {
      if (_resendOtpCountdown > 0) {
        _resendOtpCountdown--;
        _startResendOtpCountdown();
      } else {
        _isResendingOtp = false;
        notifyListeners();
      }
    });
  }

  Future<void> _saveUserData() async {
    if (_currentUser != null) {
      await storageService.secureWrite(AppConstants.userIdKey, _currentUser!.id);
      if (_currentUser!.token != null) {
        await storageService.secureWrite(AppConstants.authTokenKey, _currentUser!.token!);
      }
      await storageService.setString('user_data', json.encode(_currentUser!.toJson()));
      
      if (_currentUser!.isRegistered) {
        await storageService.setBool(AppConstants.isLoggedInKey, true);
      }
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
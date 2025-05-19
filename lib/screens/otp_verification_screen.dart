import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:dealsdray_app/providers/auth_provider.dart';
import 'package:dealsdray_app/screens/home_screen.dart';
import 'package:dealsdray_app/screens/registration_screen.dart';
import 'package:dealsdray_app/utils/app_theme.dart';
import 'package:dealsdray_app/widgets/primary_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String mobileNumber;

  const OtpVerificationScreen({
    Key? key,
    required this.mobileNumber,
  }) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _otpController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _otpController.text.length == 4;
    });
  }

  Future<void> _verifyOtp() async {
    if (_isFormValid) {
      final result = await Provider.of<AuthProvider>(context, listen: false)
          .verifyOtp(_otpController.text);
      
      if (result && mounted) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        
        if (authProvider.status == AuthStatus.authenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        } else if (authProvider.status == AuthStatus.otpVerified) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const RegistrationScreen(),
            ),
          );
        }
      }
    }
  }

  void _resendOtp() async {
    await Provider.of<AuthProvider>(context, listen: false)
        .sendOtp(widget.mobileNumber);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP has been resent'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'OTP Verification',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTextColor,
                      ),
                  children: [
                    const TextSpan(text: 'Enter the OTP sent to '),
                    TextSpan(
                      text: '+91 ${widget.mobileNumber}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // OTP Fields
              PinCodeTextField(
                appContext: context,
                length: 4,
                obscureText: false,
                controller: _otpController,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: 60,
                  fieldWidth: 60,
                  activeFillColor: Colors.white,
                  inactiveFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                  activeColor: AppTheme.primaryColor,
                  inactiveColor: Colors.grey[300],
                  selectedColor: AppTheme.primaryColor,
                ),
                keyboardType: TextInputType.number,
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                onChanged: (value) {},
              ),
              if (authProvider.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    authProvider.errorMessage!,
                    style: const TextStyle(
                      color: AppTheme.errorColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              // Verify OTP Button
              PrimaryButton(
                text: 'Verify OTP',
                onPressed: _isFormValid ? _verifyOtp : null,
                isLoading: authProvider.status == AuthStatus.loading,
              ),
              const SizedBox(height: 24),
              // Resend OTP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the OTP? ",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.lightTextColor,
                        ),
                  ),
                  authProvider.isResendingOtp
                      ? Text(
                          'Resend in ${authProvider.resendOtpCountdown}s',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor.withOpacity(0.6),
                          ),
                        )
                      : GestureDetector(
                          onTap: _resendOtp,
                          child: const Text(
                            'Resend OTP',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
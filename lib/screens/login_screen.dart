import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dealsdray_app/providers/auth_provider.dart';
import 'package:dealsdray_app/screens/otp_verification_screen.dart';
import 'package:dealsdray_app/utils/app_theme.dart';
import 'package:dealsdray_app/utils/validators.dart';
import 'package:dealsdray_app/widgets/custom_text_field.dart';
import 'package:dealsdray_app/widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  bool _isFormValid = false;
  late AnimationController _animController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeIn,
      ),
    );
    
    _animController.forward();
    
    _mobileController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _mobileController.text.length == 10;
    });
  }

  Future<void> _sendOtp() async {
    if (_formKey.currentState!.validate()) {
      final mobileNumber = _mobileController.text;
      
      final result = await Provider.of<AuthProvider>(context, listen: false)
          .sendOtp(mobileNumber);
      
      if (result && mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              mobileNumber: mobileNumber,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeInAnimation,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    // Logo
                    Center(
                      child: Image.network(
                        'https://dealsdray.com/assets/images/logos/dealsdray-logo.png',
                        height: 80,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Welcome Text
                    Text(
                      'Welcome',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Login with mobile number',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.lightTextColor,
                          ),
                    ),
                    const SizedBox(height: 40),
                    // Mobile Number Field
                    CustomTextField(
                      label: 'Mobile Number',
                      hint: 'Enter your 10 digit mobile number',
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: Validators.validateMobile,
                      prefix: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          '+91',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textColor,
                          ),
                        ),
                      ),
                      errorText: authProvider.errorMessage,
                    ),
                    const SizedBox(height: 24),
                    // Send OTP Button
                    PrimaryButton(
                      text: 'Send OTP',
                      onPressed: _isFormValid ? _sendOtp : null,
                      isLoading: authProvider.status == AuthStatus.loading,
                    ),
                    const SizedBox(height: 20),
                    // Terms and Conditions
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'By continuing, you agree to our Terms of Service and Privacy Policy',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.lightTextColor,
                                fontSize: 12,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
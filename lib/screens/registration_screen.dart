import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dealsdray_app/providers/auth_provider.dart';
import 'package:dealsdray_app/screens/home_screen.dart';
import 'package:dealsdray_app/utils/app_theme.dart';
import 'package:dealsdray_app/utils/validators.dart';
import 'package:dealsdray_app/widgets/custom_text_field.dart';
import 'package:dealsdray_app/widgets/primary_button.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _referralController = TextEditingController();
  bool _isObscure = true;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _emailController.text.isNotEmpty && 
                    Validators.validateEmail(_emailController.text) == null &&
                    _passwordController.text.isNotEmpty && 
                    Validators.validatePassword(_passwordController.text) == null;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final result = await Provider.of<AuthProvider>(context, listen: false).registerUser(
        email: _emailController.text,
        password: _passwordController.text,
        referralCode: _referralController.text.isEmpty ? null : _referralController.text,
      );
      
      if (result && mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    }
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
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Account',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Complete your registration',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.lightTextColor,
                        ),
                  ),
                  const SizedBox(height: 40),
                  // Email Field
                  CustomTextField(
                    label: 'Email',
                    hint: 'Enter your email address',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                  ),
                  const SizedBox(height: 20),
                  // Password Field
                  CustomTextField(
                    label: 'Password',
                    hint: 'Create a password',
                    controller: _passwordController,
                    obscureText: _isObscure,
                    validator: Validators.validatePassword,
                    suffix: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                        color: AppTheme.lightTextColor,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Referral Code Field
                  CustomTextField(
                    label: 'Referral Code (Optional)',
                    hint: 'Enter referral code if you have one',
                    controller: _referralController,
                    keyboardType: TextInputType.number,
                    validator: Validators.validateReferralCode,
                  ),
                  if (authProvider.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        authProvider.errorMessage!,
                        style: const TextStyle(
                          color: AppTheme.errorColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),
                  // Register Button
                  PrimaryButton(
                    text: 'Create Account',
                    onPressed: _isFormValid ? _register : null,
                    isLoading: authProvider.status == AuthStatus.loading,
                  ),
                  const SizedBox(height: 24),
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
    );
  }
}
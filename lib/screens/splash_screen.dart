import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dealsdray_app/providers/auth_provider.dart';
import 'package:dealsdray_app/screens/home_screen.dart';
import 'package:dealsdray_app/screens/login_screen.dart';
import 'package:dealsdray_app/utils/constants.dart';
import 'package:dealsdray_app/utils/device_info_utils.dart';
import 'package:dealsdray_app/utils/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    
    _animationController.forward();
    
    _initializeApp();
  }
  
  Future<void> _initializeApp() async {
    await storageService.init();
    final isFirstLaunch = storageService.getBool(AppConstants.isFirstLaunchKey) ?? true;
    
    if (isFirstLaunch) {
      await _registerDevice();
      await storageService.setBool(AppConstants.isFirstLaunchKey, false);
    }
    
    final isLoggedIn = storageService.getBool(AppConstants.isLoggedInKey) ?? false;
    
    // Minimum 2 second delay for splash screen
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      if (isLoggedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }
  
  Future<void> _registerDevice() async {
    try {
      final deviceInfo = await DeviceInfoUtils.getDeviceInfo();
      await Provider.of<AuthProvider>(context, listen: false).registerDeviceInfo(deviceInfo);
    } catch (e) {
      debugPrint('Error registering device: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Image.network(
                      'https://dealsdray.com/assets/images/logos/dealsdray-logo.png', 
                      height: 120,
                      width: 220,
                    ),
                    const SizedBox(height: 24),
                    // Loading indicator
                    const SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00A4A9)),
                        strokeWidth: 3,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Text
                    const Text(
                      'Welcome to DealsDray',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF343F56),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
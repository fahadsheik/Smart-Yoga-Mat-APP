import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dealsdray_app/providers/auth_provider.dart';
import 'package:dealsdray_app/providers/product_provider.dart';
import 'package:dealsdray_app/screens/splash_screen.dart';
import 'package:dealsdray_app/utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        title: 'DealsDray',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
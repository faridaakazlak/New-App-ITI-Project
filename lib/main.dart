import 'package:flutter/material.dart';
import 'package:news_app/services/local_auth_service.dart';
import 'package:news_app/views/login_screen.dart';
import 'package:news_app/views/register_screen.dart';
import 'package:news_app/views/forgot_password_screen.dart';
import 'package:news_app/views/homescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authService = await LocalAuthService.create();

  runApp(MyApp(authService: authService));
}

class MyApp extends StatelessWidget {
  final LocalAuthService authService;

  const MyApp({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        primaryColor: const Color(0xFFFF7043),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF7043),
          primary: const Color(0xFFFF7043),
          secondary: const Color(0xFF66BB6A),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFCCBC),
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF7043),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFFFFFF),
          hintStyle: TextStyle(color: Colors.grey.shade600),
          labelStyle: TextStyle(color: Colors.grey.shade800),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFFF7043)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF66BB6A), width: 2),
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF7043),
          ),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        dividerColor: Colors.grey.shade300,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(authService: authService),
        '/register': (context) => RegisterScreen(authService: authService),
        '/forgot-password': (context) =>
            ForgotPasswordScreen(authService: authService),
        '/home': (context) => HomeScreen(authService: authService),
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../services/local_auth_service.dart';
import '../models/user_model.dart';
import 'package:collection/collection.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final LocalAuthService authService;

  const ForgotPasswordScreen({super.key, required this.authService});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _answerController = TextEditingController();
  final _newPasswordController = TextEditingController();

  UserModel? user;
  String? error;
  String securityQuestion = '';
  int step = 1;

  void checkEmail() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        error = 'Email cannot be empty';
      });
      return;
    }

    final users = await widget.authService.getAllUsers();
    final foundUser = users.firstWhereOrNull(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
    );

    if (foundUser == null) {
      setState(() {
        error = 'Email not found';
      });
    } else {
      setState(() {
        user = foundUser;
        securityQuestion = foundUser.securityQuestion ?? '';
        error = null;
        step = 2;
      });
    }
  }

  void checkAnswer() {
    final userAnswer = _answerController.text.trim();
    final correctAnswer = user?.securityAnswer?.toLowerCase().trim();

    if (userAnswer.isEmpty) {
      setState(() {
        error = 'Answer cannot be empty';
      });
      return;
    }

    if (user == null || correctAnswer != userAnswer.toLowerCase()) {
      setState(() {
        error = 'Incorrect answer';
      });
    } else {
      setState(() {
        step = 3;
        error = null;
      });
    }
  }

  void resetPassword() async {
    final newPassword = _newPasswordController.text.trim();

    if (newPassword.isEmpty) {
      setState(() {
        error = 'Password cannot be empty';
      });
      return;
    }

    if (newPassword.length < 8) {
      setState(() {
        error = 'Password must be at least 8 characters';
      });
      return;
    }

    final success = await widget.authService.changePassword(
      user!.email,
      user!.passwordHash,
      newPassword,
    );

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset successful')),
      );
      Navigator.pop(context);
    } else {
      setState(() {
        error = 'Failed to update password';
      });
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (step == 1) ...[
              const Text(
                'Enter your email address:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('Email'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: checkEmail, child: const Text('Next')),
            ],
            if (step == 2) ...[
              const Text(
                'Security Question:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(securityQuestion),
              const SizedBox(height: 10),
              TextField(
                controller: _answerController,
                decoration: _inputDecoration('Your answer'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: checkAnswer,
                child: const Text('Verify Answer'),
              ),
            ],
            if (step == 3) ...[
              const Text('Enter new password:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: _inputDecoration('New password'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: resetPassword,
                child: const Text('Reset Password'),
              ),
            ],
            if (error != null) ...[
              const SizedBox(height: 20),
              Text(
                error!,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

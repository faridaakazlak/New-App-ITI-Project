import 'package:flutter/material.dart';
import '../services/local_auth_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String userEmail;
  final LocalAuthService authService;

  const ChangePasswordScreen({
    Key? key,
    required this.userEmail,
    required this.authService,
  }) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? errorMessage;
  bool isLoading = false;

  Future<void> _submit() async {
    setState(() {
      errorMessage = null;
      isLoading = true;
    });

    final oldPass = oldPasswordController.text.trim();
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      setState(() {
        errorMessage = 'All fields are required.';
        isLoading = false;
      });
      return;
    }

    if (newPass != confirmPass) {
      setState(() {
        errorMessage = 'Passwords do not match.';
        isLoading = false;
      });
      return;
    }

    final success = await widget.authService.changePassword(
      widget.userEmail,
      oldPass,
      newPass,
    );

    setState(() => isLoading = false);

    if (success) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Password updated successfully.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // يغلق الديالوج
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        errorMessage = 'Old password is incorrect.';
      });
    }
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            _buildTextField('Old Password', oldPasswordController),
            _buildTextField('New Password', newPasswordController),
            _buildTextField('Confirm Password', confirmPasswordController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Update Password'),
            ),
          ],
        ),
      ),
    );
  }
}

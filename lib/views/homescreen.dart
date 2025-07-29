import 'package:flutter/material.dart';
import 'package:news_app/services/local_auth_service.dart';
import 'change_password_screen.dart'; // استورد شاشة تغيير كلمة المرور

class HomeScreen extends StatefulWidget {
  final LocalAuthService authService;

  const HomeScreen({super.key, required this.authService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<String?> _userEmailFuture;

  @override
  void initState() {
    super.initState();
    _userEmailFuture = _getUserEmail();
  }

  Future<String?> _getUserEmail() async {
    final user = await widget.authService.getCurrentUser();
    return user?.email;
  }

  void _logout() async {
    await widget.authService.logout();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void _goToChangePassword(String userEmail) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangePasswordScreen(
          userEmail: userEmail,
          authService: widget.authService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: FutureBuilder<String?>(
        future: _userEmailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Error loading user data'));
          }

          final userEmail = snapshot.data!;

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Welcome to News App',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => _goToChangePassword(userEmail),
                  child: const Text('Change Password'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/models.dart';
import 'home_shell.dart';
import 'onboarding.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool signUp = true;
  final email = TextEditingController();
  final password = TextEditingController();
  
  final social = SocialData(); // Top level data instance for mock UI

  void enterApp() {
    if (signUp) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SwipeOnboardingScreen(data: social)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeShell(data: social)),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 34, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TripNest',
              style: TextStyle(
                fontSize: 29,
                fontWeight: FontWeight.w800,
                color: coral,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 42),
            Text(
              signUp ? 'Plan your next adventure' : 'Welcome back',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              signUp
                  ? 'Create an account and make every trip count.'
                  : 'Sign in to continue planning your trips.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
            const SizedBox(height: 32),
            field('Email address', Icons.mail_outline, email),
            const SizedBox(height: 14),
            field('Password', Icons.lock_outline, password, obscure: true),
            if (signUp) ...[
              const SizedBox(height: 14),
              field('Your name', Icons.person_outline, TextEditingController()),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton(
                onPressed: enterApp,
                style: FilledButton.styleFrom(
                  backgroundColor: coral,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  signUp ? 'Create account' : 'Sign in',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('or', style: TextStyle(color: Colors.grey)),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: enterApp,
                icon: const Text(
                  'G',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                ),
                label: const Text('Continue with Google'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Center(
              child: TextButton(
                onPressed: () => setState(() => signUp = !signUp),
                child: Text(
                  signUp
                      ? 'Already have an account? Sign in'
                      : 'New to TripNest? Create an account',
                  style: const TextStyle(
                    color: coral,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget field(
    String label,
    IconData icon,
    TextEditingController controller, {
    bool obscure = false,
  }) => TextField(
    controller: controller,
    obscureText: obscure,
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: Colors.grey.shade600),
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final username = TextEditingController();
  
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header brand mark
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0F172A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.groups_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'TripNest',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              Text(
                signUp ? 'Plan your next adventure' : 'Welcome back',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                signUp
                    ? 'Create an account and make every trip count.'
                    : 'Sign in to continue planning your trips.',
                style: GoogleFonts.inter(
                  color: const Color(0xFF64748B),
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),
              field('Email address', Icons.mail_outline_rounded, email),
              const SizedBox(height: 14),
              field('Password', Icons.lock_outline_rounded, password, obscure: true),
              if (signUp) ...[
                const SizedBox(height: 14),
                field('Username', Icons.person_outline_rounded, username),
              ],
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: enterApp,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    signUp ? 'Create account' : 'Sign in',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      'or',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF94A3B8),
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                ],
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: enterApp,
                  icon: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      'G',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  label: Text(
                    'Continue with Google',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B),
                      fontSize: 15,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: TextButton(
                  onPressed: () => setState(() => signUp = !signUp),
                  child: Text(
                    signUp
                        ? 'Already have an account? Sign in'
                        : 'New to TripNest? Create an account',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF2563EB),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget field(
    String label,
    IconData icon,
    TextEditingController controller, {
    bool obscure = false,
  }) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.03),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: TextField(
      controller: controller,
      obscureText: obscure,
      style: GoogleFonts.inter(
        fontSize: 15,
        color: const Color(0xFF0F172A),
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 20),
        labelText: label,
        labelStyle: GoogleFonts.inter(
          color: const Color(0xFF64748B),
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF0F172A), width: 1.5),
        ),
      ),
    ),
  );
}


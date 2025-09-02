import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/base/utils/app_routes.dart';

class VerifyEmailView extends StatefulWidget {
  final User? user;
  const VerifyEmailView({super.key, this.user});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Column(
        children: [
          const Text("We've sent you a verification to your email."),
          const Text("If not received any verification yet, click to resend!"),
          ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
              },
              child: const Text("Send email verification")),
          TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.register, (route) => false);
              },
              child: const Text("Restart"))
        ],
      ),
    );
  }
}

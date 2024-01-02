// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ticket_booking/Controller/custom_button.dart';
import 'package:ticket_booking/Controller/custom_textfield.dart';
import 'package:ticket_booking/View/signIn_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController usernameController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: usernameController.text.trim());

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text(
              'Reset password link sent. Please check your email.',
              style: TextStyle(color: Colors.black87),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignInPage()),
                  );
                },
                child: const Text(
                  'Return to Sign In',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text(
              'Invalid Email. Please enter a valid email address.',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Forgot Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Enter your email and we\'ll send you a password reset link',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),
                CustomTextField(
                  hintText: 'Enter email',
                  controller: usernameController,
                ),
                const SizedBox(height: 16.0),
                CustomButton(
                  onPressed: () {
                    passwordReset();
                  },
                  buttonText: 'Reset Password',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

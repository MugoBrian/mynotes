import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/base/utils/app_routes.dart';
import 'package:mynotes/base/utils/show_error_dialog.dart';
import 'dart:developer' as devtools show log;

import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: FutureBuilder(
        // Firebase.initializeApp returns  a Future(promise) - initializes Firebase before any widget is rendered.
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),

        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          // checks the connection of the Firebase.initializeApp async func
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: false,
                    decoration:
                        const InputDecoration(hintText: "Enter your email"),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration:
                        const InputDecoration(hintText: "Enter your password"),
                  ),
                  TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;

                        try {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email, password: password);
                          final user = FirebaseAuth.instance.currentUser;
                          await user?.sendEmailVerification();

                          Navigator.of(context)
                              .pushNamed(AppRoutes.verifyEmail);
                        } on FirebaseAuthException catch (e) {
                          devtools.log(e.message.toString());
                          if (e.code == 'email-already-in-use') {
                            devtools.log(e.message.toString());
                            await showErrorDialog(context, "Weak Password");
                          } else if (e.code == 'invalid-email') {
                            devtools.log(e.message.toString());
                            await showErrorDialog(context, "Weak Password");
                          } else {
                            await showErrorDialog(context, "Error: ${e.code}");
                          }
                        }
                      },
                      child: const Text('Register')),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, AppRoutes.login, (route) => false);
                      },
                      child: const Text("Already have an account? Login here!"))
                ],
              );

            default:
              return const Text('Loading...');
          }
        },
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
                          final userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email, password: password);
                          print(userCredential);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            print(e.message);
                          } else if (e.code == 'email-already-in-use') {
                            print(e.message);
                          } else if (e.code == 'invalid-email') {
                            print(e.message);
                          }
                        }
                      },
                      child: const Text('Register')),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/login", (route) => false);
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

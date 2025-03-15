import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/base/utils/app_routes.dart';
import '../firebase_options.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
                              .signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRoutes.notes,
                            (route) => false,
                          );
                          // log(userCredential);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'invalid-credentials') {
                            devtools.log('Invalid Credentials');
                          }
                          // log(e);
                        } catch (e) {
                          devtools.log("SOMETHING BAD HAPPENED!");
                          devtools.log(e.runtimeType.toString());
                        }
                      },
                      child: const Text('Login')),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, AppRoutes.register, (route) => false);
                      },
                      child: const Text("Not registered yet? Register here!"))
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

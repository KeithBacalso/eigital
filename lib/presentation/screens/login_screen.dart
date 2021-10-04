import 'package:eigital_test/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String route = '/';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  final _facebookAuth = FacebookAuth.instance;
  String _email = "", _password = "";
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Enter Email",
                    ),
                    onChanged: (value) {
                      _email = value;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Enter Password",
                    ),
                    onChanged: (value) {
                      _password = value;
                    },
                  ),
                  const SizedBox(height: 30.0),
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        await _auth.createUserWithEmailAndPassword(
                            email: _email, password: _password);

                        Navigator.of(context).pushNamed(HomeScreen.route);
                        setState(() {
                          _isLoading = false;
                        });
                      } catch (e) {
                        print("EMAIL LOGIN ERROR: $e");
                      }
                    },
                    child: const Text('LOGIN'),
                  ),
                  TextButton(
                    onPressed: () async {
                      try {
                        await _googleSignIn.signIn();
                        Navigator.of(context).pushNamed(HomeScreen.route);
                      } catch (e) {
                        print("GMAIL LOGIN ERROR: $e");
                      }
                    },
                    child: const Text('GMAIL'),
                  ),
                  TextButton(
                    onPressed: () async {
                      try {
                        final result = await _facebookAuth.login();
                        if (result.status == LoginStatus.success) {
                          Navigator.of(context).pushNamed(HomeScreen.route);
                        } else {
                          print("FB AUTH ERROR: ${result.message}");
                        }
                      } catch (e) {
                        print("FACEBOOK LOGIN ERROR: $e");
                      }
                    },
                    child: const Text('FACEBOOK'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

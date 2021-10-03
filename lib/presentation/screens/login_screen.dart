import 'package:eigital_test/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String route = '/';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
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
                        print(e);
                      }
                    },
                    child: const Text('LOGIN'),
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

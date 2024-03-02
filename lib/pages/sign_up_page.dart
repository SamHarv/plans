import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '/services/firestore_service.dart';
import '/widgets/login_field_widget.dart';
import '/constants.dart';
import '/state_management/riverpod_providers.dart';

final _url = Uri.parse('https://oxygentech.com.au');

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signUp(FirestoreService db) async {
    try {
      UserCredential user =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Add user with user ID from Auth to Firestore
      await db.addUser(userID: user.user!.uid);
      showMessage('Account created!');
    } on Exception catch (e) {
      showMessage(e.toString());
    }
  }

  void showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: colour,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.read(database);
    final mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: colour,
      appBar: AppBar(
        title: appTitle,
        backgroundColor: colour,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            child: InkWell(
              child: Image.asset(
                'images/2.png',
                fit: BoxFit.contain,
                height: 24.0,
              ),
              onTap: () => _launchUrl(),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'Sign Up',
                style: headingStyle,
              ),
              gapH20,
              LoginFieldWidget(
                textController: _emailController,
                obscurePassword: false,
                hintText: 'Email',
                mediaWidth: mediaWidth,
              ),
              gapH20,
              LoginFieldWidget(
                textController: _passwordController,
                obscurePassword: true,
                hintText: 'Password',
                mediaWidth: mediaWidth,
              ),
              gapH20,
              SizedBox(
                width: mediaWidth * 0.8,
                height: 60,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.white,
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      },
                    );
                    signUp(db);
                    Future.delayed(
                      const Duration(seconds: 2),
                      () {
                        Navigator.pop(context);
                        Beamer.of(context).beamToNamed('/home');
                      },
                    );
                  },
                  child: const Text(
                    'Go',
                    style: TextStyle(
                      color: colour,
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
              gapH20,
              TextButton(
                onPressed: () {
                  Beamer.of(context).beamToNamed('/sign-in');
                },
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

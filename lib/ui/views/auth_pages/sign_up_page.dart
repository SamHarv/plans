import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repos/firestore_service.dart';
import '../../widgets/login_field_widget.dart';
import '../../widgets/o2_tech_icon.dart';
import '../../../config/constants.dart';
import '../../../logic/providers/riverpod_providers.dart';

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
    final authentication = ref.read(auth);
    final mediaWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: colour,
      appBar: AppBar(
        title: appTitle,
        backgroundColor: colour,
        automaticallyImplyLeading: false,
        actions: [
          O2TechIcon(),
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
                    backgroundColor: WidgetStateProperty.all<Color>(
                      secondaryColour,
                    ),
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: secondaryColour,
                          ),
                        );
                      },
                    );
                    try {
                      await authentication.signUp(
                        db,
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      Beamer.of(context).beamToNamed('/home');
                    } catch (e) {
                      showMessage(e.toString());
                      Future.delayed(
                        const Duration(milliseconds: 3000),
                        () {
                          // Pop dialog
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          // Pop progress indicator
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        },
                      );
                    }
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
                    color: secondaryColour,
                  ),
                ),
              ),
              gapH80,
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plans/services/firestore.dart';

import '../constants.dart';
import '../state_management/riverpod_providers.dart';

class SignUpView extends ConsumerStatefulWidget {
  const SignUpView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  // final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future signUp(FirestoreService db) async {
    try {
      UserCredential user =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // add user with user ID from user
      await db.addUser(userID: user.user!.uid);

      showErrorMessage('Account created!');
    } on Exception catch (e) {
      // print(e);
      showErrorMessage(e.toString());
    }
  }

  void showErrorMessage(String message) {
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
        title: Text(
          'Plans',
          style: GoogleFonts.caveat(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontFamily: 'Caveat',
            ),
          ),
        ),
        backgroundColor: colour,
        automaticallyImplyLeading: false,
        actions: const [
          // Push title to the left
          SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 10,
          ),
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
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: mediaWidth * 0.8,
                height: 60,
                child: TextField(
                  controller: _emailController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(64),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                      ),
                    ),
                    hintText: 'Email',
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                  style: bodyStyle,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: mediaWidth * 0.8,
                height: 60,
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(64),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueGrey),
                    ),
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                  style: bodyStyle,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
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

                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.pop(context);
                      Beamer.of(context).beamToNamed('/home');
                    });
                  },
                  child: const Text(
                    'Go',
                    style:
                        // bodyStyle,
                        TextStyle(
                      color: colour,
                      fontSize: 18,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  Beamer.of(context).beamToNamed('/profile');
                },
                child: const Text(
                  'Log In',
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

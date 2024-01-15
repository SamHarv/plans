import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
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
    // final user = FirebaseAuth.instance.currentUser;

    // final isLoggedIn = ref.read(loggedIn);
    final double mediaWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final bool userLoggedIn = snapshot.hasData;

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
            automaticallyImplyLeading: userLoggedIn ? true : false,
            leading: userLoggedIn
                ? IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // Navigate to home page when built
                      Beamer.of(context).beamToNamed('/home');
                    },
                  )
                : null,
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
              child: userLoggedIn
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Already logged in!',
                          style: headingStyle,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 40,
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
                              FirebaseAuth.instance.signOut();
                            },
                            child: const Text(
                              'Log Out',
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
                          height: 80,
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Log In',
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
                              // Navigate to home page
                              // ref.read(loggedIn.notifier).state = true;

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

                              signIn();
                              Future.delayed(const Duration(seconds: 2), () {
                                Navigator.pop(context);
                                Beamer.of(context).beamToNamed('/home');
                              });
                              // setState(() {});
                              // Beamer.of(context).beamToNamed('/home');
                              // Navigator.pop(context);
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
                            // create log in
                            Beamer.of(context).beamToNamed('/sign-up');
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          onPressed: () {
                            Beamer.of(context).beamToNamed('/forgot-password');
                          },
                          child: const Text(
                            'Forgot Password?',
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
      },
    );
  }
}

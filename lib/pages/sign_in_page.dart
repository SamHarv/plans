import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '/widgets/login_field_widget.dart';
import '/constants.dart';

final _url = Uri.parse('https://oxygentech.com.au');

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
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
    final mediaWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final bool userLoggedIn = snapshot.hasData;
        return Scaffold(
          backgroundColor: colour,
          appBar: AppBar(
            title: appTitle,
            backgroundColor: colour,
            automaticallyImplyLeading: userLoggedIn ? true : false,
            leading: userLoggedIn
                ? IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Beamer.of(context).beamToNamed('/home');
                    },
                  )
                : null,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                child: InkWell(
                  child: Image.asset(
                    // O2Tech logo => navigate to webpage
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
              child: userLoggedIn
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Already signed in!',
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
                              'Sign Out',
                              style: TextStyle(
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
                          'Sign In',
                          style: headingStyle,
                        ),
                        gapH20,
                        LoginFieldWidget(
                          textController: _emailController,
                          obscurePassword: false,
                          hintText: 'Email',
                          mediaWidth: mediaWidth,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
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
                              signIn();
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

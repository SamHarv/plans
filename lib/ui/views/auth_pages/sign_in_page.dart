import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../logic/providers/riverpod_providers.dart';
import '../../widgets/login_field_widget.dart';
import '../..//widgets/o2_tech_icon.dart';
import '../../../config/constants.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.sizeOf(context).width;
    final authentication = ref.read(auth);
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final userLoggedIn = snapshot.hasData;
        return Scaffold(
          backgroundColor: colour,
          appBar: AppBar(
            centerTitle: false,
            title: appTitle,
            backgroundColor: colour,
            automaticallyImplyLeading: userLoggedIn ? true : false,
            leading: userLoggedIn
                ? IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () => Beamer.of(context).beamToNamed('/home'),
                  )
                : null,
            actions: [
              O2TechIcon(),
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
                              backgroundColor: WidgetStateProperty.all<Color>(
                                secondaryColour,
                              ),
                            ),
                            onPressed: () => authentication.signOut(),
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
                        gapH20,
                        TextButton(
                          onPressed: () {
                            // delete account
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: colour,
                                  title: const Text(
                                    'Are you sure you want to delete your account?',
                                    style: TextStyle(
                                      color: secondaryColour,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: secondaryColour,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
                                        try {
                                          authentication.deleteAccount();
                                        } catch (e) {
                                          // ignore: use_build_context_synchronously
                                          showMessage(e.toString(), context);
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
                                        'Delete',
                                        style: TextStyle(
                                          color: secondaryColour,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text(
                            'Delete Account',
                            style: TextStyle(
                              color: secondaryColour,
                            ),
                          ),
                        ),
                        gapH80,
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
                                await authentication.signIn(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                );
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                                // ignore: use_build_context_synchronously
                                Beamer.of(context).beamToNamed('/home');
                              } catch (e) {
                                // ignore: use_build_context_synchronously
                                showMessage(e.toString(), context);
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
                          onPressed: () =>
                              Beamer.of(context).beamToNamed('/sign-up'),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: secondaryColour,
                            ),
                          ),
                        ),
                        gapH20,
                        TextButton(
                          onPressed: () {
                            Beamer.of(context).beamToNamed('/forgot-password');
                          },
                          child: const Text(
                            'Forgot Password?',
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
      },
    );
  }
}

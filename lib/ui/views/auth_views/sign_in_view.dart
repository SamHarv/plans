import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../logic/providers/providers.dart';
import '../../widgets/auth_field_widget.dart';
import '../../widgets/o2_tech_icon_widget.dart';
import '../../../config/constants.dart';

class SignInView extends ConsumerStatefulWidget {
  /// UI for signing in

  const SignInView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInViewState();
}

class _SignInViewState extends ConsumerState<SignInView> {
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

    /// Stream to monitor whether logged in
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
            // Back button if logged in to return home
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
              O2TechIconWidget(), // Launch O2Tech website
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
                                        // Pop progress indicator
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
                                        try {
                                          // Sign in page will rebuild without
                                          // user logged in
                                          authentication.deleteAccount();
                                        } catch (e) {
                                          // Show error for 3 seconds
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
                        AuthFieldWidget(
                          textController: _emailController,
                          obscurePassword: false,
                          hintText: 'Email',
                          mediaWidth: mediaWidth,
                        ),
                        gapH20,
                        AuthFieldWidget(
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
                              // Show progress indicator
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
                                // Sign in
                                await authentication.signIn(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                );
                                // Pop progress indicator
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                                // ignore: use_build_context_synchronously
                                Beamer.of(context).beamToNamed('/home');
                              } catch (e) {
                                // Show error for 3 seconds
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
                          onPressed: () => Beamer.of(context)
                              .beamToNamed('/forgot-password'),
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

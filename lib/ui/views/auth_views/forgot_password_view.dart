import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/auth_field_widget.dart';
import '../../widgets/o2_tech_icon_widget.dart';
import '../../../logic/providers/providers.dart';
import '../../../config/constants.dart';

class ForgotPasswordView extends ConsumerStatefulWidget {
  /// UI for resetting password

  const ForgotPasswordView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgotPasswordPageWidgetState();
}

class _ForgotPasswordPageWidgetState extends ConsumerState<ForgotPasswordView> {
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
    final authentication = ref.read(auth);
    final mediaWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: colour,
      appBar: AppBar(
        title: appTitle,
        centerTitle: false,
        backgroundColor: colour,
        automaticallyImplyLeading: false,
        actions: [
          O2TechIconWidget(), // Launch O2Tech website
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'Receive an email to\nreset your password',
                style: headingStyle,
                textAlign: TextAlign.center,
              ),
              gapH20,
              // Enter email
              AuthFieldWidget(
                textController: _emailController,
                obscurePassword: false,
                hintText: 'Email',
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
                      builder: (context) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: secondaryColour,
                          ),
                        );
                      },
                    );
                    try {
                      // Reset password
                      await authentication.resetPassword(
                        _emailController.text.trim(),
                      );
                      // Pop loading dialog
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      showMessage('Email Sent!', context);
                      Future.delayed(
                        const Duration(milliseconds: 1000),
                        () {
                          // Beam to sign in page after dialog is read
                          // ignore: use_build_context_synchronously
                          Beamer.of(context).beamToNamed('/sign-in');
                        },
                      );
                    } catch (e) {
                      // ignore: use_build_context_synchronously
                      showMessage(e.toString(), context);
                      // Allow time to read dialog
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
                onPressed: () => Beamer.of(context).beamToNamed('/sign-in'),
                child: const Text(
                  'Sign In',
                  style: TextStyle(color: secondaryColour),
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

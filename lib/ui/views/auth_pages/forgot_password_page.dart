import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/ui/widgets/login_field_widget.dart';
import '/ui/widgets/o2_tech_icon.dart';
import '../../../logic/providers/riverpod_providers.dart';
import '../../../config/constants.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgotPasswordPageWidgetState();
}

class _ForgotPasswordPageWidgetState extends ConsumerState<ForgotPasswordPage> {
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
          O2TechIcon(),
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
              LoginFieldWidget(
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
                      await authentication.resetPassword(
                        _emailController.text.trim(),
                      );
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      showMessage('Email Sent!', context);
                      Future.delayed(
                        const Duration(milliseconds: 1000),
                        () {
                          // ignore: use_build_context_synchronously
                          Beamer.of(context).beamToNamed('/sign-in');
                        },
                      );
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

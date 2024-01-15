import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends ConsumerState<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      showErrorMessage('Email Sent!');
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
    final mediaWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // final bool userLoggedIn = snapshot.hasData;

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
            // leading: userLoggedIn
            //     ? IconButton(
            //         icon: const Icon(
            //           Icons.arrow_back,
            //           color: Colors.white,
            //         ),
            //         onPressed: () {
            //           // Navigate to home page when built
            //           Beamer.of(context).beamToNamed('/home');
            //         },
            //       )
            //     : null,
            actions: const [
              // Push title to the left
              SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 10,
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              //   child: InkWell(
              //     child: Image.asset(
              //       // O2Tech logo => navigate to webpage
              //       'images/1.png',
              //       fit: BoxFit.contain,
              //       height: 24.0,
              //     ),
              //     onTap: () => _launchUrl(),
              //   ),
              // ),
            ],
          ),
          body: Center(
            child: SingleChildScrollView(
              child:
                  // userLoggedIn
                  //     ? Column(
                  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //         children: [
                  //           const Text(
                  //             'Someone is logged in!',
                  //             style: headingStyle,
                  //             textAlign: TextAlign.center,
                  //           ),
                  //           const SizedBox(
                  //             height: 40,
                  //           ),
                  //           SizedBox(
                  //             width: mediaWidth * 0.8,
                  //             height: 60,
                  //             child: ElevatedButton(
                  //               style: ButtonStyle(
                  //                 backgroundColor: MaterialStateProperty.all<Color>(
                  //                   Colors.white,
                  //                 ),
                  //               ),
                  //               onPressed: () {
                  //                 FirebaseAuth.instance.signOut();
                  //               },
                  //               child: const Text(
                  //                 'Log Out',
                  //                 style:
                  //                     // bodyStyle,
                  //                     TextStyle(
                  //                   color: colour,
                  //                   fontSize: 18,
                  //                   fontFamily: 'Roboto',
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //           const SizedBox(
                  //             height: 80,
                  //           ),
                  //         ],
                  //       )
                  // :
                  Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Receive an email to\nreset your password',
                      style: headingStyle,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: mediaWidth * 0.8,
                      height: 60,
                      child: TextFormField(
                        controller: _emailController,
                        textInputAction: TextInputAction.next,
                        // validator: (email) => email != null &&
                        //         !EmailValidator.validate(email)
                        //     ? 'Please enter vaild email'
                        //     : null,
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
                    // SizedBox(
                    //   width: mediaWidth * 0.8,
                    //   height: 60,
                    //   child: TextFormField(
                    //     controller: _passwordController,
                    //     obscureText: true,
                    //     textInputAction: TextInputAction.next,
                    //     // validator: (value) =>
                    //     //     value != null && value.length < 6
                    //     //         ? 'Enter min. 6 characters'
                    //     //         : null,
                    //     decoration: InputDecoration(
                    //       border: const OutlineInputBorder(
                    //         borderSide: BorderSide(
                    //           color: Colors.blueGrey,
                    //         ),
                    //         borderRadius: BorderRadius.all(
                    //           Radius.circular(64),
                    //         ),
                    //       ),
                    //       focusedBorder: const OutlineInputBorder(
                    //         borderSide:
                    //             BorderSide(color: Colors.blueGrey),
                    //       ),
                    //       hintText: 'Password',
                    //       hintStyle: TextStyle(
                    //         color: Colors.grey[500],
                    //       ),
                    //     ),
                    //     style: bodyStyle,
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
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
                          resetPassword();

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
          ),
        );
      },
    );
  }
}

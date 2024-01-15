// import 'package:beamer/beamer.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:plans/pages/home_page.dart';
// import 'package:plans/pages/profile_view.dart';

// class AuthenticationCheck extends StatelessWidget {
//   const AuthenticationCheck({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return const Center(child: Text('Something went wrong!'));
//         } else if (snapshot.hasData) {
//           // Beamer.of(context).beamToNamed('/home');
//           return const HomePage();
//         } else {
//           // Beamer.of(context).beamToNamed('/auth');
//           return const ProfileView();
//         }
//       },
//     );
//   }
// }

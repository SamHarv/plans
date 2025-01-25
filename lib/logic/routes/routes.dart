import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';
import '../../ui/views/auth_pages/sign_up_page.dart';
import '../../ui/views/auth_pages/forgot_password_page.dart';
import '../../ui/views/auth_pages/sign_in_page.dart';
import '../../ui/views/home_page.dart';
import '../../ui/views/task_page.dart';

/// Instance of [user] from [FirebaseAuth] to determine whether logged in
final user = FirebaseAuth.instance.currentUser;

final routerDelegate = BeamerDelegate(
  // Go to sign-in page if user is not logged in
  notFoundRedirectNamed: user == null ? '/sign-in' : '/home',
  initialPath: user == null ? '/sign-in' : '/home',
  locationBuilder: RoutesLocationBuilder(
    routes: {
      '/home': (context, state, data) {
        return const BeamPage(
          key: ValueKey('home'),
          type: BeamPageType.fadeTransition,
          title: 'Plans',
          child: HomePage(),
        );
      },
      '/task-page': (context, state, data) {
        return BeamPage(
          key: const ValueKey('task-page'),
          type: BeamPageType.fadeTransition,
          title: '$data.taskHeading',
          child: TaskPage(task: data as Task, taskID: data.taskID),
        );
      },
      '/sign-in': (context, state, data) {
        return const BeamPage(
          key: ValueKey('sign-in'),
          type: BeamPageType.fadeTransition,
          title: 'Sign In - Plans',
          child: SignInPage(),
        );
      },
      '/sign-up': (context, state, data) {
        return const BeamPage(
          key: ValueKey('sign-up'),
          type: BeamPageType.fadeTransition,
          title: 'Sign Up - Plans',
          child: SignUpPage(),
        );
      },
      '/forgot-password': (context, state, data) {
        return const BeamPage(
          key: ValueKey('forgot-password'),
          type: BeamPageType.fadeTransition,
          title: 'Forgot Password - Plans',
          child: ForgotPasswordPage(),
        );
      },
    },
  ).call,
);

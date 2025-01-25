import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';
import '../../ui/views/auth_views/sign_up_view.dart';
import '../../ui/views/auth_views/forgot_password_view.dart';
import '../../ui/views/auth_views/sign_in_view.dart';
import '../../ui/views/home_view.dart';
import '../../ui/views/task_view.dart';

/// Instance of [user] from [FirebaseAuth] to determine whether logged in
final user = FirebaseAuth.instance.currentUser;

final routerDelegate = BeamerDelegate(
  // Go to sign-in page if user is not logged in
  notFoundRedirectNamed: user == null ? '/sign-in' : '/home',
  initialPath: user == null ? '/sign-in' : '/home',
  locationBuilder: RoutesLocationBuilder(
    routes: {
      /// Home page
      '/home': (context, state, data) {
        return const BeamPage(
          key: ValueKey('home'),
          type: BeamPageType.fadeTransition,
          title: 'Plans',
          child: HomeView(),
        );
      },

      /// Task input/ display page
      '/task-page': (context, state, data) {
        return BeamPage(
          key: const ValueKey('task-page'),
          type: BeamPageType.fadeTransition,
          title: '$data.taskHeading',
          child: TaskView(task: data as Task, taskID: data.taskID),
        );
      },

      /// Sign in page
      '/sign-in': (context, state, data) {
        return const BeamPage(
          key: ValueKey('sign-in'),
          type: BeamPageType.fadeTransition,
          title: 'Sign In - Plans',
          child: SignInView(),
        );
      },

      /// Sign up page
      '/sign-up': (context, state, data) {
        return const BeamPage(
          key: ValueKey('sign-up'),
          type: BeamPageType.fadeTransition,
          title: 'Sign Up - Plans',
          child: SignUpView(),
        );
      },

      /// Forgot password page
      '/forgot-password': (context, state, data) {
        return const BeamPage(
          key: ValueKey('forgot-password'),
          type: BeamPageType.fadeTransition,
          title: 'Forgot Password - Plans',
          child: ForgotPasswordView(),
        );
      },
    },
  ).call,
);

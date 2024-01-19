import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

import 'models/task_model.dart';

import 'pages/sign_up_page.dart';
import 'pages/forgot_password_page.dart';
import 'pages/sign_in_page.dart';
import 'pages/home_page.dart';
import 'pages/task_page.dart';

final routerDelegate = BeamerDelegate(
  notFoundRedirectNamed: '/home',
  initialPath: '/home',
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
          // Carry task to RaskView
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
  ),
);

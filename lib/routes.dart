import 'package:beamer/beamer.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plans/pages/sign_up_view.dart';
// import 'package:plans/pages/check_auth.dart';

import 'models/task.dart';
// import 'pages/check_auth.dart';
import 'pages/forgot_password.dart';
import 'pages/profile_view.dart';
import 'pages/home_page.dart';
import 'pages/subtask_view.dart';
import 'pages/task_view.dart';

final routerDelegate = BeamerDelegate(
  notFoundRedirectNamed: '/home',
  initialPath: '/home',
  locationBuilder: RoutesLocationBuilder(
    routes: {
      // '/auth': (context, state, data) {
      //   return const BeamPage(
      //     key: ValueKey('auth'),
      //     type: BeamPageType.fadeTransition,
      //     title: 'Plans',
      //     child: AuthenticationCheck(),
      //   );
      // },
      '/home': (context, state, data) {
        return const BeamPage(
          key: ValueKey('home'),
          type: BeamPageType.fadeTransition,
          title: 'Plans',
          child: HomePage(),
        );
      },
      '/task-view': (context, state, data) {
        return BeamPage(
          key: const ValueKey('task-view'),
          type: BeamPageType.fadeTransition,
          title: '$data.taskHeading',
          // Carry task to RaskView
          child: TaskView(task: data as Task, taskID: data.taskID),
        );
      },

      '/subtask-view': (context, state, data) {
        return const BeamPage(
          key: ValueKey('subtask-view'),
          type: BeamPageType.fadeTransition,
          title: 'Subtask View',
          child: SubtaskView(),
        );
      },
      '/profile': (context, state, data) {
        return const BeamPage(
          key: ValueKey('profile'),
          type: BeamPageType.fadeTransition,
          title: 'Profile - Plans',
          child: ProfileView(),
        );
      },
      '/sign-up': (context, state, data) {
        return const BeamPage(
          key: ValueKey('sign-up'),
          type: BeamPageType.fadeTransition,
          title: 'Sign Up - Plans',
          child: SignUpView(),
        );
      },
      '/forgot-password': (context, state, data) {
        return const BeamPage(
          key: ValueKey('forgot-password'),
          type: BeamPageType.fadeTransition,
          title: 'Forgot Password - Plans',
          child: ForgotPassword(),
        );
      },
      // '/about': (context, state, data) {
      //   return const BeamPage(
      //     key: ValueKey('about'),
      //     type: BeamPageType.fadeTransition,
      //     title: 'About - HF App',
      //     child: About(),
      //   );
      // },
      // '/contact': (context, state, data) {
      //   return const BeamPage(
      //     key: ValueKey('contact'),
      //     type: BeamPageType.fadeTransition,
      //     title: 'Contact - HF App',
      //     child: Contact(),
      //   );
      // },
      // '/settings': (context, state, data) {
      //   return const BeamPage(
      //     key: ValueKey('settings'),
      //     type: BeamPageType.fadeTransition,
      //     title: 'Settings - HF App',
      //     child: Settings(),
      //   );
      // },
    },
  ),
);

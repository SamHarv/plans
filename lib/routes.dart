import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:plans/models/task.dart';

import 'pages/home_page.dart';
import 'pages/subtask_view.dart';
import 'pages/task_view.dart';

final routerDelegate = BeamerDelegate(
  notFoundRedirectNamed: '/',
  initialPath: '/',
  locationBuilder: RoutesLocationBuilder(
    routes: {
      '/': (context, state, data) {
        return const BeamPage(
          key: ValueKey(''),
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
      // '/profile': (context, state, data) {
      //   return const BeamPage(
      //     key: ValueKey('profile'),
      //     type: BeamPageType.fadeTransition,
      //     title: 'Profile - Plans',
      //     child: Profile(),
      //   );
      // },
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

      // '/article/:id': (context, state, data) {
      //   final postId = state.pathParameters['id'];
      //   final post = postData.firstWhere((post) => post.id == postId);
      //   return BeamPage(
      //     key: ValueKey('article-$postId'),
      //     type: BeamPageType.fadeTransition,
      //     title: post.title,
      //     child: ArticlePage(post: post, id: postId!),
      //   );
      // },
    },
  ),
);

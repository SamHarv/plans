import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';

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
        return const BeamPage(
          key: ValueKey('task-view'),
          type: BeamPageType.fadeTransition,
          title: 'Task View',
          child: TaskView(),
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

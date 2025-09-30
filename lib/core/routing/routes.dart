import 'package:flutter/material.dart';
import 'package:perfect/models/course_model.dart';
import 'package:perfect/screens/course_list_screen.dart';
import 'package:perfect/screens/course_video_player_screen.dart';
import 'package:perfect/screens/home_page.dart';
import 'package:perfect/screens/profile_completion_page.dart';
import 'package:perfect/screens/screens_exports.dart';
import 'package:perfect/screens/sign_in_page.dart';
import 'package:perfect/screens/sign_up_page.dart';

class AppRoutess {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _buildRoute(SplashScreen(), settings);
      case '/homepage':
        return _buildRoute(NavigationMenuWrapper(), settings);
      case '/signup':
        return _buildRoute(SignUpScreen(), settings);
      case '/signIn':
        return _buildRoute(SignInScreen(), settings);
      case '/profilecompletion':
        return _buildRoute(ProfileCompletionPage(), settings);
      case '/courses':
        return _buildRoute(CoursesListView(), settings);
      case '/coursevideoplayer':
        final args = settings.arguments;
        if (args is Course) {
          return _buildRoute(
            CourseVideoPlayerScreen(course: args),
            settings,
          );
        }
        return _buildRoute(
          Scaffold(body: Center(child: Text("Invalid course data passed"))),
          settings,
        );

      default:
        return _buildRoute(
            Scaffold(
              body: Center(
                child: Text("Page not found"),
              ),
            ),
            settings);
    }
  }

  static PageRouteBuilder _buildRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Right to Left
        const end = Offset.zero;
        const reverseBegin = Offset(-1.0, 0.0); // Left to Right on Pop
        const curve = Curves.ease;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final reverseTween = Tween(begin: end, end: reverseBegin)
            .chain(CurveTween(curve: curve));

        final offsetAnimation = animation.drive(tween);
        final reverseOffsetAnimation = secondaryAnimation.drive(reverseTween);

        return SlideTransition(
          position: offsetAnimation,
          child: SlideTransition(
            position: reverseOffsetAnimation,
            child: child,
          ),
        );
      },
    );
  }
}

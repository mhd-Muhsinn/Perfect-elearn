import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:iconly/iconly.dart';
import 'package:perfect/blocs/auth/auth_bloc.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/cubits/nav_bar_cubit.dart';
import 'package:perfect/screens/course_list_screen.dart';
import 'package:perfect/screens/daily_task_page.dart';
import 'package:perfect/screens/home_page.dart';
import 'package:perfect/screens/chat/inbox_page.dart';
import 'package:perfect/screens/my_courses_page.dart';
import 'package:perfect/screens/profile_page.dart';

class NavigationMenuWrapper extends StatelessWidget {
  const NavigationMenuWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => NavBarCubit(), child: NavigationMenu());
  }
}

class NavigationMenu extends StatelessWidget {
  NavigationMenu({super.key});

  final screens = [
    HomePageWrapper(),
    CoursesListView(),
    InboxPage(),
    DailyTaskPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const Icon(
        IconlyLight.home,
        size: 30,
        color: PColors.white,
      ),
      const Icon(Icons.menu_book, size: 30, color: PColors.white),
      const Icon(IconlyLight.chat, size: 30, color: PColors.white),
      const Icon(Icons.pending_actions, size: 30, color: PColors.white),
      const Icon(IconlyLight.profile, size: 30, color: PColors.white),
    ];

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/signup',
          (Route<dynamic> route) => false,
        );
      },
      child: Scaffold(
        extendBody: true,
        body: BlocBuilder<NavBarCubit, int>(
          builder: (context, index) {
            return IndexedStack(
              index: index,
              children: screens,
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<NavBarCubit, int>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, index) {
            return CurvedNavigationBar(
              index: index,
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 300),
              buttonBackgroundColor: PColors.primary,
              backgroundColor: Colors.transparent,
              color: PColors.primary,
              items: items,
              onTap: (newIndex) {
                context.read<NavBarCubit>().updateIndex(newIndex);
              },
            );
          },
        ),
      ),
    );
  }
}

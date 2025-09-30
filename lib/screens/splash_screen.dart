import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect/blocs/auth/auth_bloc.dart';
import 'package:perfect/core/constants/colors.dart';
import 'package:perfect/widgets/app_logo.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushNamedAndRemoveUntil(context, '/homepage',(route) => false,);
          } else if (state is UnAuthenticated) {
            Navigator.pushNamedAndRemoveUntil(context, '/signup',(route) => false,);
          }
        },
        child: Scaffold(
            backgroundColor: PColors.backgrndPrimary,
            body: Center(child: AppLogo())));
  }
}

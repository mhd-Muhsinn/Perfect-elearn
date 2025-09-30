import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perfect/blocs/auth/auth_bloc.dart';
import 'package:perfect/cubits/cubit/course_list_cubit.dart';
import 'package:perfect/cubits/cubit/cubit/course_selection_cubit.dart';
import 'package:perfect/cubits/cubit/my_libraby_cubit.dart';
import 'package:perfect/firebase_options.dart';
import 'package:perfect/core/routing/routes.dart';
import 'package:perfect/repositories/auth_repository.dart';
import 'package:perfect/repositories/course_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final authrepository = AuthRepository();
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=>MyLibraryCubit()),
        BlocProvider(
            create: (_) =>
                AuthBloc(authrepository)..add(CheckLoginStatusEvent())),
        BlocProvider(
            create: (context) => CourseSelectionCubit(),
          ),
          
      ],
      child: RepositoryProvider(
        create: (context) => CoursesRepository(),
        child: BlocProvider(
        create: (context) =>
            CourseListCubit(context.read<CoursesRepository>())..loadCourses(),
       child: MyApp(), 
      )
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: MaterialApp(
        title: "Perfect",
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: AppRoutess.onGenerateRoute,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_app/logic/blocs/auth/auth_bloc.dart';
import 'package:recipe_app/logic/repositories/auth_repository.dart';
import 'package:recipe_app/logic/services/auth_service.dart';
import 'package:recipe_app/ui/screens/splash/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
         BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
              authRepository: AuthRepository(authService: AuthService())),
        ),
      ],
      child: MaterialApp(
        home: WelcomePage(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          textTheme: GoogleFonts.dmSansTextTheme(),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          textTheme: GoogleFonts.dmSansTextTheme(),
        ),
        themeMode: ThemeMode.system,
      ),
    );
  }
}

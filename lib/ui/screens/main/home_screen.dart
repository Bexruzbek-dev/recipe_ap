import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/logic/blocs/auth/auth_bloc.dart';
import 'package:recipe_app/logic/blocs/auth/auth_event.dart';
import 'package:recipe_app/logic/blocs/auth/auth_state.dart';
import 'package:recipe_app/logic/services/auth_service.dart';
import 'package:recipe_app/ui/screens/auth/login_screen.dart';
import 'package:recipe_app/ui/screens/main/edit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final authService = AuthService();
  String? username;
  String? photo;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final data = await authService.getCurrentUser();

    setState(() {
      username = data['data']['name'];
      photo = data['data']['photo'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } else if (state is AuthLoading) {
          showDialog(
              context: context,
              builder: (ctx) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Home Screen"),
          actions: [
            IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(LogoutEvent());
              },
              icon: Icon(
                Icons.logout,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) {
                      return EditProfileScreen();
                    },
                  ),
                );
              },
              icon: Icon(
                Icons.settings,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Center(
              child: Image.network(
                  loadingBuilder: (context, child, loadingProgress) {
                return loadingProgress != null
                    ? CircularProgressIndicator()
                    : child;
              },
                  photo == null
                      ? "https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg"
                      : 'http://recipe.flutterwithakmaljon.uz/storage/avatars/$photo'),
            ),
            Center(
              child: username == null
                  ? const CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(username ?? "No User"),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

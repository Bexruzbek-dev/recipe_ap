import 'package:recipe_app/logic/services/auth_service.dart';

class AuthRepository {
  final AuthService authService;

  AuthRepository({required this.authService});

  Future registerUser(
    String name,
    String phone,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    return await authService.registerUser(
      name,
      phone,
      email,
      password,
      passwordConfirmation,
    );
  }

  Future<bool> isLoggedIn() async {
    return authService.isLoggedIn();
  }

  Future loginUser(
    String email,
    String password,
  ) async {
    return await authService.loginUser(
      email,
      password,
    );
  }

  Future<void> logout() async {
    try {
      authService.logout();
    } catch (e) {
      // Handle error, rethrow if necessary
      throw Exception('Logout failed: $e');
    }
  }
}

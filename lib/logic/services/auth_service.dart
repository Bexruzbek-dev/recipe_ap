import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future registerUser(
    String name,
    String phone,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    try {
      const url = 'http://recipe.flutterwithakmaljon.uz/api/register';
      final _dio = Dio();
      final Map<String, dynamic> data = {
        "name": name,
        "phone": phone,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation
      };
      print(data);
      final response = await _dio.post(url, data: data);
      if (response.statusCode == 200) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setString(
            'userToken', response.data['data']['token']);
      }
      return response.data;
    } on DioException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  Future loginUser(
    String email,
    String password,
  ) async {
    try {
      const url = 'http://recipe.flutterwithakmaljon.uz/api/login';
      final _dio = Dio();
      final Map<String, dynamic> data = {
        "email": email,
        "password": password,
      };

      final response = await _dio.post(url, data: data);

      if (response.statusCode == 200) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setString(
            'userToken', response.data['data']['token']);

        return response.data;
      }
    } on DioException catch (e) {
      print('diodan ${e.response!.data}');
    } catch (e) {
      print(e);
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userData = sharedPreferences.getString('userToken');
      if (userData == null) return false;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.remove('userToken');
    } catch (e) {
      // Handle error, rethrow if necessary
      throw Exception('Logout failed: $e');
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userData = sharedPreferences.getString('userToken');
      const url = 'http://recipe.flutterwithakmaljon.uz/api/user';
      final _dio = Dio();
      final response = await _dio.get(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $userData'},
        ),
      );

      return response.data;
    } on DioException catch (e) {
      print('diodan ${e.response!.data}');
    } catch (e) {
      print(e);
    }
    return {};
  }
}

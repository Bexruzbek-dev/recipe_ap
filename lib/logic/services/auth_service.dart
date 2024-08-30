import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio(); // Initialize Dio directly

  AuthService() {
    _dio.options.baseUrl = 'http://recipe.flutterwithakmaljon.uz/api';
  }

  Future registerUser(
    String name,
    String phone,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    try {
      const url = '/register';
      final Map<String, dynamic> data = {
        "name": name,
        "phone": phone,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation
      };
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
      const url = '/login';
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
      return userData != null;
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
      throw Exception('Logout failed: $e');
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userData = sharedPreferences.getString('userToken');
      const url = '/user';
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

  Future<void> updateProfile({
    required String name,
    File? photo, // Optional: If you want to update the profile picture
  }) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? userToken = sharedPreferences.getString('userToken');

      print(userToken);
      // Create FormData to send in the request
      FormData formData = FormData.fromMap({
        'name': name,
        if (photo != null)
          'photo': MultipartFile.fromBytes(
            photo.readAsBytesSync(),
            filename: 'avatar.jpg',
          ),
      });

      final response = await _dio.post(
        '/profile/update',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $userToken',
          },
        ),
      );
      print(response.data);
      if (response.statusCode == 200) {
        print('Profile updated successfully');
      } else {
        print('Failed to update profile: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('Error updating profile: ${e.response?.data ?? e.message}');
    } catch (e) {
      print(e);
    }
  }
}

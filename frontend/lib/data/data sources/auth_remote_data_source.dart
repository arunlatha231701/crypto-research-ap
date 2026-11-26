
import 'package:frontend/core/network/api_endpoints.dart';
import 'package:frontend/core/network/api_service.dart';
import 'package:frontend/data/models/auth_session_model.dart';
import 'package:frontend/domain/entity/auth_user_entity.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._apiService);

  final ApiService _apiService;

  Future<AuthSessionModel> login({
    required String username,
    required String password,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.login,
      data: {
        'username': username.trim(),
        'password': password,
      },
    );

    final responseData = response.data;

    if (responseData is! Map) {
      throw const FormatException('Invalid login response.');
    }

    final json = Map<String, dynamic>.from(responseData);

    if (json['success'] != true) {
      throw Exception(
        json['message']?.toString() ?? 'Login failed.',
      );
    }

    final data = json['data'];

    if (data is! Map) {
      throw const FormatException('Invalid login data.');
    }

    return AuthSessionModel.fromJson(
      Map<String, dynamic>.from(data),
    );
  }

  Future<AuthUser> getProfile() async {
    final response = await _apiService.get(
      ApiEndpoints.profile,
    );

    final responseData = response.data;

    if (responseData is! Map) {
      throw const FormatException('Invalid profile response.');
    }

    final json = Map<String, dynamic>.from(responseData);

    if (json['success'] != true) {
      throw Exception(
        json['message']?.toString() ??
            'Unable to restore user session.',
      );
    }

    final data = json['data'];

    if (data is! Map || data['user'] is! Map) {
      throw const FormatException('Invalid profile data.');
    }

    final user = Map<String, dynamic>.from(data['user']);

    final id = int.tryParse(user['id'].toString());

    if (id == null) {
      throw const FormatException('Invalid user ID.');
    }

    return AuthUser(
      id: id,
      username: user['username']?.toString() ?? '',
      email: user['email']?.toString() ?? '',
    );
  }
}

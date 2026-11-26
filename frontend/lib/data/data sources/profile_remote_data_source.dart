
import 'package:frontend/core/network/api_endpoints.dart';
import 'package:frontend/core/network/api_service.dart';

class ProfileRemoteDataSource {
  const ProfileRemoteDataSource(this._apiService);

  final ApiService _apiService;

  Future<Map<String, dynamic>> changeUsername(
      String username,
      ) async {
    final response = await _apiService.patch(
      ApiEndpoints.changeUsername,
      data: {'username': username},
    );

    final data = _parseResponse(response.data);
    final user = data['user'];

    if (user is! Map<String, dynamic>) {
      throw const FormatException('User details missing in response.');
    }

    return user;
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.changePassword,
      data: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      },
    );

    _parseResponse(response.data);
  }

  Map<String, dynamic> _parseResponse(dynamic response) {
    if (response is! Map<String, dynamic> ||
        response['success'] != true) {
      throw const FormatException('Invalid server response.');
    }

    final data = response['data'];

    if (data == null) return {};
    if (data is Map<String, dynamic>) return data;

    throw const FormatException('Invalid response data.');
  }
}

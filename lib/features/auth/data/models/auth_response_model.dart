import '../../../../shared/models/user_model.dart';

class AuthResponseModel {
  final String token;
  final String tokenType;
  final UserModel user;
  final String? message;

  const AuthResponseModel({
    required this.token,
    this.tokenType = 'Bearer',
    required this.user,
    this.message,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    // Check if token is directly at root or inside data
    String token = '';
    if (json['token'] != null) {
      token = json['token'].toString();
    } else if (json['access_token'] != null) {
      token = json['access_token'].toString();
    } else if (json['data'] is Map && json['data']['token'] != null) {
      token = json['data']['token'].toString();
    } else if (json['data'] is Map && json['data']['access_token'] != null) {
      token = json['data']['access_token'].toString();
    }

    final tokenType = json['token_type']?.toString() ?? 'Bearer';
    final message = json['message']?.toString();

    // User model extraction
    Map<String, dynamic> userMap = {};
    if (json['user'] is Map<String, dynamic>) {
      userMap = json['user'] as Map<String, dynamic>;
    } else if (json['data'] is Map<String, dynamic>) {
      final data = json['data'] as Map<String, dynamic>;
      if (data['user'] is Map<String, dynamic>) {
        userMap = data['user'] as Map<String, dynamic>;
      } else {
        userMap = data;
      }
    } else {
      userMap = json;
    }

    final user = UserModel.fromJson(userMap);

    return AuthResponseModel(
      token: token,
      tokenType: tokenType,
      user: user,
      message: message,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'token_type': tokenType,
      'user': user.toJson(),
      'message': message,
    };
  }
}

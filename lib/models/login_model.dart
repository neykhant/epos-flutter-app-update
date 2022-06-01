class LoginModel {
  final String username;
  final String? email;
  final String? accessToken;

  LoginModel({
    required this.username,
    this.accessToken,
    this.email,
  });
}

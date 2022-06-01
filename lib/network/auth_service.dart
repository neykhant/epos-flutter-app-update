import 'package:dio/dio.dart';
import '../models/login_model.dart';
import 'api_service.dart';
import '../token.dart';

class AuthService {
  static login(Map<String, String> data) async {
    try {
      Response response =
          await APIService.getApiHandler().post("io-login", data: data);

      if (response.statusCode == 200) {
        var result = response.data;
        await Token.saveToken(result['data']['access_token']);
        return LoginModel(
          username: result['data']['username'],
          accessToken: result['data']['access_token'],
        );
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static getUser() async {
    try {
      String? token = await Token.getToken();
      Response response =
          await APIService.getApiHandler(token: token ?? '').get('user');

      if (response.statusCode == 200) {
        var result = response.data;

        return LoginModel(
          username: result['data']['username'],
        );
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }
}

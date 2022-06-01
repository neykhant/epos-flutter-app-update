import 'package:dio/dio.dart';

import '../models/credit_model.dart';
import '../token.dart';
import 'api_service.dart';

class CreditService {
  static CreditModel _getObject(Map<String, dynamic> data) {
    return CreditModel(
      id: data['id'],
      amount: int.parse(data['amount']),
      createdAt: data['created_at'],
    );
  }

  static postCredit(Map<String, dynamic> data) async {
    print(data);
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .post('credits', data: data);

      if (response.statusCode == 201) {
        var data = response.data;

        return _getObject(data['data']);
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static postBuyCredit(Map<String, dynamic> data) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .post('buy-credits', data: data);

      if (response.statusCode == 201) {
        var data = response.data;

        return _getObject(data['data']);
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static deleteCredit(int id) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .delete('credits/$id');

      if (response.statusCode == 204) {
        return response.statusCode;
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static deleteBuyCredit(int id) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .delete('buy-credits/$id');

      if (response.statusCode == 204) {
        return response.statusCode;
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }
}

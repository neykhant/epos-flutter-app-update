import 'package:dio/dio.dart';

import '../models/shop_model.dart';
import '../token.dart';
import 'api_service.dart';

class ShopService {
  static ShopModel _getObject(Map<String, dynamic> data) {
    return ShopModel(
      id: data['id'],
      shopName: data['name'],
      address: data['address'],
      phoneNoOne: data['phone_no_one'],
      phoneNoTwo: data['phone_no_two'],
      employees: int.parse(data['employees']),
    );
  }

  static getShops() async {
    try {
      String? token = await Token.getToken();
      Response response =
          await APIService.getApiHandler(token: token ?? '').get('shops');

      List<ShopModel> resultSets = [];

      if (response.statusCode == 200) {
        var data = response.data;

        if (data['data'].isNotEmpty) {
          for (Map<String, dynamic> element in data['data']) {
            resultSets.add(_getObject(element));
          }
        }

        return resultSets;
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static getShop(int id) async {
    try {
      String? token = await Token.getToken();
      Response response =
          await APIService.getApiHandler(token: token ?? '').get('shops/$id');

      if (response.statusCode == 200) {
        var data = response.data;

        return _getObject(data['data']);
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static updateShop(int id, Map<String, dynamic> data) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .put('shops/$id', data: data);

      if (response.statusCode == 201) {
        var data = response.data;

        return _getObject(data['data']);
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }
}

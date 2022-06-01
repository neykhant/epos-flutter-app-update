import 'package:dio/dio.dart';
import '../models/damage_item_model.dart';
import 'api_service.dart';
import '../token.dart';

class DamageItemService {
  static DamageItemModel _getObject(Map<String, dynamic> data) {
    return DamageItemModel(
      id: data['id'],
      quantity: int.parse(data['quantity']),
      status: data['status'],
      itemName: data['item']['name'],
      buyRecordId: data['buy_record']['id'],
      merchantName: data['buy_record']['merchant_name'],
    );
  }

  static getDamageItems(int shopId) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .get('damage-items/$shopId');

      List<DamageItemModel> resultSets = [];

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

  static postDamageItem(Map<String, dynamic> data) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .post('damage-items', data: data);

      if (response.statusCode == 201) {
        var data = response.data;

        return _getObject(data['data']);
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static deleteDamageItem(int id) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .delete('damage-items/$id');

      if (response.statusCode == 204) {
        return response.statusCode;
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }
}
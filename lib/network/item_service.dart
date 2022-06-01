import 'package:dio/dio.dart';

import '../models/category_model.dart';
import '../models/item_model.dart';
import '../token.dart';
import 'api_service.dart';

class ItemService {
  static ItemModel _getObject(Map<String, dynamic> data) {
    // print(data);
    return ItemModel(
      id: data['id'],
      code: data['code'],
      itemName: data['name'],
      buyPrice: int.parse(data['buy_price']),
      salePrice: int.parse(data['sale_price']),
      categoryModel: CategoryModel(
        id: data['category']['id'],
        name: data['category']['name'],
      ),
    );
  }

  static getItems() async {
    try {
      String? token = await Token.getToken();
      Response response =
          await APIService.getApiHandler(token: token ?? '').get('items');

      List<ItemModel> resultSets = [];

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

  static getItem(int id) async {
    try {
      String? token = await Token.getToken();
      Response response =
          await APIService.getApiHandler(token: token ?? '').get('item/$id');

      if (response.statusCode == 200) {
        var data = response.data;

        return _getObject(data['data']);
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static postItem(Map<String, dynamic> data) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .post('items', data: data);

      if (response.statusCode == 201) {
        var data = response.data;

        return _getObject(data['data']);
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static updateItem(int id, Map<String, dynamic> data) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .put('items/$id', data: data);

      if (response.statusCode == 201) {
        var data = response.data;

        return ItemModel(
          id: data['data']['id'],
          code: data['data']['code'],
          itemName: data['data']['name'],
          buyPrice: int.parse(data['data']['buy_price']),
          salePrice: int.parse(data['data']['sale_price']),
          categoryModel: CategoryModel(
            id: data['data']['category']['id'],
            name: data['data']['category']['name'],
          ),
        );
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }
}

import 'package:dio/dio.dart';
import '../models/category_model.dart';
import '../models/item_model.dart';
import '../models/shop_model.dart';
import 'api_service.dart';
import '../models/item_transfer_model.dart';
import '../token.dart';

class ItemTransferService {
  static ItemTransferModel _getObject(Map<String, dynamic> data) {
    return ItemTransferModel(
      id: data['id'],
      shop: ShopModel(
        id: data['to_shop']['id'],
        shopName: data['to_shop']['name'],
        address: data['to_shop']['address'],
        phoneNoOne: data['to_shop']['phone_no_one'],
        phoneNoTwo: data['to_shop']['phone_no_two'],
        employees: int.parse(data['to_shop']['employees']),
      ),
      item: ItemModel(
        id: data['item']['id'],
        code: data['item']['code'],
        itemName: data['item']['name'],
        buyPrice: int.parse(data['item']['buy_price']),
        salePrice: int.parse(data['item']['sale_price']),
        categoryModel: CategoryModel(
          id: data['item']['category']['id'],
          name: data['item']['category']['name'],
        ),
      ),
      quantity: int.parse(data['quantity']),
      createdAt: data['created_at'],
    );
  }

  static getItemTransfers(int shopId) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .get('item-transfers/$shopId');

      List<ItemTransferModel> resultSets = [];

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

  static getItemTransfer(int id) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .get('item-transfer/$id');

      if (response.statusCode == 200) {
        var data = response.data;

        return _getObject(data['data']);
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static postItemTransfer(Map<String, dynamic> data) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .post('item-transfers', data: data);

      if (response.statusCode == 201) {
        var data = response.data;

        return _getObject(data['data']);
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static deleteItemTransfer(int id) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .delete('item-transfers/$id');

      if (response.statusCode == 204) {
        return response.statusCode;
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }
}

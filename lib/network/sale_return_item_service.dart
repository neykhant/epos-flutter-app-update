import 'package:dio/dio.dart';
import '../models/sale_return_item_model.dart';
import 'api_service.dart';
import '../token.dart';

class SaleReturnItemService {
  static SaleReturnItemModel _getObject(Map<String, dynamic> data) {
    return SaleReturnItemModel(
      id: data['id'],
      quantity: int.parse(data['quantity']),
      status: data['status'],
      itemName: data['item']['name'],
      saleRecordId: data['sale_record']['id'],
      customerName: data['sale_record']['customer_name'],
    );
  }

  static getSaleReturnItems(int shopId) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .get('sale-return-items/$shopId');

      List<SaleReturnItemModel> resultSets = [];

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

  static postSaleReturnItem(Map<String, dynamic> data) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .post('sale-return-items', data: data);

      if (response.statusCode == 201) {
        var data = response.data;

        return _getObject(data['data']);
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static deleteSaleReturnItem(int id) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .delete('sale-return-items/$id');

      if (response.statusCode == 204) {
        return response.statusCode;
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }
}

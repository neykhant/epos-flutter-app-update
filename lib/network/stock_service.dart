import 'package:dio/dio.dart';
import '../models/all_stock_model.dart';
import '../models/stock_model.dart';
import '../models/item_model.dart';
import '../models/category_model.dart';
import 'api_service.dart';
import '../token.dart';

class StockService {
  static StockModel _getObject(Map<String, dynamic> data) {
    return StockModel(
      id: data['id'],
      quantity: int.parse(data['quantity']),
      itemModel: ItemModel(
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
    );
  }

  static AllStockModel _getAllStockObject(Map<String, dynamic> data) {
    return AllStockModel(
      quantity: int.parse(data['quantity']),
      itemModel: ItemModel(
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
    );
  }

  static getStocks(int shopId) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .get('stocks/$shopId');

      List<StockModel> resultSets = [];

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

  static getAllStocks() async {
    try {
      String? token = await Token.getToken();
      Response response =
          await APIService.getApiHandler(token: token ?? '').get('all-stocks');

      List<AllStockModel> resultSets = [];

      if (response.statusCode == 200) {
        var data = response.data;

        if (data['data'].isNotEmpty) {
          for (Map<String, dynamic> element in data['data']) {
            resultSets.add(_getAllStockObject(element));
          }
        }

        return resultSets;
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static getLowStocks(int quantity, int shopId) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .get('low-items/$quantity/$shopId');

      List<StockModel> resultSets = [];

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

  static getStock(int id) async {
    try {
      String? token = await Token.getToken();
      Response response =
          await APIService.getApiHandler(token: token ?? '').get('stock/$id');

      if (response.statusCode == 200) {
        var data = response.data;

        return _getObject(data['data']);
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static postStock(Map<String, dynamic> data) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .post('stocks', data: data);

      if (response.statusCode == 201) {
        var data = response.data;

        return StockModel(
          id: data['data']['id'],
          quantity: data['data']['quantity'],
          itemModel: ItemModel(
            id: data['data']['item']['id'],
            code: data['data']['item']['code'],
            itemName: data['data']['item']['name'],
            buyPrice: int.parse(data['data']['item']['buy_price']),
            salePrice: int.parse(data['data']['item']['sale_price']),
            categoryModel: CategoryModel(
              id: data['data']['item']['category']['id'],
              name: data['data']['item']['category']['name'],
            ),
          ),
        );
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static updateStock(int id, Map<String, dynamic> data) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .put('stocks/$id', data: data);

      if (response.statusCode == 201) {
        var data = response.data;

        return StockModel(
          id: data['data']['id'],
          quantity: data['data']['quantity'],
          itemModel: ItemModel(
            id: data['data']['item']['id'],
            code: data['data']['item']['code'],
            itemName: data['data']['item']['name'],
            buyPrice: int.parse(data['data']['item']['buy_price']),
            salePrice: int.parse(data['data']['item']['sale_price']),
            categoryModel: CategoryModel(
              id: data['data']['item']['category']['id'],
              name: data['data']['item']['category']['name'],
            ),
          ),
        );
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }
}

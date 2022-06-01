import 'package:dio/dio.dart';
import 'package:epos_update_app/models/sale_items_model.dart';
import '../models/category_model.dart';
import '../models/gross_profit_item.dart';
import '../models/item_model.dart';
import '../models/stock_model.dart';
import '../models/profit_model.dart';
import 'api_service.dart';
import '../token.dart';

class ProfitService {
  static ProfitModel _getObject(Map<String, dynamic> data) {
    return ProfitModel(
      purchaseTotal: data['daily']['purchase_total'] == null
          ? 0
          : int.parse(data['daily']['purchase_total']),
      saleRecordTotal: data['daily']['sale_record_total'] == null
          ? 0
          : int.parse(data['daily']['sale_record_total']),
      extraCharges: data['daily']['extra_charges'] == null
          ? 0
          : int.parse(data['daily']['extra_charges']),
      wholeTotal: data['daily']['final_total'] == null
          ? 0
          : int.parse(data['daily']['final_total']),
      credit: data['daily']['credit'] == null
          ? 0
          : int.parse(data['daily']['credit']),
      expenseAmount: data['expense']['amount'] == null
          ? 0
          : int.parse(data['expense']['amount']),
    );
  }

  static GrossProfitItemModel _getGrossProfitObject(Map<String, dynamic> data) {
    return GrossProfitItemModel(
      stock: StockModel(
        id: data['stock']['id'],
        quantity: int.parse(data['stock']['quantity']),
        itemModel: ItemModel(
          id: data['stock']['item']['id'],
          code: data['stock']['item']['code'],
          itemName: data['stock']['item']['name'],
          buyPrice: int.parse(data['stock']['item']['buy_price']),
          salePrice: int.parse(data['stock']['item']['sale_price']),
          categoryModel: CategoryModel(
            id: data['stock']['item']['category']['id'],
            name: data['stock']['item']['category']['name'],
          ),
        ),
      ),
      quantity: int.parse(data['quantity']),
      subtotal: int.parse(data['subtotal']),
    );
  }

  static SaleItemsModel _getSaleItemsObject(Map<String, dynamic> data) {
    return SaleItemsModel(
      day: DateTime.parse(data['day']),
      stock: StockModel(
        id: data['stock']['id'],
        quantity: int.parse(data['stock']['quantity']),
        itemModel: ItemModel(
          id: data['stock']['item']['id'],
          code: data['stock']['item']['code'],
          itemName: data['stock']['item']['name'],
          buyPrice: int.parse(data['stock']['item']['buy_price']),
          salePrice: int.parse(data['stock']['item']['sale_price']),
          categoryModel: CategoryModel(
            id: data['stock']['item']['category']['id'],
            name: data['stock']['item']['category']['name'],
          ),
        ),
      ),
      quantity: int.parse(data['quantity']),
      subtotal: int.parse(data['subtotal']),
    );
  }

  static getProfit(int shopId) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .get('profit/$shopId');

      if (response.statusCode == 200) {
        var data = response.data;

        return _getObject(data);
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static getProfitByDate(int shopId, String startDate, String endDate) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .get('profit/$shopId?start_date=$startDate&end_date=$endDate');

      if (response.statusCode == 200) {
        var data = response.data;

        return _getObject(data);
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static getGrossProfitItem(int shopId) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .get('gross-profit-items/$shopId');

      List<GrossProfitItemModel> resultSets = [];

      if (response.statusCode == 200) {
        var data = response.data;

        if (data['data'].isNotEmpty) {
          for (Map<String, dynamic> element in data['data']) {
            resultSets.add(_getGrossProfitObject(element));
          }
        }

        return resultSets;
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static getSaleItems(int shopId) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .get('daily-sale-items/$shopId');

      List<SaleItemsModel> resultSets = [];

      if (response.statusCode == 200) {
        var data = response.data;

        if (data['data'].isNotEmpty) {
          for (Map<String, dynamic> element in data['data']) {
            resultSets.add(_getSaleItemsObject(element));
          }
        }

        return resultSets;
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static getSaleItemsByDate(
      int shopId, String startDate, String endDate) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '').get(
          'daily-sale-items/$shopId?start_date=$startDate&end_date=$endDate');

      List<SaleItemsModel> resultSets = [];

      if (response.statusCode == 200) {
        var data = response.data;

        if (data['data'].isNotEmpty) {
          for (Map<String, dynamic> element in data['data']) {
            resultSets.add(_getSaleItemsObject(element));
          }
        }

        return resultSets;
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }
}

import 'package:dio/dio.dart';
import '../models/category_model.dart';
import '../models/more_sale_model.dart';
import '../models/credit_model.dart';
import '../models/item_model.dart';
import '../models/sale_model.dart';
import '../models/single_sale_model.dart';
import '../models/stock_model.dart';
import 'api_service.dart';
import '../token.dart';

class SaleService {
  static SaleModel _getPostObject(Map<String, dynamic> data) {
    List<SingleSaleModel> singleSales = [];
    if (data['single_sales'].isNotEmpty) {
      for (Map<String, dynamic> singleSale in data['single_sales']) {
        singleSales.add(
          SingleSaleModel(
            id: singleSale['id'],
            stock: StockModel(
              id: singleSale['stock']['id'],
              quantity: int.parse(singleSale['stock']['quantity']),
              itemModel: ItemModel(
                id: singleSale['stock']['item']['id'],
                code: singleSale['stock']['item']['code'],
                itemName: singleSale['stock']['item']['name'],
                buyPrice: int.parse(singleSale['stock']['item']['buy_price']),
                salePrice: int.parse(singleSale['stock']['item']['sale_price']),
                categoryModel: CategoryModel(
                  id: singleSale['stock']['item']['category']['id'],
                  name: singleSale['stock']['item']['category']['name'],
                ),
              ),
            ),
            itemPrice: int.parse(singleSale['price']),
            quantity: int.parse(singleSale['quantity']),
            totalPrice: int.parse(singleSale['subtotal']),
          ),
        );
      }
    }
    List<CreditModel> credits = [];
    if (data['credits'].isNotEmpty) {
      for (Map<String, dynamic> credit in data['credits']) {
        credits.add(
          CreditModel(
            id: credit['id'],
            amount: int.parse(credit['amount']),
            createdAt: credit['created_at'],
          ),
        );
      }
    }

    return SaleModel(
      id: data['id'],
      customerName: data['customer_name'],
      purchaseTotal: data['purchase_total'],
      saleRecordTotal: data['sale_record_total'],
      extraCharges: data['extra_charges'],
      wholeTotal: data['whole_total'],
      finalTotal: data['final_total'],
      paid: data['paid'],
      credit: data['credit'],
      discount: double.parse(data['discount']),
      remark: data['remark'],
      note: data['note'],
      singleSales: singleSales,
      credits: credits,
      createdAt: data["created_at"],
    );
  }

  static SaleModel _getObject(Map<String, dynamic> data) {
    List<SingleSaleModel> singleSales = [];
    if (data['single_sales'].isNotEmpty) {
      for (Map<String, dynamic> singleSale in data['single_sales']) {
        singleSales.add(
          SingleSaleModel(
            id: singleSale['id'],
            stock: StockModel(
              id: singleSale['stock']['id'],
              quantity: int.parse(singleSale['stock']['quantity']),
              itemModel: ItemModel(
                id: singleSale['stock']['item']['id'],
                code: singleSale['stock']['item']['code'],
                itemName: singleSale['stock']['item']['name'],
                buyPrice: int.parse(singleSale['stock']['item']['buy_price']),
                salePrice: int.parse(singleSale['stock']['item']['sale_price']),
                categoryModel: CategoryModel(
                  id: singleSale['stock']['item']['category']['id'],
                  name: singleSale['stock']['item']['category']['name'],
                ),
              ),
            ),
            itemPrice: int.parse(singleSale['price']),
            quantity: int.parse(singleSale['quantity']),
            totalPrice: int.parse(singleSale['subtotal']),
          ),
        );
      }
    }
    List<CreditModel> credits = [];
    if (data['credits'].isNotEmpty) {
      for (Map<String, dynamic> credit in data['credits']) {
        credits.add(
          CreditModel(
            id: credit['id'],
            amount: int.parse(credit['amount']),
            createdAt: credit['created_at'],
          ),
        );
      }
    }

    return SaleModel(
      id: data['id'],
      customerName: data['customer_name'],
      purchaseTotal: int.parse(data['purchase_total']),
      saleRecordTotal: int.parse(data['sale_record_total']),
      extraCharges: int.parse(data['extra_charges']),
      wholeTotal: int.parse(data['whole_total']),
      finalTotal: double.parse(data['final_total']),
      paid: int.parse(data['paid']),
      credit: double.parse(data['credit']),
      discount: double.parse(data['discount']),
      remark: data['remark'],
      note: data['note'],
      singleSales: singleSales,
      credits: credits,
      createdAt: data["created_at"],
    );
  }

  static postSale(Map<String, dynamic> data) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .post('sales', data: data);

      if (response.statusCode == 201) {
        var result = response.data;

        return _getPostObject(result['data']);
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static getSales(int shopId) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .get('sales/$shopId');

      List<SaleModel> resultSets = [];

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

  static MoreSaleModel _getMoreSaleObject(Map<String, dynamic> data) {
    return MoreSaleModel(
      total: int.parse(data['total']),
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
    );
  }

  static getMoreSaleItems(int shopId) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .get('more-sales/$shopId');

      List<MoreSaleModel> resultSets = [];

      if (response.statusCode == 200) {
        var data = response.data;

        if (data['data'].isNotEmpty) {
          for (Map<String, dynamic> element in data['data']) {
            resultSets.add(_getMoreSaleObject(element));
          }
        }

        return resultSets;
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static deleteSale(int id) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .delete('sales/$id');

      if (response.statusCode == 204) {
        return response.statusCode;
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static restoreSale(int id) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .delete('restore-sales/$id');

      if (response.statusCode == 204) {
        return response.statusCode;
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }
}

import 'package:dio/dio.dart';
import '../models/buy_model.dart';
import '../models/credit_model.dart';
import '../models/item_model.dart';
import '../models/single_buy_model.dart';
import 'api_service.dart';
import '../token.dart';

class BuyService {
  static BuyModel _getPostObject(Map<String, dynamic> data) {
    List<SingleBuyModel> singleBuys = [];
    if (data['single_buys'].isNotEmpty) {
      for (Map<String, dynamic> singleBuy in data['single_buys']) {
        singleBuys.add(
          SingleBuyModel(
            id: singleBuy['id'],
            item: ItemModel(
              id: singleBuy['item']['id'],
              code: singleBuy['item']['code'],
              itemName: singleBuy['item']['name'],
              buyPrice: int.parse(singleBuy['item']['buy_price']),
              salePrice: int.parse(singleBuy['item']['sale_price']),
            ),
            itemPrice: int.parse(singleBuy['price']),
            quantity: int.parse(singleBuy['quantity']),
            totalPrice: int.parse(singleBuy['subtotal']),
          ),
        );
      }
    }
    List<CreditModel> credits = [];
    if (data['buy_credits'].isNotEmpty) {
      for (Map<String, dynamic> credit in data['buy_credits']) {
        credits.add(
          CreditModel(
            id: credit['id'],
            amount: int.parse(credit['amount']),
            createdAt: credit['created_at'],
          ),
        );
      }
    }

    return BuyModel(
      id: data['id'],
      merchantName: data['merchant_name'],
      wholeTotal: data['whole_total'],
      paid: data['paid'],
      credit: data['credit'],
      singleBuys: singleBuys,
      credits: credits,
      createdAt: data["created_at"],
    );
  }

  static postBuy(Map<String, dynamic> data) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .post('buys', data: data);

      if (response.statusCode == 201) {
        var result = response.data;

        return _getPostObject(result['data']);
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static BuyModel _getObject(Map<String, dynamic> data) {
    List<SingleBuyModel> singleBuys = [];
    if (data['single_buys'].isNotEmpty) {
      for (Map<String, dynamic> singleBuy in data['single_buys']) {
        singleBuys.add(
          SingleBuyModel(
            id: singleBuy['id'],
            item: ItemModel(
              id: singleBuy['item']['id'],
              code: singleBuy['item']['code'],
              itemName: singleBuy['item']['name'],
              buyPrice: int.parse(singleBuy['item']['buy_price']),
              salePrice: int.parse(singleBuy['item']['sale_price']),
            ),
            itemPrice: int.parse(singleBuy['price']),
            quantity: int.parse(singleBuy['quantity']),
            totalPrice: int.parse(singleBuy['subtotal']),
          ),
        );
      }
    }
    List<CreditModel> credits = [];
    if (data['buy_credits'].isNotEmpty) {
      for (Map<String, dynamic> credit in data['buy_credits']) {
        credits.add(
          CreditModel(
            id: credit['id'],
            amount: int.parse(credit['amount']),
            createdAt: credit['created_at'],
          ),
        );
      }
    }

    return BuyModel(
      id: data['id'],
      merchantName: data['merchant_name'],
      wholeTotal: int.parse(data['whole_total']),
      paid: int.parse(data['paid']),
      credit: int.parse(data['credit']),
      singleBuys: singleBuys,
      credits: credits,
      createdAt: data["created_at"],
    );
  }

  static getBuys(int shopId) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .get('buys/$shopId');

      List<BuyModel> resultSets = [];

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

  static deleteBuy(int id) async {
    try {
      String? token = await Token.getToken();
      Response response =
          await APIService.getApiHandler(token: token ?? '').delete('buys/$id');

      if (response.statusCode == 204) {
        return response.statusCode;
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }
}

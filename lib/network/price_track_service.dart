import 'package:dio/dio.dart';
import '../models/price_track_model.dart';
import '../models/category_model.dart';
import '../models/item_model.dart';
import 'api_service.dart';
import '../token.dart';

class PriceTrackService {
  static PriceTrackModel _getObject(Map<String, dynamic> data) {
    return PriceTrackModel(
      id: data['id'],
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
      buyPrice: int.parse(data['buy_price']),
      salePrice: int.parse(data['sale_price']),
      createdAt: data['created_at'],
    );
  }

  static getPriceTracks() async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .get('price-tracks');

      List<PriceTrackModel> resultSets = [];

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
}

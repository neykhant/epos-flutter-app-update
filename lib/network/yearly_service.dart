import 'package:dio/dio.dart';
import '../models/yearly_model.dart';
import 'api_service.dart';
import '../token.dart';

class YearlyService {
  static YearlyModel _getObject(Map<String, dynamic> data) {
    return YearlyModel(
      year: data['year'],
      purchaseTotal: int.parse(data['purchase_total']),
      saleRecordTotal: int.parse(data['sale_record_total']),
      extraCharges: int.parse(data['extra_charges']),
      wholeTotal: int.parse(data['final_total']),
      credit: int.parse(data['credit']),
    );
  }

  static getYearly(int shopId) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .get('yearly/$shopId');

      List<YearlyModel> resultSets = [];

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

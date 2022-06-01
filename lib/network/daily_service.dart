import 'package:dio/dio.dart';
import '../models/daily_model.dart';
import 'api_service.dart';
import '../token.dart';

class DailyService {
  static DailyModel _getObject(Map<String, dynamic> data) {
    return DailyModel(
      day: DateTime.parse(data['day']),
      purchaseTotal: int.parse(data['purchase_total']),
      saleRecordTotal: int.parse(data['sale_record_total']),
      extraCharges: int.parse(data['extra_charges']),
      wholeTotal: int.parse(data['final_total']),
      credit: int.parse(data['credit']),
    );
  }

  static getDaily(int shopId) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .get('daily/$shopId');

      List<DailyModel> resultSets = [];

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

  static getDailyByDate(int shopId, String startDate, String endDate) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .get('daily/$shopId?start_date=$startDate&end_date=$endDate');

      List<DailyModel> resultSets = [];

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

import 'package:dio/dio.dart';
import '../models/expense_model.dart';
import 'api_service.dart';
import '../token.dart';

class ExpenseService {
  static ExpenseModel _getObject(Map<String, dynamic> data) {
    return ExpenseModel(
      id: data['id'],
      name: data['name'],
      amount: int.parse(data['amount']),
      createdAt: data['created_at'],
    );
  }

  static getExpenses(int shopId) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .get('expenses/$shopId');

      List<ExpenseModel> resultSets = [];

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

  static getExpensesByDate(int shopId, String startDate, String endDate) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .get('expenses/$shopId?start_date=$startDate&end_date=$endDate');

      List<ExpenseModel> resultSets = [];

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

  static getExpense(int id) async {
    try {
      String? token = await Token.getToken();
      Response response =
          await APIService.getApiHandler(token: token ?? '').get('expense/$id');

      if (response.statusCode == 200) {
        var data = response.data;

        return _getObject(data['data']);
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static postExpense(Map<String, dynamic> data) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .post('expenses', data: data);

      if (response.statusCode == 201) {
        var data = response.data;

        return _getObject(data['data']);
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static updateExpense(int id, Map<String, dynamic> data) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .put('expenses/$id', data: data);

      if (response.statusCode == 201) {
        var data = response.data;

        return _getObject(data['data']);
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static deleteExpense(int id) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .delete('expenses/$id');

      if (response.statusCode == 204) {
        return response.statusCode;
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }
}

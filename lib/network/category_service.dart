import 'package:dio/dio.dart';
import '../models/category_model.dart';
import 'api_service.dart';
import '../token.dart';

class CategoryService {
  static CategoryModel _getObject(Map<String, dynamic> data) {
    return CategoryModel(
      id: data['id'],
      name: data['name'],
    );
  }

  static getCategories() async {
    try {
      String? token = await Token.getToken();
      Response response =
          await APIService.getApiHandler(token: token ?? '').get('categories');

      List<CategoryModel> resultSets = [];

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

  static getCategory(int id) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .get('category/$id');

      if (response.statusCode == 200) {
        var data = response.data;

        return _getObject(data['data']);
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static postCategory(Map<String, dynamic> data) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .post('categories', data: data);

      if (response.statusCode == 201) {
        var data = response.data;

        return _getObject(data['data']);
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }

  static updateCategory(int id, Map<String, dynamic> data) async {
    try {
      String? token = await Token.getToken();
      Response response = await APIService.getApiHandler(token: token ?? '')
          .put('categories/$id', data: data);

      if (response.statusCode == 201) {
        var data = response.data;

        return _getObject(data['data']);
      }
    } on DioError catch (e) {
      return e.response!.statusCode;
    }
  }
}

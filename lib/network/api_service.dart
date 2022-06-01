import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class APIService {
  static Dio getApiHandler({String token = ''}) {
    BaseOptions options = BaseOptions(
      baseUrl: "http://epos-update-api.rcs-mm.com/api/v1/",
    );

    options.headers["Authorization"] = "Bearer " + token;

    options.headers["Accept"] = "application/json";

    Dio dio = Dio(options);
    dio.interceptors.addAll([
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: false,
      )
    ]);

    return dio;
  }
}

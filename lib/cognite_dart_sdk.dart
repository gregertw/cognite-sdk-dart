library cognite_dart_sdk;

import 'dart:convert';
import 'package:dio/dio.dart';

part 'models/timeseries.dart';

var dio = Dio();

class CustomInterceptors extends InterceptorsWrapper {
  String apikey;

  @override
  CustomInterceptors(this.apikey);

  @override
  Future onRequest(RequestOptions options) {
    options.headers['api-key'] = this.apikey;
    options.responseType = ResponseType.plain;
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    response.data = jsonDecode(response.data);
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    return super.onError(err);
  }
}

class CDFApiClient {
  String baseUrl, project, apikey, _apiUrl;
  bool debug;

  CDFApiClient(
      {this.project,
      this.apikey,
      this.baseUrl = 'https://api.cognitedata.com',
      this.debug = false}) {
    this._apiUrl = this.baseUrl + '/api/v1/projects/' + this.project;
    dio.options.baseUrl = this._apiUrl;
    if (this.debug) {
      dio.interceptors.add(LogInterceptor(requestBody: true));
    }
    dio.interceptors.add(CustomInterceptors(this.apikey));
    dio.options.receiveTimeout = 15000;
  }

  Future<List<TimeSeriesModel>> getTimeSeries() async {
    Response res;
    try {
      res = await dio.get('/timeseries');
    } on DioError catch (e) {
      print(e.toString());
      return null;
    }
    if (res.statusCode >= 200 && res.statusCode <= 299) {
      List<TimeSeriesModel> list = List();
      var ts = TimeSeriesModel();
      // TODO(iterate)
      ts.fromJson(res.data['items'][0]);
      list.add(ts);
      return list;
    }
    return null;
  }
}

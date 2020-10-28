library cognite_dart_sdk;

import 'dart:convert';
import 'package:dio/dio.dart';

part 'exceptions.dart';
part 'models/timeseries.dart';
part 'models/datapoint.dart';
part 'models/datapoints.dart';
part 'models/datapoints_filter.dart';

var _dio = Dio();

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
    if (response.data is String) {
      response.data = jsonDecode(response.data);
    }
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
    _dio.options.baseUrl = this._apiUrl;
    if (this.debug) {
      _dio.interceptors.add(LogInterceptor(requestBody: true));
    }
    _dio.interceptors.add(CustomInterceptors(this.apikey));
    _dio.options.receiveTimeout = 15000;
  }

  Future<List<TimeSeriesModel>> getAllTimeSeries() async {
    Response res;
    try {
      res = await _dio.get('/timeseries');
    } on DioError catch (e) {
      print(e.toString());
      return null;
    }
    if (res.statusCode >= 200 && res.statusCode <= 299) {
      List<TimeSeriesModel> list = List();
      var ts = TimeSeriesModel();
      // FIXME: iterate
      ts.fromJson(res.data['items'][0]);
      list.add(ts);
      return list;
    }
    return null;
  }

  Future<DatapointsModel> getDatapoints(DatapointsFilterModel filter,
      {int layer: 0}) async {
    Response res;
    try {
      Map data = {
        'items': [filter.toJson()]
      };
      res = await _dio.post('/timeseries/data/list', data: data);
    } on DioError catch (e) {
      print(e.toString());
      return null;
    }
    if (res.statusCode >= 200 && res.statusCode <= 299) {
      DatapointsModel dp = DatapointsModel();
      dp.fromJson(res.data['items'][0]);
      return dp;
    }
    return null;
  }
}

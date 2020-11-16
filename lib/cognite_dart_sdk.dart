library cognite_dart_sdk;

import 'dart:async';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'dio_interceptors.dart';

part 'exceptions.dart';
part 'models/status.dart';
part 'models/timeseries.dart';
part 'models/datapoint.dart';
part 'models/datapoints.dart';
part 'models/datapoints_filter.dart';

var _dio = Dio();
Logger _log;
List<dynamic> _history;

class CDFApiClient {
  String baseUrl, project, apikey, _apiUrl;
  Level logLevel;
  DefaultHttpClientAdapter httpAdapter = DefaultHttpClientAdapter();

  CDFApiClient(
      {this.project,
      this.apikey,
      this.baseUrl = 'https://api.cognitedata.com',
      this.logLevel = Level.warning,
      this.httpAdapter}) {
    this._apiUrl = this.baseUrl + '/api/v1/projects/' + this.project;
    _history = List<dynamic>();
    if (this.httpAdapter != null) {
      _dio.httpClientAdapter = httpAdapter;
    }
    _dio.options.baseUrl = this._apiUrl;
    _dio.interceptors.add(CustomInterceptor(apikey, _history));
    _dio.options.receiveTimeout = 15000;
    _log = Logger(level: logLevel, printer: MyLogPrinter(), output: null);
    _dio.interceptors.add(CustomLogInterceptor(log: _log));
  }

  Future<StatusModel> getStatus() async {
    Response res;
    try {
      res = await _dio.get(baseUrl + '/login/status');
    } on DioError {
      return null;
    }
    if (res.statusCode >= 200 &&
        res.statusCode <= 299 &&
        res.data is Map &&
        res.data.containsKey('data')) {
      return StatusModel.fromJson(res.data['data']);
    }
    _log.w('getStatus() returned non-2xx response code');
    return null;
  }

  Future<List<TimeSeriesModel>> getAllTimeSeries() async {
    Response res;
    try {
      res = await _dio.get('/timeseries');
    } on DioError {
      return null;
    }
    if (res.statusCode >= 200 && res.statusCode <= 299) {
      return TimeSeriesModel.listFromJson(res.data['items'] ?? null);
    }
    _log.w('getStatus() returned non-2xx response code');
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
    } on DioError {
      return null;
    }
    if (res.statusCode >= 200 && res.statusCode <= 299) {
      DatapointsModel dp = DatapointsModel();
      dp.fromJson(res.data['items'][0]);
      return dp;
    }
    _log.w('getStatus() returned non-2xx response code');
    return null;
  }
}

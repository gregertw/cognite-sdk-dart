library cognite_cdf_sdk;

import 'dart:async';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'dart:convert';

part 'dio_interceptors.dart';
part 'exceptions.dart';
part 'timeseries_api.dart';
part 'models/status.dart';
part 'models/timeseries.dart';
part 'models/datapoint.dart';
part 'models/datapoints.dart';
part 'models/datapoints_filter.dart';

Logger _log;
List<dynamic> _history;

/// Main API client class to set up and hold a connection
class CDFApiClient {
  String baseUrl, project, apikey, _apiUrl;
  Level logLevel;
  var _dio = Dio();
  DefaultHttpClientAdapter httpAdapter = DefaultHttpClientAdapter();
  get http => _dio;

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
    _dio.interceptors.add(_CustomInterceptor(apikey, _history));
    _dio.options.receiveTimeout = 15000;
    _log = Logger(level: logLevel, printer: _MyLogPrinter(), output: null);
    _dio.interceptors.add(_CustomLogInterceptor(log: _log));
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
}

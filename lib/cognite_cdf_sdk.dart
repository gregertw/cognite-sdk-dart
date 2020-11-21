/// The cognite_cdf_sdk is a read-only SDK to interact with Cognite CDF.
///
/// The API is documented at https://docs.cognite.com/api/v1/
/// The current version is primarily targeted towards read-only data exploration
/// type of Flutter apps.
///
/// Instantiate a client to be used by the APIs, e.g. [TimeSeriesAPI]:
/// ```
/// var apiClient = CDFApiClient(
///            project: 'project_name',
///            apikey: 'myapi_key',
///            baseUrl: 'https://api.cognitedata.com/')
/// ```
/// As an alternative for testing, you can use [CDFMockApiClient] that allows
/// you to use setMock() to specify the reponse.
///
/// To use the API, you inject the client and call the method, like this:
/// ```
/// var res = await TimeSeriesAPI(apiClient).getAllTimeSeries();
/// ```
///
/// The library uses the logger package to allow logging at different levels.
/// Choose the log level with the logLevel parameter to [CDFApiClient].
///
/// The library follows the following:
/// * Log errors on Level.error
/// * Log important warnings on Level.warning (default)
/// * Log request on Level.info
/// * Log response on Level.debug
/// * Log extra headers on Level.verbose
///
/// The [CDFApiClient] has a history (List<Response> client.history) where the
/// Response type can be found in the dio Dart package. You can access the
/// history to see all requests done by the client with all details.
library cognite_cdf_sdk;

import 'dart:async';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'package:mockito/mockito.dart';

part 'dio_interceptors.dart';
part 'exceptions.dart';
part 'timeseries_api.dart';
part 'cognite_mock_client.dart';
part 'models/status.dart';
part 'models/timeseries.dart';
part 'models/datapoint.dart';
part 'models/datapoints.dart';
part 'models/datapoints_filter.dart';

Logger _log;
List<dynamic> _history;

/// Main API client class to set up and hold a CDF API connection.
///
/// If you want to test your app, inject [CDFMockApiClient] instead.
class CDFApiClient {
  /// [baseUrl] is set default to 'https://api.cognitedata.com'.
  String baseUrl;

  /// [project] must be set to the CDF project to access.
  String project;

  /// [apikey] must be set with a CDF key that allows proper access.
  String apikey;

  /// Import logger package to use Level.* and set log level.
  Level logLevel;
  String _apiUrl;
  var _dio = Dio();
  DefaultHttpClientAdapter httpAdapter = DefaultHttpClientAdapter();

  /// getter to allow direct access to dio() instance from API classes.
  get http => _dio;

  /// access to full history of requests and responses.
  ///
  /// Use the dio Dart package and the [Response] class to access the List<Response>.
  get history => _history;

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

  /// Used to test against CDF's /login/status to verify access. Returns null on failure.
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

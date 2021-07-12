part of 'package:cognite_cdf_sdk/cognite_cdf_sdk.dart';

/// Used to decode json and inject api-key header.
class _CustomInterceptor extends Interceptor {
  String? token;
  String? apikey;
  List<HistoryModel> history;

  @override
  _CustomInterceptor(this.apikey, this.token, this.history);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    String? path;
    String? baseUrl;
    // Add a unique request id to match up request/response
    int id = Random().nextInt(4294967295);
    options.extra.addAll({'request_id': id});
    // path may be the full url
    if (options.baseUrl.isNotEmpty) {
      baseUrl = options.baseUrl;
    }
    if (options.path.isNotEmpty) {
      path = options.path;
      if (path.startsWith('http')) {
        baseUrl = null;
      }
    }
    history.add(HistoryModel(
        baseUrl: baseUrl,
        path: path,
        method: options.method,
        id: id,
        request: options.data));
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    } else if (apikey != null) {
      options.headers['api-key'] = apikey;
    }
    options.responseType = ResponseType.json;
    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    var iter = history.reversed.iterator;
    while (iter.moveNext()) {
      if (iter.current.id == response.requestOptions.extra['request_id']) {
        iter.current.response = response.data;
        iter.current.statusCode = response.statusCode;
        iter.current.statusMessage = response.statusMessage;
        iter.current.timestampEnd = DateTime.now().millisecondsSinceEpoch;
        break;
      }
    }
    handler.next(response);
  }

  @override
  void onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) async {
    var iter = history.reversed.iterator;
    while (iter.moveNext()) {
      if (err.response == null) continue;
      if (iter.current.id == err.response!.requestOptions.extra['request_id']) {
        iter.current.statusCode = err.response!.statusCode;
        iter.current.statusMessage = err.message;
        break;
      }
    }
    handler.next(err);
  }
}

/// Used if you want to ensure that logging happens in any app mode.
class _MyLogPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    return [event.message];
  }
}

// Log errors on Level.error
// Log request on Level.info
// Log response on Level.debug
// Log extra headers on Level.verbose
class _CustomLogInterceptor extends Interceptor {
  _CustomLogInterceptor({this.log}) {
    if (log == null) {
      log = Logger();
    }
  }

  Logger? log;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    log!.i('*** Request ***');
    log!.i('uri: ${options.uri}');

    log!.i('method: ${options.method}');
    log!.v('responseType: ${options.responseType.toString()}');
    log!.v('followRedirects: ${options.followRedirects}');
    log!.v('connectTimeout: ${options.connectTimeout}');
    log!.v('receiveTimeout: ${options.receiveTimeout}');
    log!.v('extra: ${options.extra}');

    log!.i('headers:');
    options.headers.forEach((key, v) => log!.i(' $key: $v'));
    log!.i('body:');
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    log!.i(encoder.convert(options.data));
    log!.i('');
    handler.next(options);
  }

  @override
  void onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response == null) {
      log!.e('*** DioError ***:');
      log!.e('$err');
      log!.e('');
      handler.next(err);
      return;
    }
    if (err.response!.statusCode! >= 400 && err.response!.statusCode! <= 499) {
      log!.w('*** DioError ***:');
      log!.w('uri: ${err.response!.requestOptions.uri}');
      log!.w('$err');
      _printResponse(err.response!, Level.warning);
      log!.w('');
      handler.next(err);
      return;
    }
    log!.e('*** DioError ***:');
    log!.e('$err');
    log!.e('uri: ${err.response!.requestOptions.uri}');
    _printResponse(err.response!, Level.error);
    log!.e('');
    handler.next(err);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    log!.d('*** Response ***');
    _printResponse(response, Level.debug);
    handler.next(response);
  }

  void _printResponse(Response response, Level level) {
    log!.log(level, 'uri: ${response.requestOptions.uri}');
    log!.log(level, 'statusCode: ${response.statusCode}');
    if (response.isRedirect != null && response.isRedirect!) {
      log!.log(level, 'redirect: ${response.realUri}');
    }
    log!.v('headers:');
    response.headers.forEach((key, v) => log!.v(' $key: ${v.join(',')}'));

    log!.log(level, 'Response Text:');
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    log!.log(level, encoder.convert(response.data));
    log!.log(level, '');
  }
}

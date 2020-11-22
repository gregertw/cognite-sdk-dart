part of 'package:cognite_cdf_sdk/cognite_cdf_sdk.dart';

/// Used to decode json and inject api-key header.
class _CustomInterceptor extends Interceptor {
  String apikey;
  List<dynamic> history;

  @override
  _CustomInterceptor(this.apikey, this.history);

  @override
  Future onRequest(RequestOptions options) async {
    options.headers['api-key'] = this.apikey;
    options.responseType = ResponseType.plain;
    return options;
  }

  @override
  Future onResponse(Response response) async {
    if (response.data is String) {
      response.data = jsonDecode(response.data);
    }
    history.add(response);
    return response;
  }

  @override
  Future onError(DioError err) async {
    return err;
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

  Logger log;

  @override
  Future onRequest(RequestOptions options) async {
    log.i('*** Request ***');
    log.i('uri: ${options.uri}');

    log.i('method: ${options.method}');
    log.v('responseType: ${options.responseType?.toString()}');
    log.v('followRedirects: ${options.followRedirects}');
    log.v('connectTimeout: ${options.connectTimeout}');
    log.v('receiveTimeout: ${options.receiveTimeout}');
    log.v('extra: ${options.extra}');

    log.i('headers:');
    options.headers.forEach((key, v) => log.i(' $key: $v'));
    log.i('body:');
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    log.i(encoder.convert(options.data));
    log.i('');
    return options;
  }

  @override
  Future onError(DioError err) async {
    if (err.response.statusCode >= 400 && err.response.statusCode <= 499) {
      return err;
    }
    log.e('*** DioError ***:');
    log.e('uri: ${err.request.uri}');
    log.e('$err');
    if (err.response != null) {
      _printResponse(err.response, Level.error);
    }
    log.e('');
    return err;
  }

  @override
  Future onResponse(Response response) async {
    log.d('*** Response ***');
    _printResponse(response, Level.debug);
    return response;
  }

  void _printResponse(Response response, Level level) {
    log.log(level, 'uri: ${response.request?.uri}');
    log.log(level, 'statusCode: ${response.statusCode}');
    if (response.isRedirect != null && response.isRedirect) {
      log.log(level, 'redirect: ${response.realUri}');
    }
    log.v('headers:');
    response.headers.forEach((key, v) => log.v(' $key: ${v.join(',')}'));

    log.log(level, 'Response Text:');
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    log.log(level, encoder.convert(response.data));
    log.log(level, '');
  }
}

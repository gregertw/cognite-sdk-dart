part of 'package:cognite_cdf_sdk/cognite_cdf_sdk.dart';

class MockHttpClientAdapter extends Fake implements HttpClientAdapter {
  String _body = '';
  int _code = 200;

  set body(String body) => _body = body;
  set statusCode(int code) => _code = code;

  @override
  fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      _body,
      _code,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}

/// Use the CDFMockApiClient as a replacement for CDFApiClient to mock http responses.
class CDFMockApiClient extends CDFApiClient {
  /// All parameters except logLevel are preset in the mock.
  ///
  /// If you don't supply a [logLevel], you only get warnings and errors.
  CDFMockApiClient({logLevel: Level.error})
      : super(
            project: 'a_project',
            token: null,
            apikey: 'key',
            baseUrl: 'https://api.cognitedata.com/',
            logLevel: logLevel,
            httpAdapter: MockHttpClientAdapter());

  /// Set the mock response you want, empty body and 200 is default.
  setMock({String? body, int? statusCode}) {
    if (body == null || body.isEmpty) {
      body = '';
    }
    if (statusCode == null || statusCode == 0) {
      statusCode = 200;
    }
    (httpAdapter! as MockHttpClientAdapter).body = body;
    (httpAdapter! as MockHttpClientAdapter).statusCode = statusCode;
  }
}

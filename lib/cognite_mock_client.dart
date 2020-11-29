part of 'package:cognite_cdf_sdk/cognite_cdf_sdk.dart';

class _DioAdapterMock extends Mock implements HttpClientAdapter {}

/// Use the CDFMockApiClient as a replacement for CDFApiClient to mock http responses.
class CDFMockApiClient extends CDFApiClient {
  ResponseBody _httpResponse;

  /// All parameters except logLevel are preset in the mock.
  ///
  /// If you don't supply a [logLevel], you only get warnings and errors.
  CDFMockApiClient({logLevel: Level.error})
      : super(
            project: 'a_project',
            apikey: 'key',
            baseUrl: 'https://api.cognitedata.com/',
            logLevel: logLevel,
            httpAdapter: _DioAdapterMock());

  final _dioHttpHeadersForResponseBody = {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  };

  /// Set the mock response you want, empty body and 200 is default.
  setMock({String body, int statusCode}) {
    if (body == null || body.isEmpty) {
      body = "";
    }
    if (statusCode == null || statusCode == 0) {
      statusCode = 200;
    }
    _httpResponse = ResponseBody.fromString(
      body,
      statusCode,
      headers: _dioHttpHeadersForResponseBody,
    );
    when(httpAdapter.fetch(any, any, any))
        .thenAnswer((_) async => _httpResponse);
  }
}

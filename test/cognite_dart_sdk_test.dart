import 'package:flutter_test/flutter_test.dart';
import 'package:cognite_dart_sdk/cognite_dart_sdk.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

class DioAdapterMock extends Mock implements DefaultHttpClientAdapter {}

const dioHttpHeadersForResponseBody = {
  Headers.contentTypeHeader: [Headers.jsonContentType],
};

void main() {
  group('Basic functionality', () {
    DioAdapterMock dioAdapterMock;
    CDFApiClient client;

    setUp(() {
      dioAdapterMock = DioAdapterMock();
      client = CDFApiClient(
          project: 'a_project',
          apikey: 'something',
          baseUrl: 'https://api.cognitedata.com',
          httpAdapter: dioAdapterMock);
    });

    group('login', () {
      test('should return user info if logged in', () async {
        final httpResponse = ResponseBody.fromString(
          """{
    "data": {
        "user": "user@cognite.com",
        "loggedIn": true,
        "project": "publicdata",
        "projectId": 5977964818434649,
        "apiKeyId": 934347347677
    }
}""",
          200,
          headers: dioHttpHeadersForResponseBody,
        );
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);
        var res = await client.getStatus();
        expect(res, isNotNull, reason: 'Response is expected');
        expect(res.user, "user@cognite.com");
        expect(res.loggedIn, true);
        expect(res.project, "publicdata");
        expect(res.projectId, 5977964818434649);
        expect(res.apiKeyId, 934347347677);
      });
    });
    group('timeseries', () {
      test('should return a list of time series', () async {
        final httpResponse = ResponseBody.fromString(
          """{
  "items": [
    {
      "id": 29107693408255,
      "createdTime": 1599902063058,
      "lastUpdatedTime": 1599902063058,
      "externalId": "ts_c2009283ac84526e9f0e01ef4cc9fa2a",
      "name": "heartrate",
      "isString": false,
      "unit": "beats",
      "isStep": false
    },
    {
      "id": 29101293405233,
      "createdTime": 1599902073058,
      "lastUpdatedTime": 1599902043058,
      "externalId": "ts_power_switch",
      "name": "power_switch TS34 valve",
      "isString": true,
      "unit": "on/off",
      "isStep": false
    }
  ]
}""",
          200,
          headers: dioHttpHeadersForResponseBody,
        );
        when(dioAdapterMock.fetch(any, any, any))
            .thenAnswer((_) async => httpResponse);
        var res = await client.getAllTimeSeries();
        expect(res, isNotNull, reason: 'Response is expected');
        expect(res.length, 2, reason: 'Two timeseries entries');
        expect(res[0].id, 29107693408255);
        expect(res[1].id, 29101293405233);
        expect(res[0].externalId, "ts_c2009283ac84526e9f0e01ef4cc9fa2a");
        expect(
          res[1].externalId,
          "ts_power_switch",
        );
      });
    });
  });
}

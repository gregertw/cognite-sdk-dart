import 'package:flutter_test/flutter_test.dart';
import 'package:cognite_dart_sdk/cognite_dart_sdk.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class DioAdapterMock extends Mock implements DefaultHttpClientAdapter {}

const dioHttpHeadersForResponseBody = {
  Headers.contentTypeHeader: [Headers.jsonContentType],
};

void main() {
  DioAdapterMock dioAdapterMock;
  CDFApiClient client;

  setUpAll(() {
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

  group('login failed', () {
    test('should fail login status', () async {
      final httpResponse = ResponseBody.fromString(
        "",
        403,
        headers: dioHttpHeadersForResponseBody,
      );
      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);
      var res = await client.getStatus();
      expect(res, isNull, reason: 'Null response is expected');
    });
  });
  group('retrieve timeseries', () {
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

  group('retrieve timeseries datapoints', () {
    test('should return null datapoints', () async {
      final httpResponse = ResponseBody.fromString(
        "",
        404,
        headers: dioHttpHeadersForResponseBody,
      );
      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);
      DatapointsFilterModel filter = DatapointsFilterModel();
      filter.externalId = 'ts_doesnotexist';
      filter.end = DateTime.now().millisecondsSinceEpoch;
      filter.start = filter.end - 3600000;
      filter.resolution = 600;
      filter.aggregates = ['min', 'max', 'average', 'count'];
      var res = await client.getDatapoints(filter);
      expect(res, isNull, reason: 'Response is not expected');
    });
    test('should return a list of datapoints', () async {
      var file = File(Directory.current.path + '/test/response-1.json');

      final httpResponse = ResponseBody.fromString(
        "${await (file.readAsString())}",
        200,
        headers: dioHttpHeadersForResponseBody,
      );
      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);
      DatapointsFilterModel filter = DatapointsFilterModel();
      filter.externalId = 'ts_c2009283ac84526e9f0e01ef4cc9fa2a';
      filter.end = DateTime.now().millisecondsSinceEpoch;
      filter.start = filter.end - 3600000;
      filter.resolution = 600;
      filter.aggregates = ['min', 'max', 'average', 'count'];
      var res = await client.getDatapoints(filter);
      expect(res, isNotNull, reason: 'Response is expected');
      expect(res.datapointsLength, 6, reason: '6 datapoints expected');
      expect(res.datapoints[0].timestamp, 1605422100000);
      expect(res.datapoints[0].average, 70.79713279132793);
    });

    test('should return a longer list of datapoints', () async {
      var file = File(Directory.current.path + '/test/response-2.json');

      final httpResponse = ResponseBody.fromString(
        "${await (file.readAsString())}",
        200,
        headers: dioHttpHeadersForResponseBody,
      );
      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => httpResponse);
      DatapointsFilterModel filter = DatapointsFilterModel();
      filter.externalId = 'ts_c2009283ac84526e9f0e01ef4cc9fa2a';
      filter.end = DateTime.now().millisecondsSinceEpoch;
      filter.start = filter.end - 3600000;
      filter.resolution = 60;
      filter.aggregates = ['min', 'max', 'average', 'count'];
      var res = await client.getDatapoints(filter);
      expect(res, isNotNull, reason: 'Response is expected');
      expect(res.datapointsLength, 53, reason: '53 datapoints expected');
      expect(res.datapoints[0].timestamp, 1605422100000);
      expect(
        res.datapoints[0].average,
        74.01888888888888,
      );
      expect(res.datapoints[52].timestamp, 1605425280000);
      expect(
        res.datapoints[52].average,
        75.34782608695652,
      );
    });
  });
}

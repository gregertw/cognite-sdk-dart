import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:cognite_cdf_sdk/cognite_cdf_sdk.dart';

void main() {
  CDFMockApiClient? client;

  setUpAll(() {
    client = CDFMockApiClient();
  });

  group('login', () {
    test('should return user info if logged in', () async {
      client!.setMock(body: """{
    "data": {
        "user": "user@cognite.com",
        "loggedIn": true,
        "project": "publicdata",
        "projectId": 5977964818434649,
        "apiKeyId": 934347347677
    }
}""");
      var res = await client!.getStatus();
      expect(client!.history![client!.history!.length - 1].statusCode, 200,
          reason: 'Correct error code');
      expect(res, isNotNull, reason: 'Response is expected');
      expect(res?.user, "user@cognite.com");
      expect(res?.loggedIn, true);
      expect(res?.project, "publicdata");
      expect(res?.projectId, 5977964818434649);
      expect(res?.apiKeyId, 934347347677);
    });
  });

  group('login failed', () {
    test('should fail login status', () async {
      client!.setMock(statusCode: 403);
      var res = await client!.getStatus();
      expect(client!.history![client!.history!.length - 1].statusCode, 403,
          reason: 'Correct error code');
      expect(res, isNull, reason: 'Null response is expected');
    });
  });
  group('retrieve timeseries', () {
    test('should return a list of time series', () async {
      client!.setMock(body: """{
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
}""");
      var res = await TimeSeriesAPI(client).getAllTimeSeries();
      expect(client!.history![client!.history!.length - 1].statusCode, 200,
          reason: 'Correct error code');
      expect(res, isNotNull, reason: 'Response is expected');
      expect(res?.length, 2, reason: 'Two timeseries entries');
      expect(res?[0].id, 29107693408255);
      expect(res?[1].id, 29101293405233);
      expect(res?[0].externalId, "ts_c2009283ac84526e9f0e01ef4cc9fa2a");
      expect(
        res?[1].externalId,
        "ts_power_switch",
      );
    });
  });

  group('retrieve timeseries datapoints', () {
    test('should return null datapoints', () async {
      client!.setMock(statusCode: 404);
      DatapointsFilterModel filter = DatapointsFilterModel();
      filter.externalId = 'ts_doesnotexist';
      filter.end = DateTime.now().millisecondsSinceEpoch;
      filter.start = filter.end - 3600000;
      filter.resolution = 600;
      filter.aggregates = ['min', 'max', 'average', 'count'];
      var res = await TimeSeriesAPI(client).getDatapoints(filter);
      expect(client!.history![client!.history!.length - 1].statusCode, 404,
          reason: 'Correct error code');
      expect(res.datapointsLength, 0, reason: 'Response is not expected');
    });
    test('should return a list of datapoints', () async {
      var file = File(Directory.current.path + '/test/response-1.json');

      client!.setMock(body: "${await (file.readAsString())}");
      DatapointsFilterModel filter = DatapointsFilterModel();
      filter.externalId = 'ts_c2009283ac84526e9f0e01ef4cc9fa2a';
      filter.end = DateTime.now().millisecondsSinceEpoch;
      filter.start = filter.end - 3600000;
      filter.resolution = 600;
      filter.aggregates = ['min', 'max', 'average', 'count'];
      var res = await TimeSeriesAPI(client).getDatapoints(filter);
      expect(client!.history![client!.history!.length - 1].statusCode, 200,
          reason: 'Correct error code');
      expect(res, isNotNull, reason: 'Response is expected');
      expect(res.datapointsLength, 6, reason: '6 datapoints expected');
      expect(res.datapoints[0].timestamp, 1605422100000);
      expect(res.datapoints[0].average, 70.79713279132793);
    });

    test('should return a longer list of datapoints', () async {
      var file = File(Directory.current.path + '/test/response-2.json');

      client!.setMock(body: "${await (file.readAsString())}");
      DatapointsFilterModel filter = DatapointsFilterModel();
      filter.externalId = 'ts_c2009283ac84526e9f0e01ef4cc9fa2a';
      filter.end = DateTime.now().millisecondsSinceEpoch;
      filter.start = filter.end - 3600000;
      filter.resolution = 60;
      filter.aggregates = ['min', 'max', 'average', 'count'];
      var res = await TimeSeriesAPI(client).getDatapoints(filter);
      expect(client!.history![client!.history!.length - 1].statusCode, 200,
          reason: 'Correct error code');
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

    test('should return two layers of datapoints', () async {
      var file = File(Directory.current.path + '/test/response-1.json');
      client!.setMock(body: "${await (file.readAsString())}");
      DatapointsFilterModel filter = DatapointsFilterModel();
      filter.externalId = 'ts_c2009283ac84526e9f0e01ef4cc9fa2a';
      filter.end = DateTime.now().millisecondsSinceEpoch;
      filter.start = filter.end - 3600000;
      filter.resolution = 600;
      filter.aggregates = ['min', 'max', 'average', 'count'];
      var res = await TimeSeriesAPI(client).getDatapoints(filter);
      expect(client!.history![client!.history!.length - 1].statusCode, 200,
          reason: 'Correct error code');
      expect(res.layer(layer: 1).length, 6,
          reason: '6 datapoints expected in first layer');
      var file2 = File(Directory.current.path + '/test/response-2.json');
      client!.setMock(body: "${await (file2.readAsString())}");
      DatapointsFilterModel filter2 = DatapointsFilterModel();
      filter2.externalId = 'ts_c2009283ac84526e9f0e01ef4cc9fa2a';
      filter2.end = DateTime.now().millisecondsSinceEpoch;
      filter2.start = filter.end - 3600000;
      filter2.resolution = 60;
      filter.aggregates = ['min', 'max', 'average', 'count'];
      var res2 = await TimeSeriesAPI(client).getDatapoints(filter2);
      expect(client!.history![client!.history!.length - 1].statusCode, 200,
          reason: 'Correct error code');
      res.addDatapoints(res2);
      expect(res.layer().length, 53,
          reason: '53 datapoints expected from last layer');
      expect(res.layer(layer: 1).length, 6,
          reason: '6 datapoints expected in first layer');
      expect(res.datapointsLength, 59, reason: 'total number of datapoints');
      res.popLayer();
      expect(res.datapointsLength, 6,
          reason: 'after pop total number of datapoints');
      expect(res.layer(layer: 1).length, 6,
          reason: '6 datapoints expected in last layer');
    });
    test('should return two layers of datapoints with duplicates removed',
        () async {
      var file = File(Directory.current.path + '/test/response-1.json');
      client!.setMock(body: "${await (file.readAsString())}");
      DatapointsFilterModel filter = DatapointsFilterModel();
      filter.externalId = 'ts_c2009283ac84526e9f0e01ef4cc9fa2a';
      filter.end = DateTime.now().millisecondsSinceEpoch;
      filter.start = filter.end - 3600000;
      filter.resolution = 600;
      filter.aggregates = ['min', 'max', 'average', 'count'];
      var res = await TimeSeriesAPI(client).getDatapoints(filter);
      expect(client!.history![client!.history!.length - 1].statusCode, 200,
          reason: 'Correct error code');
      expect(res.layer(layer: 1).length, 6,
          reason: '6 datapoints expected in first layer');
      var file2 = File(Directory.current.path + '/test/response-2.json');
      client!.setMock(body: "${await (file2.readAsString())}");
      DatapointsFilterModel filter2 = DatapointsFilterModel();
      filter2.externalId = 'ts_c2009283ac84526e9f0e01ef4cc9fa2a';
      filter2.end = DateTime.now().millisecondsSinceEpoch;
      filter2.start = filter.end - 3600000;
      filter2.resolution = 60;
      filter.aggregates = ['min', 'max', 'average', 'count'];
      var res2 = await TimeSeriesAPI(client).getDatapoints(filter2);
      expect(client!.history![client!.history!.length - 1].statusCode, 200,
          reason: 'Correct error code');
      res.addDatapoints(res2, removeDuplicates: true);
      expect(res.layer().length, 49,
          reason: '49 datapoints expected from last layer');
      expect(res.layer(layer: 1).length, 4,
          reason: 'now 4 datapoints expected in first layer');
      expect(res.datapointsLength, 53, reason: 'total number of datapoints');
      res.popLayer();
      expect(res.datapointsLength, 4,
          reason: 'after pop total number of datapoints');
      expect(res.layer(layer: 1).length, 4,
          reason: '4 datapoints expected in last layer');
    });
  });
}

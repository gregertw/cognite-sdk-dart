import 'package:cognite_dart_sdk/cognite_dart_sdk.dart';

void main() {
  //  'https://greger.ngrok.io'
  CDFApiClient client = CDFApiClient(
      project: 'gregerwedel',
      apikey: '',
      baseUrl: 'https://greenfield.cognitedata.com');
  client.getTimeSeries().then((res) {
    if (res != null) {
      res.forEach((k) => print(k.externalId));
    }
  });
  DatapointsFilterModel filter = DatapointsFilterModel();
  filter.externalId = 'fitbit_c2009283ac84526e9f0e01ef4cc9fa2a';
  filter.end = DateTime.now().millisecondsSinceEpoch;
  filter.start = filter.end - 3600000;
  filter.limit = 600;
  filter.aggregates = ['min', 'max', 'average', 'count'];
  filter.granularity = '7s';
  client.getDatapoints(filter).then((res) {
    if (res != null && res.datapoints.isNotEmpty) {
      res.datapoints.forEach((element) {
        print('${element.timestamp}, ${element.average}');
      });
      print(res.externalId);
    }
  });
}

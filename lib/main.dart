import 'package:cognite_dart_sdk/cognite_dart_sdk.dart';
import 'package:logger/logger.dart';

void main() {
  DatapointsModel dps;
  CDFApiClient client = CDFApiClient(
      project: 'gregerwedel',
      apikey: '',
      baseUrl: 'https://greenfield.cognitedata.com');
  client.getStatus().then((res) {
    if (res != null) {
      print(res.toString());
    }
  });
  client.getAllTimeSeries().then((res) {
    if (res != null) {
      res.forEach((k) => print(k.externalId));
    }
  });
  DatapointsFilterModel filter = DatapointsFilterModel();
  filter.externalId = 'fitbit_c2009283ac84526e9f0e01ef4cc9fa2a';
  filter.end = DateTime.now().millisecondsSinceEpoch;
  filter.start = filter.end - 3600000;
  filter.resolution = 600;
  filter.aggregates = ['min', 'max', 'average', 'count'];
  print('Retrieving datapoints at resolution: ${filter.resolution}');
  print(filter.toString());
  client.getDatapoints(filter).then((res) {
    if (res != null && res.datapoints.isNotEmpty) {
      dps = res;
      res.datapoints.forEach((element) {
        print('${element.timestamp}, ${element.average}');
      });
      filter.resolution = 60;
      print('Retrieving datapoints at resolution: ${filter.resolution}');
      client.getDatapoints(filter).then((res) {
        if (res != null && res.datapoints.isNotEmpty) {
          dps.addDatapoints(res);
          dps.datapoints.forEach((element) {
            print('${element.timestamp}, ${element.layer}');
          });
          print('Only last layer...');
          dps.layer().forEach((element) {
            print('${element.timestamp}, ${element.layer}');
          });
          print('Only first layer...');
          dps.layer(layer: 1).forEach((element) {
            print('${element.timestamp}, ${element.layer}');
          });
          print('Popping a layer...');
          dps.popLayer();
          dps.datapoints.forEach((element) {
            print('${element.timestamp}, ${element.layer}');
          });
        }
      });
    }
  });
}

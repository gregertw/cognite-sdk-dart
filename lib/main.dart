import 'package:cognite_dart_sdk/cognite_dart_sdk.dart';

void main() {
  CDFApiClient client = CDFApiClient(
      project: 'gregerwedel',
      apikey: 'OWI1NDIwMDYtYTBiYy00NThjLWEyOWUtMzBiMDRkY2U3MTJh',
      baseUrl: 'https://greenfield.cognitedata.com');
  client.getTimeSeries().then((res) {
    if (res != null) {
      res.forEach((k) => print(k.externalId));
    }
  });
}

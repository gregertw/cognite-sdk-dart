import 'package:cognite_cdf_sdk/cognite_cdf_sdk.dart';
import 'package:dio/adapter.dart';

main() async {
  var apiClient = CDFApiClient(
      project: 'project_name',
      apikey: 'myapi_key',
      baseUrl: 'https://api.cognitedata.com/',
      httpAdapter: DefaultHttpClientAdapter());

  var res = await TimeSeriesAPI(apiClient).getAllTimeSeries();
  if (res != null && res.length >= 1) {
    print(res[0].externalId);
  }
}

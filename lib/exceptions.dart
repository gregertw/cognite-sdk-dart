part of 'package:cognite_cdf_sdk/cognite_cdf_sdk.dart';

class CDFApiClientParameterException implements Exception {
  String errMsg() => 'API parameters do not satisfy requirements';
}

class CDFApiClientDatapointFilterException implements Exception {
  String errMsg() => 'Filter for datapoints is invalid';
}
